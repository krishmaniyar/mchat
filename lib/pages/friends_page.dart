import 'package:flutter/material.dart';
import '../models/auth_handler.dart';
import 'chatting_page.dart';

class FriendsPage extends StatefulWidget {
  const FriendsPage({super.key});

  @override
  State<FriendsPage> createState() => _FriendsPageState();
}

class _FriendsPageState extends State<FriendsPage> {
  final TextEditingController searchController = TextEditingController();
  List<String> users = [];
  bool isLoading = true;
  String? currentUser;

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
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error loading data: ${e.toString()}')),
      );
    } finally {
      if (mounted) {
        setState(() => isLoading = false);
      }
    }
  }

  void _startChat(String contactName) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => ChattingPage(contactName: contactName, isGroup: false),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    final boldFontSize = screenHeight * 0.035;
    final normalFontSize = screenHeight * 0.025;
    final smallFontSize = screenHeight * 0.02;

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

    final filteredUsers = users.where((user) =>
        user.toLowerCase().contains(searchController.text.toLowerCase())
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
                "Friends",
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
                  hintText: "Search user",
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
              SizedBox(height: verticalPaddingLarge),

              if (isLoading)
                Center(child: CircularProgressIndicator())
              else if (filteredUsers.isEmpty)
                Center(child: Text(
                    "No users found",
                    style: TextStyle(fontSize: normalFontSize)
                ))
              else
                Expanded(
                  child: ListView.builder(
                    itemCount: filteredUsers.length,
                    itemBuilder: (context, index) {
                      final user = filteredUsers[index];
                      return GestureDetector(
                        onTap: () => {
                          _startChat(user)
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
                              color: Colors.transparent,
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
                                      user[0].toUpperCase(),
                                      style: TextStyle(
                                        color: Colors.blue[800],
                                        fontSize: normalFontSize,
                                      ),
                                    ),
                                  ),
                                  Positioned(
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
                                        color: index == 0 ? Colors.green : Colors.red,
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
                                      user,
                                      style: TextStyle(
                                        fontSize: normalFontSize,
                                        fontWeight: FontWeight.w700,
                                      ),
                                    ),
                                    Text(
                                      index == 0 ? "online" : "offline",
                                      style: TextStyle(
                                        fontSize: smallFontSize,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              PopupMenuButton<int>(
                                icon: Icon(Icons.more_horiz),
                                itemBuilder: (context) => [
                                  PopupMenuItem(
                                    value: 1,
                                    child: Row(
                                      children: [
                                        Text("Start Chat", style: TextStyle(color: greyColor)),
                                        SizedBox(width: screenWidth * 0.05),
                                        Icon(Icons.chat_outlined, color: greyColor),
                                      ],
                                    ),
                                  ),
                                ],
                                offset: Offset(0, screenHeight * 0.05),
                                color: Colors.white,
                                elevation: 2,
                                onSelected: (value) {
                                  if (value == 1) {
                                    _startChat(user);
                                  }
                                },
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                ),
              SizedBox(height: verticalPaddingLarge),
              // ElevatedButton(
              //   style: ButtonStyle(
              //     backgroundColor: WidgetStateProperty.all<Color>(blueColor!),
              //     shape: WidgetStateProperty.all<RoundedRectangleBorder>(
              //       RoundedRectangleBorder(
              //         borderRadius: BorderRadius.circular(buttonBorderRadius),
              //       ),
              //     ),
              //   ),
              //   onPressed: () {},
              //   child: Center(
              //     child: Padding(
              //       padding: EdgeInsets.symmetric(
              //         vertical: screenHeight * 0.0125,
              //         horizontal: screenWidth * 0.0375,
              //       ),
              //       child: Text(
              //         "Add Friends",
              //         style: TextStyle(
              //           fontSize: boldFontSize - 3,
              //           fontWeight: FontWeight.w500,
              //           color: Colors.white,
              //         ),
              //       ),
              //     ),
              //   ),
              // ),
            ],
          ),
        ),
      ),
    );
  }
}