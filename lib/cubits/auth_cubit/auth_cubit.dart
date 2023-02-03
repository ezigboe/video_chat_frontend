import 'dart:async';
import 'dart:developer';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:video_chat/models/user_model/user_model.dart';
import 'package:video_chat/repositories/auth_repository.dart';
import 'package:video_chat/repositories/user_repository.dart';
import 'package:video_chat/utils/upload_media.dart';
import 'package:socket_io_client/socket_io_client.dart' as IO;

part 'auth_state.dart';

class AuthCubit extends Cubit<AuthState> {
  final AuthRepository _authRepository;
  AuthCubit(this._authRepository) : super(AuthLoading());
  StreamSubscription? _authSubscription;
  StreamController? timer;
  late String authToken;
  FlutterSecureStorage storage = new FlutterSecureStorage();
  late UserRepository _userRepository;
  late IO.Socket socket;
  initAuth() async {
    emit(AuthLoading());
    timer?.close();
    timer = StreamController<DateTime>.broadcast();

    Stream.periodic(Duration(minutes: 1), (value) {
      return value;
    }).listen((event) {
      log("value");
      timer!.sink.add(DateTime.now());
    });

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
      socket.clearListeners();
      socket.disconnect();
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
      socket = await _userRepository.getSocket();
      log("here");
      UserModel userModel = await _userRepository.getUserDetails();
      log("He0re ${socket.connected}");
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

  updateUserDetails(String phone, String fullName, DateTime dob, String gender,
      SelectedMedia media) async {
    try {
      emit(AuthLoading());

      Stream<TaskSnapshot> result = uploadData(media.storagePath, media.bytes);

      result.listen((data) async {
        try {
          log((data.bytesTransferred / data.totalBytes).toString());
          if (data.state == TaskState.running) {
          } else if (data.state == TaskState.success) {
            String url = await data.ref.getDownloadURL();
            if (url.isNotEmpty) {
              User user = FirebaseAuth.instance.currentUser!;

              UserModel userModel = await _userRepository.updateUserDetails(
                fullName,
                user.email!,
                phone,
                url,
                gender,
                dob,
              );
              log("Here");
              emit(AuthLoggedIn(user, userModel));
            } else {
              emit(AuthUserDetailsPending(
                  error: "Image Upload failed please try again"));
            }
          }
        } catch (e) {
          log("errroor-1111------------------------------------------------$e");
          emit(AuthUserDetailsPending(error: e.toString()));
        }
      });
    } catch (e) {
      log("errroor-------------------------------------------------$e");
      emit(AuthUserDetailsPending(error: e.toString()));
    }
  }
}

String formatMessage(Object e) {
  return "Something went wrong $e ";
}
