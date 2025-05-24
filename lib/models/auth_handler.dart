import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

class AuthHandler {
  static const _userIdKey = 'user_id';
  static const _userNameKey = 'user_name';
  static const _emailKey = 'user_email';
  static const _phoneNumberKey = 'phone_number';
  static const _statusKey = 'user_status';
  static const _guidKey = 'user_guid';


  // Save login response
  static Future<void> saveLoginData(Map<String, dynamic> response) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt(_userIdKey, response['userId'] ?? 0);
    await prefs.setString(_userNameKey, response['userName'] ?? '');
    await prefs.setString(_emailKey, response['email'] ?? '');
    await prefs.setString(_phoneNumberKey, response['phoneNumber'] ?? '');
    await prefs.setInt(_statusKey, response['status'] ?? 0);
    await prefs.setString(_guidKey, response['guid'] ?? '');
  }

  // Check if user is logged in
  static Future<bool> isLoggedIn() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getInt(_userIdKey) != null &&
        prefs.getString(_guidKey) != null;
  }

  // Get user ID
  static Future<int> getUserId() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getInt(_userIdKey) ?? 0;
  }

  // Get user name
  static Future<String> getUserName() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_userNameKey) ?? '';
  }

  // Get user email
  static Future<String> getEmail() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_emailKey) ?? '';
  }

  // Get phone number
  static Future<String> getPhoneNumber() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_phoneNumberKey) ?? '';
  }

  // Get status
  static Future<int> getStatus() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getInt(_statusKey) ?? 0;
  }

  // Get GUID
  static Future<String> getGuid() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_guidKey) ?? '';
  }

  // Get all user data
  static Future<Map<String, dynamic>> getUserData() async {
    return {
      'userId': await getUserId(),
      'userName': await getUserName(),
      'email': await getEmail(),
      'phoneNumber': await getPhoneNumber(),
      'status': await getStatus(),
      'guid': await getGuid(),
    };
  }

  // Logout
  static Future<void> logout() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_userIdKey);
    await prefs.remove(_userNameKey);
    await prefs.remove(_emailKey);
    await prefs.remove(_phoneNumberKey);
    await prefs.remove(_statusKey);
    await prefs.remove(_guidKey);
  }

}