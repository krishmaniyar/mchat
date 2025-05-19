import 'dart:async';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';
import 'package:path/path.dart' as path;
import 'package:flutter_downloader/flutter_downloader.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:dio/dio.dart';
import 'package:path_provider/path_provider.dart';
import '../models/json_handler.dart';
import '../models/auth_handler.dart';

class GroupChatPage extends StatefulWidget {
  final String groupName;

  const GroupChatPage({
    super.key,
    required this.groupName,
  });

  @override
  State<GroupChatPage> createState() => _GroupChatPageState();
}

class _GroupChatPageState extends State<GroupChatPage> {
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
  String? currentUserId;
  List<String> groupMembers = [];

  @override
  void initState() {
    super.initState();
    _initializeChat();
  }

  Future<void> _initializeChat() async {
    await _loadCurrentUser();
    await _loadGroupMembers();
    await _loadMessages();
    _startExpirationTimer();
    await FlutterDownloader.initialize(debug: true);
  }

  Future<void> _loadCurrentUser() async {
    currentUserId = await AuthHandler.getCurrentUser();
    if (mounted) setState(() {});
  }

  Future<void> _loadGroupMembers() async {
    groupMembers = await AuthHandler.getGroupMembers(widget.groupName);
    if (mounted) setState(() {});
  }

  Future<void> _loadMessages() async {
    final loadedMessages = await JsonHandler.readGroupMessages(widget.groupName);
    if (mounted) {
      setState(() {
        messages = loadedMessages;
      });
    }
  }

  void _startExpirationTimer() {
    _expirationTimer = Timer.periodic(const Duration(seconds: 10), (timer) async {
      await _checkForExpiredMessages();
    });
  }

  Future<void> _checkForExpiredMessages() async {
    final currentMessages = await JsonHandler.readGroupMessages(widget.groupName);
    if (mounted && currentMessages.length != messages.length) {
      setState(() => messages = currentMessages);
    }
  }

  Duration? _getDurationFromOption(String option) {
    switch (option) {
      case '1 Minute': return const Duration(minutes: 1);
      case '5 Minute': return const Duration(minutes: 5);
      case '1 Hour': return const Duration(hours: 1);
      case '8 Hour': return const Duration(hours: 8);
      case '12 Hour': return const Duration(hours: 12);
      case '1 Day': return const Duration(days: 1);
      case '1 Week': return const Duration(days: 7);
      case '1 Month': return const Duration(days: 30);
      case '1 Year': return const Duration(days: 365);
      default: return null;
    }
  }

  Future<void> _sendMessage() async {
    if (messageController.text.trim().isEmpty || currentUserId == null) return;

    final newMessage = Message(
      sender: currentUserId!,
      content: messageController.text,
      timestamp: DateTime.now(),
      isSender: currentUserId!,
      expiresAfter: _getDurationFromOption(selectedOption),
    );

    await JsonHandler.addGroupMessage(newMessage, widget.groupName);

    if (mounted) {
      messageController.clear();
      await _loadMessages();
    }
  }

  Future<void> _sendFiles() async {
    if (_selectedFiles.isEmpty || currentUserId == null) return;

    for (final file in _selectedFiles) {
      final newMessage = Message(
        sender: currentUserId!,
        content: file.name,
        timestamp: DateTime.now(),
        isSender: currentUserId!,
        isFile: true,
        expiresAfter: _getDurationFromOption(selectedOption),
        fileName: file.name,
        fileType: path.extension(file.name).replaceFirst('.', ''),
        fileUrl: 'https://example.com/${file.name}',
      );

      await JsonHandler.addGroupMessage(newMessage, widget.groupName);
    }

    if (mounted) {
      setState(() {
        _selectedFiles.clear();
        _showAttachmentPanel = false;
      });
      await _loadMessages();
    }
  }

  Future<void> _pickFiles() async {
    try {
      final result = await FilePicker.platform.pickFiles(
        allowMultiple: true,
        type: FileType.any,
      );

      if (result != null && mounted) {
        setState(() => _selectedFiles.addAll(result.files));
      }
    } catch (e) {
      _showErrorSnackbar('File picking error: $e');
    }
  }

  Future<void> _removeFile(int index) async {
    if (mounted) {
      setState(() => _selectedFiles.removeAt(index));
    }
  }

  Future<void> _deleteMessage(Message message) async {
    if (message.sender != currentUserId) return;

    await JsonHandler.deleteGroupMessage(message, widget.groupName);

    if (mounted) await _loadMessages();
  }

  Future<void> _toggleFavorite(Message message) async {
    await JsonHandler.toggleFavoriteGroupMessage(message, widget.groupName);

    if (mounted) await _loadMessages();
  }

  Future<void> _downloadFile(Message message) async {
    if (message.fileUrl == null || message.fileUrl!.isEmpty) {
      _showErrorSnackbar('No download URL available');
      return;
    }

    try {
      if (Platform.isAndroid) {
        final status = await Permission.storage.request();
        if (status.isPermanentlyDenied) {
          openAppSettings();
          return;
        }
        if (!status.isGranted) {
          throw Exception('Storage permission denied');
        }
      } else if (Platform.isIOS) {
        await Permission.photos.request();
      }

      final directory = Platform.isAndroid
          ? Directory('/storage/emulated/0/Download')
          : await getApplicationDocumentsDirectory();

      if (directory == null || !await directory.exists()) {
        throw Exception('Cannot access download directory');
      }

      final fileName = message.fileName ??
          'file_${DateTime.now().millisecondsSinceEpoch}.${message.fileType ?? 'dat'}';
      final savePath = path.join(directory.path, fileName);

      _showInfoSnackbar('Downloading $fileName...');

      await _dio.download(
        message.fileUrl!,
        savePath,
        onReceiveProgress: (received, total) {
          if (total != -1) {
            debugPrint('Download progress: ${(received / total * 100).toStringAsFixed(0)}%');
          }
        },
      );

      _showInfoSnackbar('File saved to ${directory.path}/$fileName');

      if (Platform.isAndroid) {
        try {
          await FlutterDownloader.enqueue(
            url: message.fileUrl!,
            savedDir: directory.path,
            fileName: fileName,
            showNotification: true,
            openFileFromNotification: true,
          );
        } catch (e) {
          debugPrint('Media scan error: $e');
        }
      }
    } catch (e) {
      _showErrorSnackbar('Download failed: ${e.toString()}');
    }
  }

  IconData _getFileIcon(String? fileName) {
    final ext = fileName != null ? path.extension(fileName).toLowerCase() : '';
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

  void _showErrorSnackbar(String message) {
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(message),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  void _showInfoSnackbar(String message) {
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(message)),
      );
    }
  }

  @override
  void dispose() {
    _expirationTimer?.cancel();
    _dio.close();
    messageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          children: [
            // App Bar with Group Members
            Container(
              padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 0),
              color: Colors.white,
              child: Column(
                children: [
                  Row(
                    children: [
                      IconButton(
                        onPressed: () => Navigator.pop(context),
                        icon: Icon(Icons.arrow_back, size: boldFontSize),
                      ),
                      const SizedBox(width: 5),
                      CircleAvatar(
                        radius: 25,
                        backgroundColor: Colors.blue[200],
                        child: Text(
                          widget.groupName[0].toUpperCase(),
                          style: TextStyle(
                            color: Colors.blue[800],
                            fontSize: normalFontSize,
                          ),
                        ),
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              widget.groupName,
                              style: TextStyle(
                                fontSize: normalFontSize,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                            Text(
                              "${groupMembers.length} members",
                              style: TextStyle(fontSize: normalFontSize - 3),
                            ),
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
                  // Group Members List
                  if (groupMembers.isNotEmpty)
                    SizedBox(
                      height: 30,
                      child: ListView.builder(
                        scrollDirection: Axis.horizontal,
                        padding: const EdgeInsets.only(left: 60, right: 20, top: 10),
                        itemCount: groupMembers.length,
                        itemBuilder: (context, index) {
                          return Text('${groupMembers[index]}, ');
                        },
                      ),
                    ),
                ],
              ),
            ),
            const Divider(),

            // Messages List
            Expanded(
              child: ListView.builder(
                reverse: true,
                padding: const EdgeInsets.all(16),
                itemCount: messages.length,
                itemBuilder: (context, index) {
                  final message = messages[messages.length - 1 - index];
                  final isSender = message.isSender == currentUserId;

                  return message.isFile
                      ? _buildFileMessageBubble(message, isSender: isSender)
                      : _buildTextMessageBubble(message, isSender: isSender);
                },
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
                      Text('No files selected', style: TextStyle(color: greyColor))
                    else
                      ..._selectedFiles.map((file) => ListTile(
                        leading: Icon(
                          _getFileIcon(file.name),
                          color: Colors.blue[700],
                        ),
                        title: Text(file.name, overflow: TextOverflow.ellipsis),
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
      crossAxisAlignment: isSender ? CrossAxisAlignment.end : CrossAxisAlignment.start,
      children: [
        Container(
          margin: const EdgeInsets.only(top: 10),
          child: Row(
            mainAxisAlignment: isSender ? MainAxisAlignment.end : MainAxisAlignment.start,
            children: [
              if (isSender) _buildMessagePopupMenu(message),
              GestureDetector(
                onTap: () => _downloadFile(message),
                child: Container(
                  padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 20),
                  decoration: BoxDecoration(
                    color: isSender ? Colors.blue[500] : Colors.grey[200],
                    borderRadius: BorderRadius.circular(15),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        _getFileIcon(message.fileName),
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
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8),
          child: Text(
            "${message.sender} • ${_formatTimestamp(message.timestamp)}",
            style: TextStyle(color: greyColor, fontSize: 12),
          ),
        ),
      ],
    );
  }

  Widget _buildTextMessageBubble(Message message, {required bool isSender}) {
    return Column(
      crossAxisAlignment: isSender ? CrossAxisAlignment.end : CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 8),
        Row(
          mainAxisAlignment: isSender ? MainAxisAlignment.end : MainAxisAlignment.start,
          children: [
            if (isSender) _buildMessagePopupMenu(message),
            Flexible(
              child: Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: isSender ? Colors.blue : Colors.grey[200],
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Flexible(
                      child: Text(
                        message.content,
                        style: TextStyle(
                          color: isSender ? Colors.white : Colors.black,
                          fontSize: normalFontSize - 2,
                        ),
                      ),
                    ),
                    if (message.isFavorite)
                      const Padding(
                        padding: EdgeInsets.only(left: 8),
                        child: Icon(Icons.star, color: Colors.yellow, size: 16),
                      ),
                  ],
                ),
              ),
            ),
            if (!isSender) _buildMessagePopupMenu(message),
          ],
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8),
          child: Text(
            "${message.sender} • ${_formatTimestamp(message.timestamp)}",
            style: const TextStyle(color: Colors.grey, fontSize: 12),
          ),
        ),
      ],
    );
  }

  String _formatTimestamp(DateTime timestamp) {
    return '${timestamp.hour}:${timestamp.minute.toString().padLeft(2, '0')}';
  }

  Widget _buildMessagePopupMenu(Message message) {
    final canDelete = message.sender == currentUserId;

    return PopupMenuButton<int>(
      icon: Icon(Icons.more_vert, color: Colors.grey[500]),
      itemBuilder: (context) => [
        if (message.isFile)
          PopupMenuItem(
            value: 3,
            child: Row(
              children: [
                const Icon(Icons.download, color: Colors.grey),
                const SizedBox(width: 8),
                const Text("Download"),
              ],
            ),
          ),
        PopupMenuItem(
          value: 1,
          child: Row(
            children: [
              Icon(
                message.isFavorite ? Icons.star : Icons.star_border,
                color: message.isFavorite ? Colors.yellow : Colors.grey,
              ),
              const SizedBox(width: 8),
              Text(message.isFavorite ? "Unfavorite" : "Favorite"),
            ],
          ),
        ),
        if (canDelete)
          PopupMenuItem(
            value: 2,
            child: Row(
              children: [
                const Icon(Icons.delete, color: Colors.grey),
                const SizedBox(width: 8),
                const Text("Delete"),
              ],
            ),
          ),
      ],
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