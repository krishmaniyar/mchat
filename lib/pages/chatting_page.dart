import 'dart:async';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';
import 'package:path/path.dart' as path;
import 'package:flutter_downloader/flutter_downloader.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:dio/dio.dart';
import 'package:path_provider/path_provider.dart';
import '../models/auth_handler.dart';
import '../models/chat_api_service.dart';

class ChattingPage extends StatefulWidget {
  final String contactName;
  final bool isGroup;
  final int chatId;

  const ChattingPage({
    super.key,
    required this.contactName,
    required this.chatId,
    this.isGroup = false,
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
  List<dynamic> messages = [];
  Timer? _messageFetchTimer;
  bool _showAttachmentPanel = false;
  List<File> _selectedFiles = [];
  final Dio _dio = Dio();
  bool isLoading = true;
  late final userId;
  late final userName;
  late final userGuid;

  @override
  void initState() {
    super.initState();
    _initializeChat();
  }

  Future<void> _initializeChat() async {
    userId = await AuthHandler.getUserId();
    userName = await AuthHandler.getUserName();
    userGuid = await AuthHandler.getGuid();
    await _loadMessages();
    _startMessageFetchTimer();
  }

  Future<void> _loadMessages() async {
    try {
      final response = await ChatApiService.getChatMessages(widget.chatId);
      if (mounted) {
        setState(() {
          messages = response;
          isLoading = false;
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() => isLoading = false);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error loading messages: ${e.toString()}')),
        );
      }
    }
  }

  void _startMessageFetchTimer() {
    _messageFetchTimer = Timer.periodic(const Duration(seconds: 5), (timer) async {
      await _loadMessages();
    });
  }

  Future<void> _sendMessage() async {
    if (messageController.text.trim().isEmpty || userId == null) return;

    try {
      await ChatApiService.sendMessage(widget.chatId, userId, userName, messageController.text, userGuid);
      await _loadMessages();
      messageController.clear();
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error sending message: ${e.toString()}')),
      );
    }
  }

  Future<void> _sendFiles() async {
    if (_selectedFiles.isEmpty || userId == null) return;

    try {
      await ChatApiService.sendMessageFile(widget.chatId, userId, userName, messageController.text, userGuid, _selectedFiles);
      await _loadMessages();
      messageController.clear();
      setState(() {
        _selectedFiles.clear();
        _showAttachmentPanel = false;
      });
      await _loadMessages();
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error sending files: ${e.toString()}')),
      );
    }
  }

  Future<void> _pickFiles() async {
    try {
      final result = await FilePicker.platform.pickFiles(
        allowMultiple: true,
        type: FileType.any,
      );

      if (result != null && mounted) {
        setState(() {
          // Convert PlatformFile to File objects
          _selectedFiles.addAll(result.files.map((platformFile) => File(platformFile.path!)));
        });
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

  Future<void> _deleteMessage(dynamic message) async {
    if (message['userId'] != userId) return;

    try {
      await ChatApiService.deleteMessage(message['chatId'], message['messageId'], message['userId'], message['uid']);
      await _loadMessages();
      _showInfoSnackbar('Message deleted');
    } catch (e) {
      _showErrorSnackbar('Error deleting message: ${e.toString()}');
    }
  }

  Future<void> _toggleFavorite(dynamic message) async {
    try {
      await ChatApiService.markStarMessage(message['chatId'], message['uid'], message['userId'], message['isStarMark'] ? 0 : 1);
      await _loadMessages();
      _showInfoSnackbar('Message favorite status updated');
    } catch (e) {
      _showErrorSnackbar('Error updating favorite: ${e.toString()}');
    }
  }

  Future<void> _downloadFile(dynamic message) async {
    if (message['fileName'] == null) {
      _showErrorSnackbar('No file to download');
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

      final fileName = message['fileName'];
      final savePath = path.join(directory.path, fileName);

      _showInfoSnackbar('Downloading $fileName...');

      // TODO: Replace with actual file download URL
      await _dio.download(
        'https://example.com/files/${message['fileName']}',
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
            url: 'https://example.com/files/${message['fileName']}',
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
    _messageFetchTimer?.cancel();
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
            // App Bar
            Container(
              padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 0),
              color: Colors.white,
              child: Row(
                children: [
                  IconButton(
                    onPressed: () => Navigator.pop(context),
                    icon: Icon(Icons.arrow_back, size: boldFontSize),
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
            Expanded(
              child: isLoading
                  ? Center(child: CircularProgressIndicator())
                  : ListView.builder(
                reverse: true,
                padding: const EdgeInsets.all(16),
                itemCount: messages.length,
                itemBuilder: (context, index) {
                  final message = messages[messages.length - 1 - index];
                  final isSender = message['userId'] == userId;
                  final hasFile = message['fileName'] != null;
                  final hasText = message['text'] != null;

                  return hasFile
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
                          _getFileIcon(file.path),
                          color: Colors.blue[700],
                        ),
                        title: Text(path.basename(file.path), overflow: TextOverflow.ellipsis),
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

  Widget _buildFileMessageBubble(dynamic message, {required bool isSender}) {
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
                        _getFileIcon(message['fileName']),
                        size: 30,
                        color: isSender ? Colors.white : Colors.black,
                      ),
                      const SizedBox(width: 10),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            message['fileName'] ?? 'File',
                            style: TextStyle(
                              fontSize: normalFontSize - 2,
                              fontWeight: FontWeight.w700,
                              color: isSender ? Colors.white : Colors.black,
                            ),
                          ),
                          Text(
                            path.extension(message['fileName'] ?? '').toUpperCase(),
                            style: TextStyle(
                              fontSize: normalFontSize - 4,
                              color: isSender ? Colors.white : Colors.black,
                            ),
                          ),
                        ],
                      ),
                      if (message['isStarMark'] == true)
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
            "${message['name']} • ${_formatTimestamp(DateTime.parse(message['timestamp']))}",
            style: TextStyle(color: greyColor, fontSize: 12),
          ),
        ),
      ],
    );
  }

  Widget _buildTextMessageBubble(dynamic message, {required bool isSender}) {
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
                        message['text'] ?? '',
                        style: TextStyle(
                          color: isSender ? Colors.white : Colors.black,
                          fontSize: normalFontSize - 2,
                        ),
                      ),
                    ),
                    if (message['isStarMark'] == true)
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
            "${message['name']} • ${_formatTimestamp(DateTime.parse(message['timestamp']))}",
            style: const TextStyle(color: Colors.grey, fontSize: 12),
          ),
        ),
      ],
    );
  }

  String _formatTimestamp(DateTime timestamp) {
    return '${timestamp.hour}:${timestamp.minute.toString().padLeft(2, '0')}';
  }

  Widget _buildMessagePopupMenu(dynamic message) {
    final canDelete = message['userId'] == userId;
    final hasFile = message['fileName'] != null;

    return PopupMenuButton<int>(
      icon: Icon(Icons.more_vert, color: Colors.grey[500]),
      itemBuilder: (context) => [
        if (hasFile)
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
                message['isStarMark'] == true ? Icons.star : Icons.star_border,
                color: message['isStarMark'] == true ? Colors.yellow : Colors.grey,
              ),
              const SizedBox(width: 8),
              Text(message['isStarMark'] == true ? "Unfavorite" : "Favorite"),
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