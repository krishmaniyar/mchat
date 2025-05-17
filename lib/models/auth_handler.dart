import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AuthHandler {
  static const String _currentUserKey = 'current_user';
  static const String usersKey = 'registered_users';
  static const String userGroupsKey = 'user_groups';
  static const String allGroupsKey = 'all_groups';

  static Future<void> initialize() async {
    WidgetsFlutterBinding.ensureInitialized();
  }

  // User Management
  static Future<bool> registerUser(String username, String password) async {
    final prefs = await SharedPreferences.getInstance();
    final users = prefs.getStringList(usersKey) ?? [];

    if (users.contains(username)) {
      debugPrint('User already exists');
      return false;
    }

    users.add(username);
    await prefs.setStringList(usersKey, users);
    await prefs.setString('${username}_password', password);

    // Initialize user's group list
    await prefs.setStringList('${username}_$userGroupsKey', []);
    return true;
  }

  static Future<bool> loginUser(String username, String password) async {
    final prefs = await SharedPreferences.getInstance();
    final storedPassword = prefs.getString('${username}_password');

    if (storedPassword == password) {
      await prefs.setString(_currentUserKey, username);
      return true;
    }
    return false;
  }

  static Future<void> logout() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_currentUserKey);
  }

  static Future<String?> getCurrentUser() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_currentUserKey);
  }

  static Future<bool> isLoggedIn() async {
    return await getCurrentUser() != null;
  }

  // Group Management
  static Future<bool> createGroup(String groupName, List<String> members) async {
    final prefs = await SharedPreferences.getInstance();
    final currentUser = await getCurrentUser();

    if (currentUser == null) return false;

    // Add current user to members if not already included
    if (!members.contains(currentUser)) {
      members.add(currentUser);
    }

    // Get all existing groups
    final allGroups = prefs.getStringList(allGroupsKey) ?? [];

    // Check if group already exists
    if (allGroups.contains(groupName)) {
      debugPrint('Group already exists');
      return false;
    }

    // Add group to the global list
    allGroups.add(groupName);
    await prefs.setStringList(allGroupsKey, allGroups);

    // Add group to each member's group list
    for (final member in members) {
      final userGroups = prefs.getStringList('${member}_$userGroupsKey') ?? [];
      if (!userGroups.contains(groupName)) {
        userGroups.add(groupName);
        await prefs.setStringList('${member}_$userGroupsKey', userGroups);
      }
    }

    // Store group members
    await prefs.setStringList('group_${groupName}_members', members);

    return true;
  }

  static Future<bool> addUserToGroup(String groupName, String username) async {
    final prefs = await SharedPreferences.getInstance();

    // Check if group exists
    final allGroups = prefs.getStringList(allGroupsKey) ?? [];
    if (!allGroups.contains(groupName)) {
      debugPrint('Group does not exist');
      return false;
    }

    // Check if user exists
    final users = prefs.getStringList(usersKey) ?? [];
    if (!users.contains(username)) {
      debugPrint('User does not exist');
      return false;
    }

    // Add user to group members
    final members = prefs.getStringList('group_${groupName}_members') ?? [];
    if (!members.contains(username)) {
      members.add(username);
      await prefs.setStringList('group_${groupName}_members', members);
    }

    // Add group to user's group list
    final userGroups = prefs.getStringList('${username}_$userGroupsKey') ?? [];
    if (!userGroups.contains(groupName)) {
      userGroups.add(groupName);
      await prefs.setStringList('${username}_$userGroupsKey', userGroups);
    }

    return true;
  }

  static Future<bool> removeUserFromGroup(String groupName, String username) async {
    final prefs = await SharedPreferences.getInstance();

    // Remove user from group members
    final members = prefs.getStringList('group_${groupName}_members') ?? [];
    members.remove(username);
    await prefs.setStringList('group_${groupName}_members', members);

    // Remove group from user's group list
    final userGroups = prefs.getStringList('${username}_$userGroupsKey') ?? [];
    userGroups.remove(groupName);
    await prefs.setStringList('${username}_$userGroupsKey', userGroups);

    return true;
  }

  static Future<List<String>> getUserGroups(String username) async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getStringList('${username}_$userGroupsKey') ?? [];
  }

  static Future<List<String>> getGroupMembers(String groupName) async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getStringList('group_${groupName}_members') ?? [];
  }

  static Future<List<String>> getAllGroups() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getStringList(allGroupsKey) ?? [];
  }

  static Future<bool> isUserInGroup(String username, String groupName) async {
    final prefs = await SharedPreferences.getInstance();
    final userGroups = prefs.getStringList('${username}_$userGroupsKey') ?? [];
    return userGroups.contains(groupName);
  }

  static Future<List<String>> getAllUsers() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getStringList(usersKey) ?? [];
  }
}