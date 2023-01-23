import 'dart:convert';
import 'dart:developer';

import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;
import 'package:video_chat/models/user_model/user_model.dart';
import 'package:video_chat/utils/meta_strings.dart';
import 'package:socket_io_client/socket_io_client.dart' as IO;

class UserRepository {
  static String? authToken;
  UserRepository(token) {
    setToken(token);
  }

  setToken(String? token) async {
    authToken = token;
    if (authToken == null)
      authToken = await FlutterSecureStorage().read(key: "token") ?? token;
  }

  getToken() async {
    return await FlutterSecureStorage().read(key: 'token') ?? authToken;
  }

  updateUserDetails(String fullName, String email, String phone,
      String profileImage, String gender, DateTime dob) async {
    try {
      var headers = {
        "Authorization": "Bearer $authToken",
        "Content-Type": "application/json"
      };
      var params = {
        "fullName": fullName,
        "dob": dob.toUtc().toIso8601String(),
        "gender": gender,
        "profileImage": profileImage,
        "email": email,
        "phone": phone,
      };
      http.Response response = await http.post(
          Uri.parse(MetaStrings.userUpdateUrl),
          headers: headers,
          body: jsonEncode(params));
      log(response.body);
      if (response.statusCode == 200 || response.statusCode == 201) {
        return UserModel.fromJson(jsonDecode(response.body)["user"]);
      } else {
        throw Exception(jsonDecode(response.body).toString() +
            response.statusCode.toString());
      }
    } catch (e) {
      log(e.toString());
      rethrow;
    }
  }

  getUserDetails() async {
    try {
      var headers = {
        "Authorization": "Bearer $authToken",
        "Content-Type": "application/json"
      };
      log(headers.toString());
      http.Response response = await http.get(
        Uri.parse(MetaStrings.baseUrl + "/self"),
        headers: headers,
      );
      log(response.body);
      if (response.statusCode == 200) {
        return UserModel.fromJson(jsonDecode(response.body)["user"]);
      } else {
        throw Exception(
            jsonDecode(response.body)["message"] + response.statusCode);
      }
    } catch (e) {
      rethrow;
    }
  }
   Future<IO.Socket> getSocket() async {
    try {
      authToken = await getToken();
      var headers = {
        "Authorization": "Bearer $authToken",
        "Content-Type": "application/json"
      };
      IO.Socket socket = IO.io(
          MetaStrings.socketBaseUrl,
          IO.OptionBuilder()
              .setTransports(['websocket']) // for Flutter or Dart VM
              .disableAutoConnect() // disable auto-connection
              .setExtraHeaders(headers) // optional
              .build());
      socket.connect();
      return socket;
    } catch (e) {
      rethrow;
    }
  }
}
