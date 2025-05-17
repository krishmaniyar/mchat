import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';

class Message {
  final String sender;
  final String content;
  final DateTime timestamp;
  final bool isFile;
  final bool isSender;
  final Duration? expiresAfter;
  final bool isFavorite;
  final String? filePath;
  final String? fileName;
  final String? fileType;
  final String? fileUrl;

  Message({
    required this.sender,
    required this.content,
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
      timestamp: DateTime.parse(json['timestamp']),
      isFile: json['isFile'] ?? false,
      isSender: json['isSender'] ?? false,
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
  static Future<File> _getLocalFile({String? groupName}) async {
    final directory = await getApplicationDocumentsDirectory();
    final path = directory.path;

    if (groupName != null) {
      // For group chats
      return File('$path/group_${groupName}_messages.json');
    } else {
      // For personal chats
      return File('$path/chat_messages.json');
    }
  }

  static Future<List<Message>> readMessages({String? groupName}) async {
    try {
      final file = await _getLocalFile(groupName: groupName);
      if (!await file.exists()) {
        return [];
      }

      final contents = await file.readAsString();
      final List<dynamic> jsonList = json.decode(contents);
      final messages = jsonList.map((json) => Message.fromJson(json)).toList();
      final validMessages = messages.where((m) => !m.isExpired).toList();

      if (validMessages.length != messages.length) {
        await writeMessages(validMessages, groupName: groupName);
      }

      return validMessages;
    } catch (e) {
      debugPrint('Error reading messages: $e');
      return [];
    }
  }

  static Future<void> writeMessages(List<Message> messages, {String? groupName}) async {
    try {
      final file = await _getLocalFile(groupName: groupName);
      final jsonList = messages.map((message) => message.toJson()).toList();
      await file.writeAsString(json.encode(jsonList));
    } catch (e) {
      debugPrint('Error writing messages: $e');
    }
  }

  static Future<void> addMessage(Message newMessage, {String? groupName}) async {
    final messages = await readMessages(groupName: groupName);
    messages.add(newMessage);
    await writeMessages(messages, groupName: groupName);
  }

  static Future<void> deleteMessage(Message messageToDelete, {String? groupName}) async {
    final messages = await readMessages(groupName: groupName);
    messages.removeWhere((m) =>
    m.sender == messageToDelete.sender &&
        m.content == messageToDelete.content &&
        m.timestamp == messageToDelete.timestamp
    );
    await writeMessages(messages, groupName: groupName);
  }

  static Future<void> toggleFavorite(Message message, {String? groupName}) async {
    final messages = await readMessages(groupName: groupName);
    final index = messages.indexWhere((m) =>
    m.sender == message.sender &&
        m.content == message.content &&
        m.timestamp == message.timestamp
    );

    if (index != -1) {
      messages[index] = Message(
        sender: message.sender,
        content: message.content,
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
      await writeMessages(messages, groupName: groupName);
    }
  }

  static Future<void> clearMessages({String? groupName}) async {
    try {
      final file = await _getLocalFile(groupName: groupName);
      if (await file.exists()) {
        await file.delete();
      }
    } catch (e) {
      debugPrint('Error clearing messages: $e');
    }
  }
}