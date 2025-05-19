import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';

class Message {
  final String sender;
  final String content;
  final String? receiver;
  final DateTime timestamp;
  final bool isFile;
  final String isSender;
  final Duration? expiresAfter;
  final bool isFavorite;
  final String? filePath;
  final String? fileName;
  final String? fileType;
  final String? fileUrl;

  Message({
    required this.sender,
    required this.content,
    this.receiver,
    required this.timestamp,
    this.isFile = false,
    required this.isSender,
    this.expiresAfter,
    this.isFavorite = false,
    this.filePath,
    this.fileName,
    this.fileType,
    this.fileUrl,
  });

  bool get isExpired {
    if (expiresAfter == null) return false;
    return DateTime.now().isAfter(timestamp.add(expiresAfter!));
  }

  factory Message.fromJson(Map<String, dynamic> json) {
    return Message(
      sender: json['sender'],
      content: json['content'],
      receiver: json['receiver'],
      timestamp: DateTime.parse(json['timestamp']),
      isFile: json['isFile'] ?? false,
      isSender: json['isSender'],
      expiresAfter: json['expiresAfter'] != null
          ? Duration(seconds: json['expiresAfter'])
          : null,
      isFavorite: json['isFavorite'] ?? false,
      filePath: json['filePath'],
      fileName: json['fileName'],
      fileType: json['fileType'],
      fileUrl: json['fileUrl'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'sender': sender,
      'content': content,
      'receiver': receiver,
      'timestamp': timestamp.toIso8601String(),
      'isFile': isFile,
      'isSender': isSender,
      'expiresAfter': expiresAfter?.inSeconds,
      'isFavorite': isFavorite,
      'filePath': filePath,
      'fileName': fileName,
      'fileType': fileType,
      'fileUrl': fileUrl,
    };
  }
}

class JsonHandler {
  static String _getFileName({String? userId1, String? userId2, String? groupId}) {
    if (groupId != null) {
      return 'group_${groupId}_messages.json';
    } else if (userId1 != null && userId2 != null) {
      final sortedIds = [userId1, userId2]..sort();
      return 'direct_${sortedIds[0]}_${sortedIds[1]}_messages.json';
    }
    return 'chat_messages.json';
  }

  static Future<File> _getLocalFile({String? userId1, String? userId2, String? groupId}) async {
    final directory = await getApplicationDocumentsDirectory();
    final fileName = _getFileName(userId1: userId1, userId2: userId2, groupId: groupId);
    return File('${directory.path}/$fileName');
  }

  static Future<List<Message>> readDirectMessages(String userId1, String userId2) async {
    try {
      final file = await _getLocalFile(userId1: userId1, userId2: userId2);
      if (!await file.exists()) return [];
      final contents = await file.readAsString();
      final List<dynamic> jsonList = json.decode(contents);
      final messages = jsonList.map((json) => Message.fromJson(json)).toList();
      final validMessages = messages.where((m) => !m.isExpired).toList();
      if (validMessages.length != messages.length) {
        await writeDirectMessages(validMessages, userId1, userId2);
      }
      return validMessages;
    } catch (e) {
      debugPrint('Error reading direct messages: $e');
      return [];
    }
  }

  static Future<List<Message>> readGroupMessages(String groupId) async {
    try {
      final file = await _getLocalFile(groupId: groupId);
      if (!await file.exists()) return [];
      final contents = await file.readAsString();
      final List<dynamic> jsonList = json.decode(contents);
      final messages = jsonList.map((json) => Message.fromJson(json)).toList();
      final validMessages = messages.where((m) => !m.isExpired).toList();
      if (validMessages.length != messages.length) {
        await writeGroupMessages(validMessages, groupId);
      }
      return validMessages;
    } catch (e) {
      debugPrint('Error reading group messages: $e');
      return [];
    }
  }

  static Future<void> writeDirectMessages(List<Message> messages, String userId1, String userId2) async {
    try {
      final file = await _getLocalFile(userId1: userId1, userId2: userId2);
      final jsonList = messages.map((message) => message.toJson()).toList();
      await file.writeAsString(json.encode(jsonList));
    } catch (e) {
      debugPrint('Error writing direct messages: $e');
      rethrow;
    }
  }

  static Future<void> writeGroupMessages(List<Message> messages, String groupId) async {
    try {
      final file = await _getLocalFile(groupId: groupId);
      final jsonList = messages.map((message) => message.toJson()).toList();
      await file.writeAsString(json.encode(jsonList));
    } catch (e) {
      debugPrint('Error writing group messages: $e');
      rethrow;
    }
  }

  static Future<void> addDirectMessage(Message newMessage, String userId1, String userId2) async {
    final messages = await readDirectMessages(userId1, userId2);
    messages.add(newMessage);
    await writeDirectMessages(messages, userId1, userId2);
  }

  static Future<void> addGroupMessage(Message newMessage, String groupId) async {
    final messages = await readGroupMessages(groupId);
    messages.add(newMessage);
    await writeGroupMessages(messages, groupId);
  }

  static Future<void> deleteDirectMessage(Message messageToDelete, String userId1, String userId2) async {
    final messages = await readDirectMessages(userId1, userId2);
    messages.removeWhere((m) =>
    m.sender == messageToDelete.sender &&
        m.content == messageToDelete.content &&
        m.timestamp == messageToDelete.timestamp
    );
    await writeDirectMessages(messages, userId1, userId2);
  }

  static Future<void> deleteGroupMessage(Message messageToDelete, String groupId) async {
    final messages = await readGroupMessages(groupId);
    messages.removeWhere((m) =>
    m.sender == messageToDelete.sender &&
        m.content == messageToDelete.content &&
        m.timestamp == messageToDelete.timestamp
    );
    await writeGroupMessages(messages, groupId);
  }

  static Future<void> toggleFavoriteDirectMessage(Message message, String userId1, String userId2) async {
    final messages = await readDirectMessages(userId1, userId2);
    final index = messages.indexWhere((m) =>
    m.sender == message.sender &&
        m.content == message.content &&
        m.timestamp == message.timestamp
    );
    if (index != -1) {
      messages[index] = Message(
        sender: message.sender,
        content: message.content,
        receiver: message.receiver,
        timestamp: message.timestamp,
        isFile: message.isFile,
        isSender: message.isSender,
        expiresAfter: message.expiresAfter,
        isFavorite: !message.isFavorite,
        filePath: message.filePath,
        fileName: message.fileName,
        fileType: message.fileType,
        fileUrl: message.fileUrl,
      );
      await writeDirectMessages(messages, userId1, userId2);
    }
  }

  static Future<void> toggleFavoriteGroupMessage(Message message, String groupId) async {
    final messages = await readGroupMessages(groupId);
    final index = messages.indexWhere((m) =>
    m.sender == message.sender &&
        m.content == message.content &&
        m.timestamp == message.timestamp
    );
    if (index != -1) {
      messages[index] = Message(
        sender: message.sender,
        content: message.content,
        receiver: message.receiver,
        timestamp: message.timestamp,
        isFile: message.isFile,
        isSender: message.isSender,
        expiresAfter: message.expiresAfter,
        isFavorite: !message.isFavorite,
        filePath: message.filePath,
        fileName: message.fileName,
        fileType: message.fileType,
        fileUrl: message.fileUrl,
      );
      await writeGroupMessages(messages, groupId);
    }
  }

  static Future<void> clearDirectMessages(String userId1, String userId2) async {
    try {
      final file = await _getLocalFile(userId1: userId1, userId2: userId2);
      if (await file.exists()) await file.delete();
    } catch (e) {
      debugPrint('Error clearing direct messages: $e');
    }
  }

  static Future<void> clearGroupMessages(String groupId) async {
    try {
      final file = await _getLocalFile(groupId: groupId);
      if (await file.exists()) await file.delete();
    } catch (e) {
      debugPrint('Error clearing group messages: $e');
    }
  }

  static Future<List<File>> getAllDirectChatFiles(String userId) async {
    final directory = await getApplicationDocumentsDirectory();
    final files = Directory(directory.path).listSync();
    return files.where((file) {
      if (file is File) {
        final fileName = file.path.split('/').last;
        return fileName.startsWith('direct_') &&
            fileName.contains(userId) &&
            fileName.endsWith('_messages.json');
      }
      return false;
    }).cast<File>().toList();
  }

  static Future<List<File>> getAllGroupChatFiles() async {
    final directory = await getApplicationDocumentsDirectory();
    final files = Directory(directory.path).listSync();
    return files.where((file) {
      if (file is File) {
        final fileName = file.path.split('/').last;
        return fileName.startsWith('group_') &&
            fileName.endsWith('_messages.json');
      }
      return false;
    }).cast<File>().toList();
  }
}