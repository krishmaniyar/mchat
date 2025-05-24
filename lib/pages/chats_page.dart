import 'package:flutter/material.dart';
import '../models/auth_handler.dart';
import '../models/chat_api_service.dart';
import 'chatting_page.dart';
import 'group_chat_page.dart';

class ChatsPage extends StatefulWidget {
  const ChatsPage({super.key});

  @override
  State<ChatsPage> createState() => _ChatsPageState();
}

class _ChatsPageState extends State<ChatsPage> {
  bool isDirect = true;
  late int userid;
  final TextEditingController searchController = TextEditingController();
  bool isLoading = true;
  List<dynamic> chatList = [];
  List<dynamic> filteredChatList = [];

  @override
  initState() {
    super.initState();
    _loadChatList();
  }

  Future<void> _loadChatList() async {
    userid = await AuthHandler.getUserId();
    setState(() => isLoading = true);
    try {
      final type = isDirect ? 1 : 0;
      final response = await ChatApiService.getChatList(userid, type);
      setState(() {
        chatList = response;
        filteredChatList = chatList;
      });
    } catch (e) {
      print("Error loading chat");
    } finally {
      if (mounted) {
        setState(() => isLoading = false);
      }
    }
  }

  void _filterDirectChats() {
    final query = searchController.text.toLowerCase();
    setState(() {
      filteredChatList = chatList.where((chat) {
        return chat['user'][1]["userName"].toString().toLowerCase().contains(query);
      }).toList();
    });
  }

  void _filterChats() {
    final query = searchController.text.toLowerCase();
    setState(() {
      filteredChatList = chatList.where((chat) {
        return chat['name'].toString().toLowerCase().contains(query);
      }).toList();
    });
  }

  String _getDisplayName(Map<String, dynamic> chat, int currentUserId) {
    if (chat['type'] == 1 && chat['user'] != null && chat['user'].length >= 2) {
      for (var user in chat['user']) {
        if (user['userId'] != currentUserId) {
          return user['userName'] ?? 'Unknown';
        }
      }
    }
    return chat['name'] ?? 'Unknown';
  }

  Future<String> _getLastMessage(int chatId) async {
    try {
      List response = await ChatApiService.getChatMessages(chatId);
      print(response[-1]['text']);
      return response[-1]['text'];
    }
    catch (e) {
      return 'No Message yet';
    }
  }

  String _formatDateTime(DateTime dateTime) {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final messageDate = DateTime(dateTime.year, dateTime.month, dateTime.day);

    if (messageDate == today) {
      return '${dateTime.hour}:${dateTime.minute.toString().padLeft(2, '0')}';
    } else if (messageDate == today.subtract(const Duration(days: 1))) {
      return 'Yesterday';
    } else {
      return '${dateTime.month}/${dateTime.day}/${dateTime.year}';
    }
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    final boldFontSize = screenHeight * 0.035;
    final normalFontSize = screenHeight * 0.025;
    final smallFontSize = screenHeight * 0.02;
    final tinyFontSize = screenHeight * 0.015;

    final greyColor = Colors.grey[700];
    final blueColor = Colors.blue[700];

    final horizontalPadding = screenWidth * 0.05;
    final verticalPaddingSmall = screenHeight * 0.0125;
    final verticalPaddingMedium = screenHeight * 0.01875;
    final verticalPaddingLarge = screenHeight * 0.025;

    final avatarRadius = screenWidth * 0.06;
    final containerPaddingVertical = screenHeight * 0.01875;
    final containerPaddingHorizontal = screenWidth * 0.05;
    final containerBorderRadius = screenWidth * 0.035;
    final statusIndicatorSize = screenWidth * 0.035;
    final buttonBorderRadius = screenWidth * 0.025;

    return Scaffold(
      backgroundColor: Colors.grey[200],
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.symmetric(
            vertical: 0.0,
            horizontal: horizontalPadding,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "Chats",
                style: TextStyle(
                  fontSize: boldFontSize,
                  fontWeight: FontWeight.w600,
                ),
              ),
              SizedBox(height: verticalPaddingSmall),
              const Divider(),
              SizedBox(height: verticalPaddingMedium),
              TextField(
                controller: searchController,
                keyboardType: TextInputType.text,
                style: TextStyle(
                  fontSize: normalFontSize,
                ),
                decoration: InputDecoration(
                  suffixIcon: Icon(Icons.search),
                  hintText: isDirect ? "Search user" : "Search group",
                  contentPadding: EdgeInsets.symmetric(
                    vertical: screenHeight * 0.02,
                    horizontal: screenWidth * 0.0375,
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderSide: const BorderSide(color: Colors.white),
                    borderRadius: BorderRadius.circular(screenWidth * 0.05),
                  ),
                  enabledBorder: UnderlineInputBorder(
                    borderSide: const BorderSide(color: Colors.white),
                    borderRadius: BorderRadius.circular(screenWidth * 0.05),
                  ),
                  filled: true,
                  fillColor: Colors.grey[300],
                ),
                onChanged: (value) => isDirect ? _filterDirectChats() : _filterChats(),
              ),
              SizedBox(height: verticalPaddingMedium),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    padding: EdgeInsets.all(screenWidth * 0.0125),
                    decoration: BoxDecoration(
                      color: Colors.grey[300],
                      borderRadius: BorderRadius.circular(screenWidth * 0.0875),
                    ),
                    child: Row(
                      children: [
                        TextButton(
                          style: ButtonStyle(
                            backgroundColor: WidgetStateProperty.all<Color>((isDirect ? Colors.white : Colors.grey[300])!),
                            shape: WidgetStateProperty.all<RoundedRectangleBorder>(
                              RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(screenWidth * 0.075),
                              ),
                            ),
                          ),
                          onPressed: () {
                            setState(() {
                              isDirect = true;
                              _loadChatList();
                            });
                          },
                          child: Padding(
                            padding: EdgeInsets.symmetric(
                              vertical: screenHeight * 0.00625,
                              horizontal: screenWidth * 0.025,
                            ),
                            child: Text(
                              "Direct",
                              style: TextStyle(
                                fontSize: normalFontSize,
                                fontWeight: FontWeight.w400,
                                color: (isDirect ? Colors.grey[700] : Colors.grey[500]),
                              ),
                            ),
                          ),
                        ),
                        SizedBox(width: screenWidth * 0.025),
                        TextButton(
                          style: ButtonStyle(
                            backgroundColor: WidgetStateProperty.all<Color>((!isDirect ? Colors.white : Colors.grey[300])!),
                            shape: WidgetStateProperty.all<RoundedRectangleBorder>(
                              RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(screenWidth * 0.075),
                              ),
                            ),
                          ),
                          onPressed: () {
                            setState(() {
                              isDirect = false;
                              _loadChatList();
                            });
                          },
                          child: Padding(
                            padding: EdgeInsets.symmetric(
                              vertical: screenHeight * 0.00625,
                              horizontal: screenWidth * 0.025,
                            ),
                            child: Text(
                              "Group",
                              style: TextStyle(
                                fontSize: normalFontSize,
                                fontWeight: FontWeight.w400,
                                color: (!isDirect ? Colors.grey[700] : Colors.grey[500]),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  )
                ],
              ),
              SizedBox(height: verticalPaddingLarge),

              if (isLoading)
                Center(child: CircularProgressIndicator())
              else if (filteredChatList.isEmpty)
                Center(child: Text(
                    isDirect ? "No direct chats found" : "No group chats found",
                    style: TextStyle(fontSize: normalFontSize)
                ))
              else
                Expanded(
                  child: ListView.builder(
                    itemCount: filteredChatList.length,
                    itemBuilder: (context, index) {
                      final chat = filteredChatList[index];
                      final chatName = _getDisplayName(chat, userid);
                      final uniqueId = chat['uniqueIdentifier'] ?? '';
                      final lastMessage = _getLastMessage(chat['chatId']);
                      return GestureDetector(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => isDirect
                                ? ChattingPage(
                                  contactName: chatName,
                                  isGroup: false,
                                  chatId: chat['chatId'],
                                )
                                : GroupChatPage(
                                  groupName: chatName,
                                  chatId: chat['chatId'],
                                ),
                            ),
                          );
                        },
                        child: Container(
                          padding: EdgeInsets.symmetric(
                            vertical: containerPaddingVertical,
                            horizontal: containerPaddingHorizontal,
                          ),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(containerBorderRadius),
                            border: Border.all(
                              color: Colors.blue.shade500,
                              width: 2,
                            ),
                          ),
                          margin: EdgeInsets.only(bottom: verticalPaddingMedium),
                          child: Row(
                            children: [
                              Stack(
                                children: [
                                  CircleAvatar(
                                    radius: avatarRadius,
                                    backgroundColor: Colors.blue[200],
                                    child: Text(
                                      chatName.isNotEmpty ? chatName[0].toUpperCase() : '?',
                                      style: TextStyle(
                                        color: Colors.blue[800],
                                        fontSize: normalFontSize,
                                      ),
                                    ),
                                  ),
                                  if (isDirect) Positioned(
                                    right: 0,
                                    bottom: 0,
                                    child: Container(
                                      padding: EdgeInsets.all(statusIndicatorSize * 0.5),
                                      decoration: BoxDecoration(
                                        border: Border.all(
                                          width: 2,
                                          color: Colors.white,
                                        ),
                                        borderRadius: BorderRadius.circular(statusIndicatorSize),
                                        color: chat['user'][1]['status'] == 1 ? Colors.green : Colors.red,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              SizedBox(width: screenWidth * 0.025),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      chatName,
                                      style: TextStyle(
                                        fontSize: normalFontSize,
                                        fontWeight: FontWeight.w700,
                                      ),
                                    ),
                                    Text(
                                      uniqueId,
                                      style: TextStyle(
                                        fontSize: smallFontSize,
                                      ),
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  ],
                                ),
                              ),
                              SizedBox(width: screenWidth * 0.025),
                              Text(
                                _formatDateTime(DateTime.now()), // Using current time as placeholder
                                style: TextStyle(
                                  fontSize: tinyFontSize,
                                  color: greyColor,
                                ),
                              ),
                              PopupMenuButton<String>(
                                icon: Icon(Icons.more_vert, size: normalFontSize),
                                onSelected: (value) {
                                  if (value == 'clear') {
                                    // Implement clear functionality if needed
                                  }
                                },
                                itemBuilder: (BuildContext context) {
                                  return [
                                    PopupMenuItem<String>(
                                      value: 'clear',
                                      child: Text('Clear messages'),
                                    ),
                                  ];
                                },
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}