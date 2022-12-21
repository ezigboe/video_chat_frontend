import 'dart:convert';
import 'dart:developer';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:http/http.dart' as http;
import 'package:video_chat/utils/meta_strings.dart';

class AuthRepository {
  static FirebaseAuth instance = FirebaseAuth.instance;
  Future<User?> signUp(String email, String password) async {
    try {
      UserCredential? data = await instance.createUserWithEmailAndPassword(
          email: email, password: password);
      return data.user;
    } catch (e) {
      if (e is FirebaseException) {
        log("Firebase Exception ${e}");
        rethrow;
      }
    }
  }

  Future<User?> signIn(String email, String password) async {
    try {
      UserCredential? data = await instance.signInWithEmailAndPassword(
          email: email, password: password);
      return data.user;
    } catch (e) {
      if (e is FirebaseException) {
        log("Firebase Exception ${e}");
        rethrow;
      }
    }
  }

  Future<bool?> forgotPassword(String email) async {
    try {
      await instance.sendPasswordResetEmail(
        email: email,
      );
      return true;
    } catch (e) {
      if (e is FirebaseException) {
        log("Firebase Exception ${e}");
        rethrow;
      }
    }
  }

  Future<bool?> confirmPasswordReset(String code, String newPassword) async {
    try {
      await instance.confirmPasswordReset(code: code, newPassword: newPassword);
      return true;
    } catch (e) {
      if (e is FirebaseException) {
        log("Firebase Exception ${e}");
        rethrow;
      }
    }
  }

  logout() async {
    await instance.signOut();
  }

  updateToken(String token,var params) async {
    try {
      var headers = {
        "Authorization": "Bearer $token",
        "Content-Type": "application/json"
      };
      var params = {
        "first_name": "Vaibhav",
        "last_name": "Anchan",
        "password": "abchsj@A1s",
        "email": "vaibhavanchan359@gmail.com",
        "phone": "7204073116"
      };
      http.Response response = await http.post(
          Uri.parse(MetaStrings.userUpdateUrl),
          headers: headers,
          body: jsonEncode(params));
      log(response.body.toString());
    } catch (e) {
      log(e.toString());
    }
  }
}
