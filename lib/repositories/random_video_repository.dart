import 'dart:convert';
import 'dart:developer';

import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;
import 'package:video_chat/models/random_video_model/random_video_model.dart';
import 'package:video_chat/utils/meta_strings.dart';

class RandomVideoRepository {
  static String? authToken;
  getToken() async {
    return await FlutterSecureStorage().read(key: "token");
  }

  getRandomUser() async {
    try {
      authToken = await getToken();
      var headers = {
        "Authorization": "Bearer $authToken",
        "Content-Type": "application/json"
      };
      log(headers.toString());
      http.Response response = await http.get(
        Uri.parse(MetaStrings.randomVideoUrl),
        headers: headers,
      );
      log(response.statusCode.toString());
      if (response.statusCode == 201) {
        return RandomVideoModel.fromJson(jsonDecode(response.body));
      } else {
        throw jsonDecode(response.body)["message"] +
            response.statusCode.toString();
      }
    } catch (e) {
      rethrow;
    }
  }
  deleteCall() async {
    try {
      authToken = await getToken();
      var headers = {
        "Authorization": "Bearer $authToken",
        "Content-Type": "application/json"
      };
      log(headers.toString());
      http.Response response = await http.delete(
        Uri.parse(MetaStrings.randomVideoUrl),
        headers: headers,
      );
      log(response.body);
      if (response.statusCode == 201) {
        return true;
      } else {
        throw Exception(jsonDecode(response.body)["errors"][0]["message"] +
            response.statusCode);
      }
    } catch (e) {
      rethrow;
    }
  }
}
