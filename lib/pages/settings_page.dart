import 'package:flutter/material.dart';
import '../models/auth_handler.dart';
import '../models/json_handler.dart';

class SettingsPage extends StatefulWidget {
  const SettingsPage({super.key});

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  final TextEditingController searchController = TextEditingController();
  String? currentUserId;
  bool _isProcessing = false;

  @override
  void initState() {
    super.initState();
    _loadCurrentUser();
  }

  Future<void> _loadCurrentUser() async {
    currentUserId = await AuthHandler.getCurrentUser();
    if (mounted) setState(() {});
  }

  Future<void> _deleteAllChats() async {
    await _deleteAllGroupChats();
    await _deleteAllDirectChats();
  }

  Future<void> _deleteAllDirectChats() async {
    if (currentUserId == null || _isProcessing) return;

    setState(() => _isProcessing = true);
    try {
      final allUsers = await AuthHandler.getAllUsers();
      final otherUsers = allUsers.where((user) => user != currentUserId).toList();

      // Delete direct chats
      await Future.wait(otherUsers.map((user) async {
        await JsonHandler.clearDirectMessages(currentUserId!, user);
      }));

      _showSuccessSnackbar('All Direct chats deleted successfully');
    } catch (e) {
      _showErrorSnackbar('Failed to delete chats: ${e.toString()}');
    } finally {
      if (mounted) setState(() => _isProcessing = false);
    }
  }

  Future<void> _deleteAllGroupChats() async {
    if (currentUserId == null || _isProcessing) return;

    setState(() => _isProcessing = true);
    try {
      final allUsers = await AuthHandler.getAllUsers();
      final otherUsers = allUsers.where((user) => user != currentUserId).toList();

      // Delete group chats
      final userGroups = await AuthHandler.getUserGroups(currentUserId!);
      await Future.wait(userGroups.map((group) =>
          JsonHandler.clearGroupMessages(group)
      ));

      _showSuccessSnackbar('All Group chats deleted successfully');
    } catch (e) {
      _showErrorSnackbar('Failed to delete group chats: ${e.toString()}');
    } finally {
      if (mounted) setState(() => _isProcessing = false);
    }
  }

  Future<void> _logout() async {
    final shouldLogout = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Logout'),
        content: const Text('Are you sure you want to logout?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            child: const Text('Logout'),
          ),
        ],
      ),
    );

    if (shouldLogout == true) {
      await AuthHandler.logout();
      if (mounted) {
        Navigator.pushNamedAndRemoveUntil(
          context,
          '/login',
              (route) => false,
        );
      }
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

  void _showSuccessSnackbar(String message) {
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(message)),
      );
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
                "Settings",
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
                  vertical: containerPaddingVertical,
                  horizontal: containerPaddingHorizontal,
                ),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(containerBorderRadius),
                  border: Border.all(
                    color: Colors.grey.shade500,
                    width: 1,
                  ),
                ),
                child: Row(
                  children: [
                    Stack(
                      children: [
                        CircleAvatar(
                          radius: avatarRadius,
                          backgroundColor: Colors.green[200],
                          child: Text(
                            currentUserId != null && currentUserId!.isNotEmpty
                                ? currentUserId![0].toUpperCase()
                                : "?",
                            style: TextStyle(
                              color: Colors.green[800],
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
                                  color: Colors.white
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
                            currentUserId ?? "Guest",
                            style: TextStyle(
                              fontSize: normalFontSize,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                          if (currentUserId != null)
                            Text(
                              currentUserId!,
                              style: TextStyle(
                                fontSize: smallFontSize,
                              ),
                            ),
                        ],
                      ),
                    ),
                    IconButton(
                      onPressed: _logout,
                      icon: const Icon(Icons.logout_outlined),
                    ),
                  ],
                ),
              ),
              SizedBox(height: verticalPaddingSmall),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "Chat Activity",
                    style: TextStyle(
                      color: greyColor,
                      fontSize: normalFontSize,
                    ),
                  ),
                  TextButton(
                    onPressed: _deleteAllChats,
                    child: Text(
                      "Delete all Chats",
                      style: TextStyle(
                        color: greyColor,
                        fontSize: smallFontSize,
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(height: verticalPaddingSmall),
              Container(
                padding: EdgeInsets.symmetric(
                  vertical: verticalPaddingLarge,
                  horizontal: containerPaddingHorizontal,
                ),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(containerBorderRadius),
                ),
                child: Column(
                  children: [
                    ElevatedButton(
                      style: ButtonStyle(
                        backgroundColor: WidgetStateProperty.all<Color>(Colors.red),
                        shape: WidgetStateProperty.all<RoundedRectangleBorder>(
                          RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(buttonBorderRadius),
                          ),
                        ),
                      ),
                      onPressed: _isProcessing ? null : _deleteAllDirectChats,
                      child: Padding(
                        padding: EdgeInsets.symmetric(
                          vertical: verticalPaddingMedium,
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            if (_isProcessing)
                              SizedBox(
                                width: normalFontSize - 3,
                                height: normalFontSize - 3,
                                child: CircularProgressIndicator(
                                  color: Colors.white,
                                  strokeWidth: 2,
                                ),
                              )
                            else
                              Icon(
                                Icons.delete_outlined,
                                color: Colors.white,
                                size: normalFontSize - 3,
                              ),
                            SizedBox(width: screenWidth * 0.0125),
                            Text(
                              _isProcessing ? "Processing..." : "Delete All Personal Chats",
                              style: TextStyle(
                                fontSize: normalFontSize-3,
                                fontWeight: FontWeight.w500,
                                color: Colors.white,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    SizedBox(height: verticalPaddingMedium),
                    const Divider(),
                    SizedBox(height: verticalPaddingMedium),
                    ElevatedButton(
                      style: ButtonStyle(
                        backgroundColor: WidgetStateProperty.all<Color>(Colors.red),
                        shape: WidgetStateProperty.all<RoundedRectangleBorder>(
                          RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(buttonBorderRadius),
                          ),
                        ),
                      ),
                      onPressed: _isProcessing ? null : _deleteAllGroupChats,
                      child: Padding(
                        padding: EdgeInsets.symmetric(
                          vertical: verticalPaddingMedium,
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            if (_isProcessing)
                              SizedBox(
                                width: normalFontSize - 3,
                                height: normalFontSize - 3,
                                child: CircularProgressIndicator(
                                  color: Colors.white,
                                  strokeWidth: 2,
                                ),
                              )
                            else
                              Icon(
                                Icons.delete_outlined,
                                color: Colors.white,
                                size: normalFontSize - 3,
                              ),
                            SizedBox(width: screenWidth * 0.0125),
                            Text(
                              _isProcessing ? "Processing..." : "Delete All Group Chats",
                              style: TextStyle(
                                fontSize: normalFontSize-3,
                                fontWeight: FontWeight.w500,
                                color: Colors.white,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(height: verticalPaddingLarge),
            ],
          ),
        ),
      ),
    );
  }
}