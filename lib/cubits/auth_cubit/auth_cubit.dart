import 'dart:async';
import 'dart:developer';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:video_chat/models/user_model/user_model.dart';
import 'package:video_chat/repositories/auth_repository.dart';
import 'package:video_chat/repositories/user_repository.dart';

part 'auth_state.dart';

class AuthCubit extends Cubit<AuthState> {
  final AuthRepository _authRepository;
  AuthCubit(this._authRepository) : super(AuthLoading());
  StreamSubscription? _authSubscription;
  late String authToken;
  FlutterSecureStorage storage = new FlutterSecureStorage();
  late UserRepository _userRepository;
  initAuth() async {
    emit(AuthLoading());
    _authSubscription?.cancel();

    _authSubscription =
        FirebaseAuth.instance.authStateChanges().listen((userData) async {
      if (userData != null) {
        log("User Exists");
        //TODO:get UserData From server;

        await getUserDetails(userData);
      } else {
        log("Logged Out");
        emit(AuthLoggedOut());
      }
    });
  }

  signIn(String email, String password) async {
    try {
      emit(AuthTempLoader());
      User? user = await _authRepository.signIn(email, password);
      log("here");
    } catch (e) {
      emit(AuthFlowError(formatMessage(e)));
    }
  }

  signUp(String email, String password) async {
    try {
      emit(AuthTempLoader());
      User? user = await _authRepository.signUp(email, password);
    } catch (e) {
      emit(AuthFlowError(formatMessage(e)));
    }
  }

  forgotPassword(
    String email,
  ) async {
    try {
      emit(AuthTempLoader());
      bool? done = await _authRepository.forgotPassword(
        email,
      );
      if (bool != null) {
        emit(AuthPasswordResetEmailSent(
            message: "Password Reset Email Sent Successfully"));
      } else {
        emit(AuthFlowError("Failed to Send Email"));
      }
    } catch (e) {
      emit(AuthFlowError(formatMessage(e)));
    }
  }

  confirmResetPassword(String code, String newPassword) async {
    try {
      emit(AuthTempLoader());
      bool? done =
          await _authRepository.confirmPasswordReset(code, newPassword);
      if (bool != null) {
        emit(AuthPasswordResetComplete());
      } else {
        emit(AuthFlowError("Failed to Reset Password"));
      }
    } catch (e) {
      emit(AuthFlowError(formatMessage(e)));
    }
  }

  signOut() async {
    try {
      emit(AuthLoading());
      await _authRepository.logout();
    } catch (e) {
      emit(AuthError(formatMessage(e)));
    }
  }

  getUserDetails(User userData) async {
    String token = await FirebaseAuth.instance.currentUser!.getIdToken();
    authToken = token;
    await storage.write(key: "token", value: token);
    log(token);
    _userRepository = UserRepository(authToken);
    try {
      UserModel userModel = await _userRepository.getUserDetails();
      log("Here");
      emit(AuthLoggedIn(userData, userModel));
    } catch (e) {
      if (e.toString().contains("404"))
        emit(AuthUserDetailsPending());
      else {
        log(e.toString());
        signOut();
        emit(AuthError("$e"));
      }
    }
  }

  updateUserDetails(var params) async {
    try {
      emit(AuthLoading());
      User user = FirebaseAuth.instance.currentUser!;
      params["email"] = user.email;
      UserModel userModel = await _userRepository.updateUserDetails(params);
      log("Here");
      emit(AuthLoggedIn(user, userModel));
    } catch (e) {
      if (e.toString().contains("404"))
        emit(AuthUserDetailsPending());
      else {
        log(e.toString());
        // signOut();
        emit(AuthError("$e"));
        emit(AuthUserDetailsPending());
      }
    }
  }
}

String formatMessage(Object e) {
  return "Something went wrong $e ";
}