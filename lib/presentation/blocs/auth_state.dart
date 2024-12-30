part of 'auth_bloc.dart';

@immutable
sealed class AuthState {}

final class AuthInitial extends AuthState {}

abstract class AuthActionState extends AuthState {}

class AuthUserCreationLoginLoadingState extends AuthState {}

class AuthUserCreationLoginSuccessState extends AuthState {}

class AuthUserCreationLoginErrorState extends AuthState {
  final String message;

  AuthUserCreationLoginErrorState({required this.message});
}

class AuthUserEmailVerificationLoadingState extends AuthState {}

class AuthUserEmailVerificationSuccessState extends AuthActionState {}

class AuthUserEmailVerificationErrorState extends AuthActionState {}

class AuthUserLoginLoadingState extends AuthState {}

class AuthLoginSuccessActionState extends AuthActionState {}

class AuthLoginErrorActionState extends AuthActionState {
  final String message;

  AuthLoginErrorActionState({required this.message});
}

class AuthGoogleLoginLoadingActionState extends AuthState {}

class AuthGoogleLoginSuccessActionState extends AuthActionState {}

class AuthGoogleLoginErrorActionState extends AuthActionState {}

class AuthAdminLoginLoadingState extends AuthActionState {}

class AuthAdminLoginSuccessState extends AuthActionState {
  final User? user;
  AuthAdminLoginSuccessState({ required this.user});
}

class AuthAdminLoginErrorState extends AuthActionState {
  final String message;

  AuthAdminLoginErrorState({required this.message});
}
