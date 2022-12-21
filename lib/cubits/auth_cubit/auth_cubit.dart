import 'dart:async';
import 'dart:developer';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:video_chat/repositories/auth_repository.dart';

part 'auth_state.dart';

class AuthCubit extends Cubit<AuthState> {
  final AuthRepository _authRepository;
  AuthCubit(this._authRepository) : super(AuthLoading());
  StreamSubscription? _authSubscription;
  initAuth() async {
    emit(AuthLoading());
    _authSubscription?.cancel();

    _authSubscription =
        FirebaseAuth.instance.authStateChanges().listen((userData) async {
      if (userData != null) {
        //TODO:get UserData From server;
        String token = await userData.getIdToken();
        log(token);
        await _authRepository.updateToken(token,{});
        emit(AuthLoggedIn(userData));
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
}

String formatMessage(Object e) {
  return "Something went wrong $e ";
}
