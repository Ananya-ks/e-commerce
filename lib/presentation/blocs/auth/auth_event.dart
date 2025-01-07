part of 'auth_bloc.dart';

@immutable
sealed class AuthEvent {}

class AuthUserCreationLoginButtonClickEvent extends AuthEvent {
  final String email;
  final String password;

  AuthUserCreationLoginButtonClickEvent(
      {required this.email, required this.password});
}

class AuthUserLoginEvent extends AuthEvent {
  final String email;
  final String password;

  AuthUserLoginEvent({required this.email, required this.password});
}

class AuthUserEmailVerificationEvent extends AuthEvent {}

class AuthUserGoogleLoginEvent extends AuthEvent {}

class AuthUserGoogleCheckEvent extends AuthEvent {}

class AuthAdminLoginEvent extends AuthEvent {
  final String email;
  final String password;

  AuthAdminLoginEvent( {required this.email, required this.password});
}
