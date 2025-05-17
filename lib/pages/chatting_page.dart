import 'dart:async';
import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';
import 'package:path/path.dart' as path;
import 'package:flutter_downloader/flutter_downloader.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:dio/dio.dart';
import 'package:path_provider/path_provider.dart';
import '../models/json_handler.dart';
import '../models/auth_handler.dart';

class ChattingPage extends StatefulWidget {
  final String contactName;
  final bool isGroup;

  const ChattingPage({
    super.key,
    required this.contactName,
    this.isGroup = false
  });

  @override
  State<ChattingPage> createState() => _ChattingPageState();
}

class _ChattingPageState extends State<ChattingPage> {
  double boldFontSize = 30.0;
  double normalFontSize = 20.0;
  Color? greyColor = Colors.grey[700];
  Color? blueColor = Colors.blue[700];

  final List<String> options = [
    '1 Minute',
    '5 Minute',
    '1 Hour',
    '8 Hour',
    '12 Hour',
    '1 Day',
    '1 Week',
    '1 Month',
    '1 Year',
    'Off'
  ];

  String selectedOption = 'Off';
  final TextEditingController messageController = TextEditingController();
  List<Message> messages = [];
  Timer? _expirationTimer;
  bool _showAttachmentPanel = false;
  List<PlatformFile> _selectedFiles = [];
  final Dio _dio = Dio();
  String? currentUser;

  @override
  void initState() {
    super.initState();
    _loadCurrentUser();
    _loadMessages();
    _startExpirationTimer();
    FlutterDownloader.initialize(debug: true);
  }

  Future<void> _loadCurrentUser() async {
    currentUser = await AuthHandler.getCurrentUser();
  }

  @override
  void dispose() {
    _expirationTimer?.cancel();
    _dio.close();
    super.dispose();
  }

  Future<void> _loadMessages() async {
    final loadedMessages = await JsonHandler.readMessages(
        groupName: widget.isGroup ? widget.contactName : null
    );
    setState(() {
      messages = loadedMessages;
    });
  }

  void _startExpirationTimer() {
    _expirationTimer = Timer.periodic(Duration(seconds: 10), (timer) async {
      await _checkForExpiredMessages();
    });
  }

  Future<void> _checkForExpiredMessages() async {
    final currentMessages = await JsonHandler.readMessages(
        groupName: widget.isGroup ? widget.contactName : null
    );
    if (mounted) {
      setState(() {
        messages = currentMessages;
      });
    }
  }

  Duration? _getDurationFromOption(String option) {
    switch (option) {
      case '1 Minute': return Duration(minutes: 1);
      case '5 Minute': return Duration(minutes: 5);
      case '1 Hour': return Duration(hours: 1);
      case '8 Hour': return Duration(hours: 8);
      case '12 Hour': return Duration(hours: 12);
      case '1 Day': return Duration(days: 1);
      case '1 Week': return Duration(days: 7);
      case '1 Month': return Duration(days: 30);
      case '1 Year': return Duration(days: 365);
      case 'Off':
      default: return null;
    }
  }

  Future<void> _sendMessage() async {
    if (messageController.text.trim().isEmpty) return;

    final newMessage = Message(
      sender: currentUser ?? "You",
      content: messageController.text,
      timestamp: DateTime.now(),
      isSender: true,
      expiresAfter: _getDurationFromOption(selectedOption),
    );

    await JsonHandler.addMessage(
        newMessage,
        groupName: widget.isGroup ? widget.contactName : null
    );

    if (mounted) {
      setState(() {
        messages.add(newMessage);
        messageController.clear();
      });
    }
  }

  Future<void> _sendFiles() async {
    if (_selectedFiles.isEmpty) return;

    for (var file in _selectedFiles) {
      final newMessage = Message(
        sender: currentUser ?? "You",
        content: file.name,
        timestamp: DateTime.now(),
        isSender: true,
        isFile: true,
        expiresAfter: _getDurationFromOption(selectedOption),
        fileName: file.name,
        fileType: path.extension(file.name).replaceFirst('.', ''),
        fileUrl: 'https://example.com/${file.name}', // Replace with actual URL
      );

      await JsonHandler.addMessage(
          newMessage,
          groupName: widget.isGroup ? widget.contactName : null
      );
    }

    if (mounted) {
      setState(() {
        _selectedFiles.clear();
        _showAttachmentPanel = false;
        _loadMessages();
      });
    }
  }

  Future<void> _pickFiles() async {
    try {
      FilePickerResult? result = await FilePicker.platform.pickFiles(
        allowMultiple: true,
        type: FileType.any,
      );

      if (result != null) {
        setState(() {
          _selectedFiles.addAll(result.files);
        });
      }
    } catch (e) {
      debugPrint('File picking error: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error picking files: $e')),
      );
    }
  }

  Future<void> _removeFile(int index) async {
    setState(() {
      _selectedFiles.removeAt(index);
    });
  }

  Future<void> _deleteMessage(Message message) async {
    await JsonHandler.deleteMessage(
        message,
        groupName: widget.isGroup ? widget.contactName : null
    );
    if (mounted) {
      setState(() {
        messages.removeWhere((m) =>
        m.sender == message.sender &&
            m.content == message.content &&
            m.timestamp == message.timestamp
        );
      });
    }
  }

  Future<void> _toggleFavorite(Message message) async {
    await JsonHandler.toggleFavorite(
        message,
        groupName: widget.isGroup ? widget.contactName : null
    );
    if (mounted) {
      await _loadMessages();
    }
  }

  Future<void> _downloadFile(Message message) async {
    try {
      if (message.fileUrl == null || message.fileUrl!.isEmpty) {
        throw Exception('No download URL available');
      }

      // Request storage permission
      if (Platform.isAndroid) {
        var status = await Permission.storage.status;
        if (!status.isGranted) {
          status = await Permission.storage.request();
        }

        if (status.isPermanentlyDenied) {
          openAppSettings();
          throw Exception('Storage permission permanently denied. Please enable it in app settings.');
        }

        if (!status.isGranted) {
          throw Exception('Storage permission denied');
        }
      } else if (Platform.isIOS) {
        final status = await Permission.photos.status;
        if (!status.isGranted) {
          await Permission.photos.request();
        }
      }

      // Get the download directory
      Directory? directory;
      if (Platform.isAndroid) {
        directory = Directory('/storage/emulated/0/Download');
        if (!await directory.exists()) {
          directory = await getExternalStorageDirectory();
        }
      } else {
        directory = await getApplicationDocumentsDirectory();
      }

      if (directory == null) {
        throw Exception('Cannot access download directory');
      }

      // Create the file name
      final fileName = message.fileName ??
          'file_${DateTime.now().millisecondsSinceEpoch}.${message.fileType ?? 'dat'}';
      final savePath = path.join(directory.path, fileName);

      // Show download progress
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Downloading $fileName...')),
      );

      // Download the file
      await _dio.download(
        message.fileUrl!,
        savePath,
        onReceiveProgress: (received, total) {
          if (total != -1) {
            final progress = (received / total * 100).toStringAsFixed(0);
            debugPrint('Download progress: $progress%');
          }
        },
      );

      // Show success message
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('File saved to ${directory.path}/$fileName'),
          duration: Duration(seconds: 3),
        ),
      );

      // For Android, notify the media scanner
      if (Platform.isAndroid) {
        try {
          final savedFile = File(savePath);
          if (await savedFile.exists()) {
            await FlutterDownloader.registerCallback((id, status, progress) {});
            await FlutterDownloader.enqueue(
              url: message.fileUrl!,
              savedDir: directory.path,
              fileName: fileName,
              showNotification: true,
              openFileFromNotification: true,
            );
          }
        } catch (e) {
          debugPrint('Media scan error: $e');
        }
      }

    } catch (e) {
      debugPrint('Download error: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Download failed: ${e.toString()}'),
          duration: Duration(seconds: 3),
        ),
      );
    }
  }

  IconData _getFileIcon(String fileName) {
    final ext = path.extension(fileName).toLowerCase();
    switch (ext) {
      case '.pdf': return Icons.picture_as_pdf;
      case '.doc': case '.docx': return Icons.description;
      case '.xls': case '.xlsx': return Icons.table_chart;
      case '.jpg': case '.jpeg': case '.png': case '.gif': return Icons.image;
      case '.mp3': case '.wav': return Icons.audiotrack;
      case '.mp4': case '.mov': case '.avi': return Icons.videocam;
      case '.zip': case '.rar': return Icons.archive;
      default: return Icons.insert_drive_file;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          children: [
            // App Bar
            Container(
              padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 0),
              color: Colors.white,
              child: Row(
                children: [
                  IconButton(
                    onPressed: () => Navigator.pop(context),
                    icon: Icon(CupertinoIcons.back, size: boldFontSize),
                  ),
                  const SizedBox(width: 5),
                  Stack(
                    children: [
                      CircleAvatar(
                        radius: 25,
                        backgroundColor: Colors.blue[200],
                        child: Text(
                          widget.contactName[0].toUpperCase(),
                          style: TextStyle(
                            color: Colors.blue[800],
                            fontSize: normalFontSize,
                          ),
                        ),
                      ),
                      if (!widget.isGroup) Positioned(
                        right: 0,
                        bottom: 0,
                        child: Container(
                          padding: const EdgeInsets.all(7.5),
                          decoration: BoxDecoration(
                            border: Border.all(width: 2, color: Colors.white),
                            borderRadius: BorderRadius.circular(90.0),
                            color: Colors.green,
                          ),
                        ),
                      )
                    ],
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(widget.contactName,
                            style: TextStyle(
                                fontSize: normalFontSize,
                                fontWeight: FontWeight.w700)),
                        Text(widget.isGroup ? "Group" : "online",
                            style: TextStyle(fontSize: normalFontSize - 3)),
                      ],
                    ),
                  ),
                  PopupMenuButton<String>(
                    icon: Icon(Icons.more_vert),
                    initialValue: selectedOption,
                    onSelected: (String value) {
                      setState(() {
                        selectedOption = value;
                      });
                    },
                    itemBuilder: (BuildContext context) {
                      return options.map((String option) {
                        return PopupMenuItem<String>(
                          value: option,
                          child: Row(
                            children: [
                              Radio<String>(
                                value: option,
                                groupValue: selectedOption,
                                onChanged: (_) {},
                              ),
                              SizedBox(width: 8),
                              Text(option),
                            ],
                          ),
                        );
                      }).toList();
                    },
                  ),
                  SizedBox(width: 5),
                ],
              ),
            ),
            const Divider(),

            // Messages List
            Expanded(
              child: SingleChildScrollView(
                reverse: true,
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Column(
                  children: messages.reversed.map((message) {
                    if (message.isFile) {
                      return _buildFileMessageBubble(
                        message,
                        isSender: message.isSender,
                      );
                    } else {
                      return _buildTextMessageBubble(
                        message,
                        isSender: message.isSender,
                      );
                    }
                  }).toList(),
                ),
              ),
            ),
            const Divider(),

            // Attachment Panel
            if (_showAttachmentPanel)
              Container(
                padding: const EdgeInsets.all(10),
                margin: const EdgeInsets.symmetric(horizontal: 20),
                decoration: BoxDecoration(
                  color: Colors.grey[200],
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Column(
                  children: [
                    if (_selectedFiles.isEmpty)
                      Text(
                        'No files selected',
                        style: TextStyle(color: greyColor),
                      )
                    else
                      ..._selectedFiles.map((file) => ListTile(
                        leading: Icon(
                          _getFileIcon(file.name),
                          color: Colors.blue[700],
                        ),
                        title: Text(
                          file.name,
                          overflow: TextOverflow.ellipsis,
                        ),
                        trailing: IconButton(
                          icon: Icon(Icons.close, color: Colors.red),
                          onPressed: () => _removeFile(_selectedFiles.indexOf(file)),
                        ),
                      )).toList(),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        ElevatedButton(
                          onPressed: _pickFiles,
                          child: const Text('Add Files'),
                        ),
                        ElevatedButton(
                          onPressed: _sendFiles,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.blue[700],
                          ),
                          child: const Text('Send All', style: TextStyle(color: Colors.white)),
                        ),
                      ],
                    ),
                  ],
                ),
              ),

            // Message Input
            Container(
              padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 20),
              child: TextField(
                controller: messageController,
                keyboardType: TextInputType.text,
                style: TextStyle(fontSize: normalFontSize),
                decoration: InputDecoration(
                  prefixIcon: IconButton(
                    onPressed: () {
                      setState(() {
                        _showAttachmentPanel = !_showAttachmentPanel;
                      });
                    },
                    icon: const Icon(Icons.attach_file_outlined),
                  ),
                  suffixIcon: IconButton(
                    onPressed: _sendMessage,
                    icon: const Icon(Icons.send_outlined),
                  ),
                  hintText: "Type message",
                  contentPadding: const EdgeInsets.symmetric(
                      vertical: 16.0, horizontal: 15.0),
                  focusedBorder: OutlineInputBorder(
                    borderSide: const BorderSide(color: Colors.white),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  enabledBorder: UnderlineInputBorder(
                    borderSide: const BorderSide(color: Colors.white),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  filled: true,
                  fillColor: Colors.grey[300],
                ),
                onSubmitted: (_) => _sendMessage(),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFileMessageBubble(Message message, {required bool isSender}) {
    return Column(
      crossAxisAlignment:
      isSender ? CrossAxisAlignment.end : CrossAxisAlignment.start,
      children: [
        Container(
          margin: const EdgeInsets.only(top: 10),
          child: Row(
            mainAxisAlignment:
            isSender ? MainAxisAlignment.end : MainAxisAlignment.start,
            children: [
              if (isSender) _buildMessagePopupMenu(message),
              GestureDetector(
                onTap: () => _downloadFile(message),
                child: Container(
                  padding:
                  const EdgeInsets.symmetric(vertical: 15, horizontal: 20),
                  decoration: BoxDecoration(
                    color: isSender ? Colors.blue[500] : Colors.grey[200],
                    borderRadius: BorderRadius.circular(15),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        _getFileIcon(message.fileName ?? ''),
                        size: 30,
                        color: isSender ? Colors.white : Colors.black,
                      ),
                      const SizedBox(width: 10),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            message.fileName ?? 'File',
                            style: TextStyle(
                              fontSize: normalFontSize - 2,
                              fontWeight: FontWeight.w700,
                              color: isSender ? Colors.white : Colors.black,
                            ),
                            softWrap: true,
                          ),
                          Text(
                            message.fileType?.toUpperCase() ?? 'FILE',
                            style: TextStyle(
                              fontSize: normalFontSize - 4,
                              color: isSender ? Colors.white : Colors.black,
                            ),
                          ),
                        ],
                      ),
                      if (message.isFavorite)
                        Icon(Icons.star, color: Colors.yellow[700], size: 20),
                    ],
                  ),
                ),
              ),
              if (!isSender) _buildMessagePopupMenu(message),
            ],
          ),
        ),
        const SizedBox(height: 5),
        Text("${message.sender} ${_formatTimestamp(message.timestamp)}",
            style: TextStyle(color: greyColor)),
      ],
    );
  }

  Widget _buildTextMessageBubble(Message message, {required bool isSender}) {
    return Column(
      crossAxisAlignment:
      isSender ? CrossAxisAlignment.end : CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 15),
        Row(
          mainAxisAlignment:
          isSender ? MainAxisAlignment.end : MainAxisAlignment.start,
          children: [
            if (!isSender) ...[],
            if (isSender) _buildMessagePopupMenu(message),
            Container(
                constraints: BoxConstraints(maxWidth: MediaQuery.of(context).size.width * 0.7),
                padding:
                const EdgeInsets.symmetric(vertical: 15, horizontal: 20),
                decoration: BoxDecoration(
                  color: isSender ? Colors.blue[500] : Colors.grey[200],
                  borderRadius: BorderRadius.circular(15),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Flexible(
                      child: Text(
                        message.content,
                        style: TextStyle(
                          fontSize: normalFontSize - 2,
                          fontWeight: FontWeight.w700,
                          color: isSender ? Colors.white : Colors.black,
                        ),
                        softWrap: true,
                      ),
                    ),
                    if (message.isFavorite)
                      Padding(
                        padding: EdgeInsets.only(left: 8),
                        child: Icon(Icons.star, color: Colors.yellow[700], size: 20),
                      ),
                  ],
                )
            ),
            if (!isSender) _buildMessagePopupMenu(message),
          ],
        ),
        const SizedBox(height: 5),
        Text("${message.sender} ${_formatTimestamp(message.timestamp)}",
            style: TextStyle(color: greyColor)),
      ],
    );
  }

  String _formatTimestamp(DateTime timestamp) {
    return '${timestamp.month}/${timestamp.day}/${timestamp.year} '
        '${timestamp.hour}:${timestamp.minute.toString().padLeft(2, '0')}:'
        '${timestamp.second.toString().padLeft(2, '0')} '
        '${timestamp.hour < 12 ? 'AM' : 'PM'}';
  }

  Widget _buildMessagePopupMenu(Message message) {
    return PopupMenuButton<int>(
      icon: Icon(Icons.more_vert, color: Colors.grey[500]),
      itemBuilder: (context) => [
        if (message.isFile)
          PopupMenuItem(
            value: 3,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text("Download",
                    style: TextStyle(color: greyColor, fontSize: normalFontSize)),
                Icon(Icons.download,
                    color: greyColor, size: normalFontSize),
              ],
            ),
          ),
        PopupMenuItem(
          value: 1,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(message.isFavorite ? "Unfavorite" : "Favorite",
                  style: TextStyle(color: greyColor, fontSize: normalFontSize)),
              Icon(message.isFavorite ? Icons.star : Icons.star_border_outlined,
                  color: message.isFavorite ? Colors.yellow[700] : greyColor,
                  size: normalFontSize),
            ],
          ),
        ),
        PopupMenuItem(
          value: 2,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text("Delete",
                  style: TextStyle(color: greyColor, fontSize: normalFontSize)),
              Icon(Icons.delete_outline_outlined,
                  color: greyColor, size: normalFontSize),
            ],
          ),
        ),
      ],
      offset: const Offset(0, 40),
      color: Colors.white,
      elevation: 2,
      onSelected: (value) async {
        if (value == 1) {
          await _toggleFavorite(message);
        } else if (value == 2) {
          await _deleteMessage(message);
        } else if (value == 3) {
          await _downloadFile(message);
        }
      },
    );
  }
}