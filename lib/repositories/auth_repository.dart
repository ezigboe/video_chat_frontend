import 'dart:convert';
import 'dart:developer';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:http/http.dart' as http;
import 'package:video_chat/models/user_model/user_model.dart';
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


}
