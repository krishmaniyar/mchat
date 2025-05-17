import 'package:flutter/material.dart';
import 'package:mchat/models/auth_handler.dart';
import 'package:mchat/models/json_handler.dart';
import 'package:mchat/pages/chatting_page.dart';

class ChatsPage extends StatefulWidget {
  const ChatsPage({super.key});

  @override
  State<ChatsPage> createState() => _ChatsPageState();
}

class _ChatsPageState extends State<ChatsPage> {
  bool isDirect = true;
  final TextEditingController searchController = TextEditingController();
  List<String> users = [];
  List<String> groups = [];
  bool isLoading = true;
  String? currentUser;
  Map<String, List<Message>> chatMessages = {};
  Map<String, List<Message>> groupMessages = {};

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  Future<void> _loadData() async {
    setState(() => isLoading = true);
    try {
      currentUser = await AuthHandler.getCurrentUser();
      final allUsers = await AuthHandler.getAllUsers();
      users = allUsers.where((user) => user != currentUser).toList();

      // Load groups for current user
      groups = await AuthHandler.getUserGroups(currentUser!);

      // Load messages for all chats and groups
      await _loadAllMessages();
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error loading data: ${e.toString()}')),
      );
    } finally {
      setState(() => isLoading = false);
    }
  }

  Future<void> _loadAllMessages() async {
    // Load direct chat messages
    for (final user in users) {
      final messages = await JsonHandler.readMessages();
      chatMessages[user] = messages.where((m) =>
      m.sender == user || (m.isSender && m.sender == currentUser)
      ).toList();
    }

    // Load group messages
    for (final group in groups) {
      final messages = await JsonHandler.readMessages(groupName: group);
      groupMessages[group] = messages;
    }
  }

  String _formatDateTime(DateTime dateTime) {
    return '${dateTime.month}/${dateTime.day}/${dateTime.year} ${dateTime.hour}:${dateTime.minute.toString().padLeft(2, '0')}';
  }

  String _getLastMessagePreview(String chatId, bool isDirect) {
    final messages = isDirect
        ? chatMessages[chatId] ?? []
        : groupMessages[chatId] ?? [];

    if (messages.isEmpty) return "No messages yet";

    final lastMessage = messages.last;
    if (lastMessage.isFile) {
      return "📄 ${lastMessage.fileName ?? 'File'}";
    }
    return lastMessage.content;
  }

  DateTime _getLastMessageTime(String chatId, bool isDirect) {
    final messages = isDirect
        ? chatMessages[chatId] ?? []
        : groupMessages[chatId] ?? [];

    return messages.isNotEmpty ? messages.last.timestamp : DateTime.now();
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

    final horizontalPadding = screenWidth * 0.05;
    final verticalPaddingSmall = screenHeight * 0.0125;
    final verticalPaddingMedium = screenHeight * 0.01875;
    final verticalPaddingLarge = screenHeight * 0.025;

    final avatarRadius = screenWidth * 0.06;
    final containerPaddingVertical = screenHeight * 0.01875;
    final containerPaddingHorizontal = screenWidth * 0.05;
    final containerBorderRadius = screenWidth * 0.035;
    final statusIndicatorSize = screenWidth * 0.035;

    final currentList = isDirect ? users : groups;
    final filteredList = currentList.where((item) =>
        item.toLowerCase().contains(searchController.text.toLowerCase())
    ).toList();

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
                onChanged: (value) => setState(() {}),
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
                          onPressed: () => setState(() => isDirect = true),
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
                          onPressed: () => setState(() => isDirect = false),
                          child: Padding(
                            padding: EdgeInsets.symmetric(
                              vertical: screenHeight * 0.00625,
                              horizontal: screenWidth * 0.025,
                            ),
                            child: Text(
                              "Groups",
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
              else if (filteredList.isEmpty)
                Center(child: Text(
                    isDirect ? "No users found" : "No groups found",
                    style: TextStyle(fontSize: normalFontSize)
                ))
              else
                Expanded(
                  child: ListView.builder(
                    itemCount: filteredList.length,
                    itemBuilder: (context, index) {
                      final item = filteredList[index];
                      final lastMessage = _getLastMessagePreview(item, isDirect);
                      final lastMessageTime = _getLastMessageTime(item, isDirect);

                      return GestureDetector(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => ChattingPage(
                                contactName: item,
                                isGroup: !isDirect,
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
                                      item[0].toUpperCase(),
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
                                        color: index % 2 == 0 ? Colors.green : Colors.red,
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
                                      item,
                                      style: TextStyle(
                                        fontSize: normalFontSize,
                                        fontWeight: FontWeight.w700,
                                      ),
                                    ),
                                    Text(
                                      lastMessage,
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
                                _formatDateTime(lastMessageTime),
                                style: TextStyle(
                                  fontSize: tinyFontSize,
                                  color: greyColor,
                                ),
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