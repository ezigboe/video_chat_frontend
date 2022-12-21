part of 'auth_cubit.dart';

abstract class AuthState extends Equatable {
  const AuthState();

  @override
  List<Object> get props => [];
}

class AuthLoading extends AuthState {}

class AuthLoggedIn extends AuthState {
  User userData;
  AuthLoggedIn(this.userData);
   @override
  List<Object> get props=>[userData];
}

class AuthLoggedOut extends AuthState {}

class AuthPasswordResetEmailSent extends AuthState {
  String message;
  AuthPasswordResetEmailSent({required this.message});
}

class AuthPasswordResetComplete extends AuthState {}
class AuthTempLoader extends AuthState{}

class AuthFlowError extends AuthState{
  String error;
  AuthFlowError(this.error);
  @override
  List<Object> get props=>[error];
}

class AuthError extends AuthState{
  String error;
  AuthError(this.error);
  @override
  List<Object> get props=>[error];
}