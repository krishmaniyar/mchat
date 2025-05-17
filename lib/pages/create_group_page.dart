import 'package:flutter/material.dart';
import '../models/auth_handler.dart';
import 'chats_page.dart'; // Import your ChatsPage

class CreateGroupPage extends StatefulWidget {
  const CreateGroupPage({super.key});

  @override
  State<CreateGroupPage> createState() => _CreateGroupPageState();
}

class _CreateGroupPageState extends State<CreateGroupPage> {
  final TextEditingController searchController = TextEditingController();
  final TextEditingController groupController = TextEditingController();
  List<String> allUsers = [];
  List<String> selectedUsers = [];
  List<String> filteredUsers = [];
  bool isLoading = false;

  @override
  void initState() {
    super.initState();
    _loadUsers();
    searchController.addListener(_filterUsers);
  }

  Future<void> _loadUsers() async {
    setState(() => isLoading = true);
    try {
      final currentUser = await AuthHandler.getCurrentUser();
      final users = await AuthHandler.getAllUsers();
      users.remove(currentUser);

      setState(() {
        allUsers = users;
        filteredUsers = users;
      });
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to load users: ${e.toString()}')),
      );
    } finally {
      setState(() => isLoading = false);
    }
  }

  void _filterUsers() {
    final query = searchController.text.toLowerCase();
    setState(() {
      filteredUsers = allUsers.where((user) =>
          user.toLowerCase().contains(query)
      ).toList();
    });
  }

  void _toggleUserSelection(String user) {
    setState(() {
      if (selectedUsers.contains(user)) {
        selectedUsers.remove(user);
      } else {
        selectedUsers.add(user);
      }
    });
  }

  Future<void> _createGroup() async {
    if (groupController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Please enter a group name')),
      );
      return;
    }

    if (selectedUsers.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Please select at least one member')),
      );
      return;
    }

    setState(() => isLoading = true);
    try {
      final success = await AuthHandler.createGroup(
        groupController.text.trim(),
        selectedUsers,
      );

      if (success) {
        // Navigator.pushReplacement(
        //   context,
        //   MaterialPageRoute(builder: (context) => ChatsPage()),
        // );
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Group created successfully!')),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to create group. It may already exist.')),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error creating group: ${e.toString()}')),
      );
    } finally {
      if (mounted) {
        setState(() => isLoading = false);
      }
    }
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
                "Create Chat",
                style: TextStyle(
                  fontSize: boldFontSize,
                  fontWeight: FontWeight.w600,
                ),
              ),
              SizedBox(height: verticalPaddingSmall),
              const Divider(),
              SizedBox(height: verticalPaddingLarge),
              Container(
                padding: EdgeInsets.symmetric(
                  vertical: screenHeight * 0.025,
                  horizontal: screenWidth * 0.0375,
                ),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(containerBorderRadius),
                ),
                child: TextField(
                  controller: groupController,
                  keyboardType: TextInputType.text,
                  style: TextStyle(
                    fontSize: normalFontSize,
                  ),
                  decoration: InputDecoration(
                    hintText: "Group Name",
                    contentPadding: EdgeInsets.symmetric(
                      vertical: screenHeight * 0.02,
                      horizontal: screenWidth * 0.0375,
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderSide: const BorderSide(color: Colors.white),
                      borderRadius: BorderRadius.circular(containerBorderRadius),
                    ),
                    enabledBorder: UnderlineInputBorder(
                      borderSide: const BorderSide(color: Colors.white),
                      borderRadius: BorderRadius.circular(containerBorderRadius),
                    ),
                    filled: true,
                    fillColor: Colors.grey[300],
                  ),
                ),
              ),
              SizedBox(height: verticalPaddingLarge),
              Text(
                "Select Member",
                style: TextStyle(fontSize: normalFontSize),
              ),
              SizedBox(height: verticalPaddingSmall),
              TextField(
                controller: searchController,
                keyboardType: TextInputType.text,
                style: TextStyle(
                  fontSize: normalFontSize,
                ),
                decoration: InputDecoration(
                  suffixIcon: Icon(Icons.search),
                  hintText: "Search members",
                  contentPadding: EdgeInsets.symmetric(
                    vertical: screenHeight * 0.02,
                    horizontal: screenWidth * 0.0375,
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderSide: const BorderSide(color: Colors.white),
                    borderRadius: BorderRadius.circular(containerBorderRadius),
                  ),
                  enabledBorder: UnderlineInputBorder(
                    borderSide: const BorderSide(color: Colors.white),
                    borderRadius: BorderRadius.circular(containerBorderRadius),
                  ),
                  filled: true,
                  fillColor: Colors.grey[300],
                ),
              ),
              SizedBox(height: verticalPaddingMedium),
              // Selected Users Preview
              if (selectedUsers.isNotEmpty) ...[
                SizedBox(
                  height: 60,
                  child: ListView.builder(
                    scrollDirection: Axis.horizontal,
                    itemCount: selectedUsers.length,
                    itemBuilder: (context, index) {
                      final user = selectedUsers[index];
                      return Padding(
                        padding: const EdgeInsets.only(right: 8.0),
                        child: Chip(
                          label: Text(user),
                          avatar: CircleAvatar(
                            child: Text(user.substring(0, 1)),
                          ),
                          onDeleted: () => _toggleUserSelection(user),
                        ),
                      );
                    },
                  ),
                ),
                SizedBox(height: verticalPaddingMedium),
              ],
              Expanded(
                child: isLoading
                    ? Center(child: CircularProgressIndicator())
                    : filteredUsers.isEmpty
                    ? Center(child: Text('No members found'))
                    : SingleChildScrollView(
                  child: Column(
                    children: filteredUsers.map((user) {
                      final isSelected = selectedUsers.contains(user);
                      return Container(
                        margin: EdgeInsets.only(bottom: verticalPaddingMedium),
                        padding: EdgeInsets.symmetric(
                          vertical: containerPaddingVertical,
                          horizontal: containerPaddingHorizontal,
                        ),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(containerBorderRadius),
                          border: isSelected
                              ? Border.all(
                            color: Colors.blue.shade500,
                            width: 2,
                          )
                              : null,
                        ),
                        child: Row(
                          children: [
                            Stack(
                              children: [
                                CircleAvatar(
                                  radius: avatarRadius,
                                  backgroundColor: Colors.blue[200],
                                  child: Text(
                                    user.substring(0, 1).toUpperCase(),
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
                                      color: Colors.green,
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
                                    "online",
                                    style: TextStyle(
                                      fontSize: smallFontSize,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            Checkbox(
                              value: isSelected,
                              onChanged: (value) => _toggleUserSelection(user),
                            ),
                          ],
                        ),
                      );
                    }).toList(),
                  ),
                ),
              ),
              SizedBox(height: verticalPaddingMedium),
              ElevatedButton(
                style: ButtonStyle(
                  backgroundColor: WidgetStateProperty.all<Color>(blueColor!),
                  shape: WidgetStateProperty.all<RoundedRectangleBorder>(
                    RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(buttonBorderRadius),
                    ),
                  ),
                ),
                onPressed: isLoading ? null : _createGroup,
                child: Center(
                  child: Padding(
                    padding: EdgeInsets.symmetric(
                      vertical: screenHeight * 0.0125,
                      horizontal: screenWidth * 0.0375,
                    ),
                    child: isLoading
                        ? SizedBox(
                      height: 20,
                      width: 20,
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                      ),
                    )
                        : Text(
                      "Create Group",
                      style: TextStyle(
                        fontSize: boldFontSize - 3,
                        fontWeight: FontWeight.w500,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
              ),
              SizedBox(height: verticalPaddingMedium),
            ],
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    searchController.dispose();
    groupController.dispose();
    super.dispose();
  }
}