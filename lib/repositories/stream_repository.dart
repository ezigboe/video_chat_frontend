import 'dart:convert';
import 'dart:developer';

import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;
import 'package:video_chat/models/stream_model/stream_model.dart';
import 'package:video_chat/utils/meta_strings.dart';
import 'package:socket_io_client/socket_io_client.dart' as IO;

class StreamRepository {
  StreamRepository() {}
  static String? authToken;
  getToken() async {
    return await FlutterSecureStorage().read(key: "token");
  }

  getLiveStreamList() async {
    try {
      authToken = await getToken();
      var headers = {
        "Authorization": "Bearer $authToken",
        "Content-Type": "application/json"
      };
      log(headers.toString());
      http.Response response = await http.get(
        Uri.parse(MetaStrings.liveStreamListUrl),
        headers: headers,
      );
      log(response.body);
      if (response.statusCode == 200) {
        return jsonDecode(response.body)["streams"]
            .map<StreamModel>((e) => StreamModel.fromJson(e))
            .toList();
      } else {
        throw Exception(jsonDecode(response.body)["errors"][0]["message"] +
            response.statusCode);
      }
    } catch (e) {
      rethrow;
    }
  }

  joinStream(String id, DateTime startAt) async {
    try {
      authToken = await getToken();
      var headers = {
        "Authorization": "Bearer $authToken",
        "Content-Type": "application/json"
      };
      log(headers.toString());
      var params = {"id": id, "startAt": startAt.toUtc().toIso8601String()};
      http.Response response = await http.post(
          Uri.parse(MetaStrings.liveStreamJoinUrl),
          headers: headers,
          body: jsonEncode(params));
      log(response.body);
      if (response.statusCode == 200) {
        return StreamModel.fromJson(jsonDecode(response.body)["stream"]);
      } else {
        throw Exception(jsonDecode(response.body)["error"]["message"] +
            response.statusCode);
      }
    } catch (e) {
      rethrow;
    }
  }

  leaveStream(String id, DateTime endAt) async {
    try {
      authToken = await getToken();
      var headers = {
        "Authorization": "Bearer $authToken",
        "Content-Type": "application/json"
      };
      log(headers.toString());
      var params = {"id": id, "endAt": endAt.toUtc().toIso8601String()};
      http.Response response = await http.post(
          Uri.parse(MetaStrings.liveStreamLeaveUrl),
          headers: headers,
          body: jsonEncode(params));
      log("here-e-e-e-e-e");
      log("Stream left response ${response.body.toString()}");
      if (response.statusCode == 200) {
        return true; //StreamModel.fromJson(jsonDecode(response.body)["stream"]);
      } else {
        throw Exception(jsonDecode(response.body)["errors"]["message"] +
            response.statusCode);
      }
    } catch (e) {
      rethrow;
    }
  }

  createStream(
      {required String title,
      required DateTime startAt,
      required DateTime endAt,
      String? thumbnailUrl}) async {
    try {
      authToken = await getToken();
      var headers = {
        "Authorization": "Bearer $authToken",
        "Content-Type": "application/json"
      };
      log(headers.toString());
      var params = {
        "title": title,
        "startAt": startAt.toUtc().toIso8601String(),
        "endAt": endAt.toUtc().toIso8601String(),
        "thumbnailUrl": thumbnailUrl
      };
      http.Response response = await http.post(
          Uri.parse(MetaStrings.liveStreamListUrl),
          headers: headers,
          body: jsonEncode(params));
      log(response.body);
      if (response.statusCode == 200 || response.statusCode == 201) {
        return StreamModel.fromJson(jsonDecode(response.body)["stream"]);
      } else {
        throw jsonDecode(response.body)["errors"][0]["message"] +
            " " +
            response.statusCode.toString();
      }
    } catch (e) {
      rethrow;
    }
  }

  
}
