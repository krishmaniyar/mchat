import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;

class ChatApiService {
  static const String _baseUrl = 'https://uat.marwadionline.com/mchat/api/Chat/';

  // Helper method for making POST requests
  static Future<dynamic> _postRequest(
      String endpoint, Map<String, dynamic> body) async {
    final response = await http.post(
      Uri.parse('$_baseUrl$endpoint'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(body),
    );

    if (response.statusCode == 200) {
      if (response.body.isNotEmpty) {
        return jsonDecode(response.body);
      } else {
        return null;
      }
    } else {
      throw Exception('Failed to load data: ${response.statusCode}');
    }
  }

  // Helper method for making POST requests with files
  static Future<Map<String, dynamic>> _postRequestWithFiles(
      String endpoint, Map<String, dynamic> body, List<File> files) async {
    var request = http.MultipartRequest('POST', Uri.parse('$_baseUrl$endpoint'));

    // Add files to the request
    for (var file in files) {
      request.files.add(
        await http.MultipartFile.fromPath(
          'Files', // This should match the parameter name expected by the API
          file.path,
        ),
      );
    }

    // Add other fields to the request
    body.forEach((key, value) {
      request.fields[key] = value.toString();
    });

    var response = await request.send();
    final responseData = await response.stream.bytesToString();

    if (response.statusCode == 200) {
      return jsonDecode(responseData);
    } else {
      throw Exception('Failed to load data: ${response.statusCode}');
    }
  }

  // 1. Login
  static Future<Map<String, dynamic>> login(
      String email, String password) async {
    return await _postRequest('Login', {
      'email': email,
      'password': password,
    });
  }

  // 2. GetChatList
  static Future<List> getChatList(int userId, int type) async {
    try {
      final List response = (await _postRequest('GetChatList', {
        'UserId': userId,
        'Type': type,
      })) as List;
      return response;
    } catch (e) {
      print('Error getting chat list: $e');
      rethrow;
    }
  }

  // 3. GetChatMessages
  static Future<List> getChatMessages(
      int chatId) async {
    return await _postRequest('GetChatMessages', {
      'ChatId': chatId,
    });
  }

  // 4. GetFriends
  static Future<List<dynamic>> getFriends(int userId, String guid) async {
    return await _postRequest('GetFriends', {
      'UserId': userId,
      'Guid': guid,
    });
  }

  // 5. CreateGroups
  static Future<Map<String, dynamic>> createGroups(
      String groupName, List<int> friendsId, int userId) async {
    return await _postRequest('CreateGroups', {
      'GroupName': groupName,
      'FriendsId': friendsId,
      'UserId': userId,
    });
  }

  // 6. SendMessage (Note: Corrected spelling from "SendMesage")
  static Future<void> sendMessage(
      int chatId,
      int userId,
      String userName,
      String message,
      String connectionId,
      ) async {
    await _postRequest('SendMesage', {
      'ChatId': chatId,
      'UserId': userId,
      'UserName': userName,
      'Message': message,
      'connectionId': connectionId,
    });
  }

  // 7. SendMessageFile (Note: Corrected spelling from "SendMesageFile")
  static Future<Map<String, dynamic>> sendMessageFile(
      int chatId,
      int userId,
      String userName,
      String message,
      String connectionId,
      List<File> files,
      ) async {
    return await _postRequestWithFiles('SendMesageFile', {
      'ChatId': chatId,
      'UserId': userId,
      'UserName': userName,
      'Message': message,
      'ConnectionId': connectionId,
    }, files);
  }

  // 8. ReadMessage
  static Future<Map<String, dynamic>> readMessage(
      int chatId,
      int messageId,
      int userId,
      Guid messageGuid,
      ) async {
    return await _postRequest('ReadMessage', {
      'ChatId': chatId,
      'MessageId': messageId,
      'UserId': userId,
      'MessageGuid': messageGuid.toString(),
    });
  }

  // 9. DeleteMessage
  static Future<void> deleteMessage(
      int chatId,
      int messageId,
      int userId,
      String messageGuid,
      ) async {
    await _postRequest('DeleteMessage', {
      'ChatId': chatId,
      'MessageId': messageId,
      'UserId': userId,
      'MessageGuid': messageGuid,
    });
  }

  // 10. DeleteMessageAll
  static Future<Map<String, dynamic>> deleteMessageAll(
      int userId, String clickValue) async {
    return await _postRequest('DeleteMessageAll', {
      'UserId': userId,
      'clickValue': clickValue,
    });
  }

  // 11. MarkStarMessage
  static Future<void> markStarMessage(
      int chatId,
      String messageGuid,
      int userId,
      int bookmark,
      ) async {
    await _postRequest('MarkStarMessage', {
      'ChatId': chatId,
      'MessageGuid': messageGuid,
      'UserId': userId,
      'Bookmark': bookmark,
    });
  }

  // 12. ReceiveMessage
  static Future<Map<String, dynamic>> receiveMessage(
      int chatId,
      int messageId,
      int userId,
      Guid messageGuid,
      ) async {
    return await _postRequest('ReceiveMessage', {
      'ChatId': chatId,
      'MessageId': messageId,
      'UserId': userId,
      'MessageGuid': messageGuid.toString(),
    });
  }

  // 13. UpdateChatDisappearingMessagesSetting
  static Future<Map<String, dynamic>> updateChatDisappearingMessagesSetting(
      int chatId,
      int disappearingMessagesSettingId,
      int userId,
      int minutes,
      ) async {
    return await _postRequest('UpdateChatDisappearingMessagesSetting', {
      'ChatId': chatId,
      'DisappearingMessagesSettingId': disappearingMessagesSettingId,
      'UserId': userId,
      'Minutes': minutes,
    });
  }
}

// A simple class to represent Guid since Dart doesn't have a built-in one
class Guid {
  final String value;

  Guid(this.value);

  @override
  String toString() => value;
}