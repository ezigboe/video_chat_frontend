import 'dart:convert';
import 'dart:developer';

import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;
import 'package:video_chat/models/messages_model/messages_model.dart';
import 'package:video_chat/utils/meta_strings.dart';

import '../models/chat_model/chat_model.dart';

class ChatsRepository {
  static String? authToken;
  getToken() async {
    return await FlutterSecureStorage().read(key: "token");
  }

  getAllChats() async {
    try {
      authToken = await getToken();
      var headers = {
        "Authorization": "Bearer $authToken",
        "Content-Type": "application/json"
      };
      log(headers.toString());
      http.Response response = await http.get(
        Uri.parse(MetaStrings.chatsUrl),
        headers: headers,
      );
      log(response.body);
      if (response.statusCode == 200) {
        return jsonDecode(response.body)["chats"]
            .map<ChatModel>((e) => ChatModel.fromJson(e))
            .toList();
      } else {
        throw Exception(jsonDecode(response.body)["errors"][0]["message"] +
            response.statusCode);
      }
    } catch (e) {
      rethrow;
    }
  }

  getSpecificChats(String threadId) async {
    try {
      authToken = await getToken();
      var headers = {
        "Authorization": "Bearer $authToken",
        "Content-Type": "application/json"
      };
      log(headers.toString());
      http.Response response = await http.get(
        Uri.parse(MetaStrings.messagesUrl + "/$threadId"),
        headers: headers,
      );
      log(response.body);
      if (response.statusCode == 200) {
        return jsonDecode(response.body)["messages"]
            .map<MessagesModel>((e) => MessagesModel.fromJson(e))
            .toList();
      } else {
        throw Exception(jsonDecode(response.body)["errors"][0]["message"] +
            response.statusCode);
      }
    } catch (e) {
      rethrow;
    }
  }
}
