import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:e_commerce_application/domain/services/auth_services.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:meta/meta.dart';

part 'auth_event.dart';
part 'auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final auth = AuthService();
  String? profilePicture;
  final _firestore = FirebaseFirestore.instance;

  AuthBloc() : super(AuthInitial()) {
    on<AuthUserCreationLoginButtonClickEvent>(
        authUserCreationLoginButtonClickEvent);
    on<AuthUserLoginEvent>(authUserLoginEvent);
    on<AuthUserEmailVerificationEvent>(authUserEmailVerificationEvent);
    on<AuthUserGoogleLoginEvent>(authUserGoogleLoginEvent);
    on<AuthAdminLoginEvent>(authAdminLoginEvent);
  }

  FutureOr<void> authUserCreationLoginButtonClickEvent(
      AuthUserCreationLoginButtonClickEvent event,
      Emitter<AuthState> emit) async {
    emit(AuthUserCreationLoginLoadingState());
    if (event.email.isEmpty && event.password.isEmpty) {
      emit(AuthUserCreationLoginErrorState(
          message: 'Email and password cannot be empty'));
      return;
    }
    if (event.email.isEmpty) {
      emit(AuthUserCreationLoginErrorState(message: 'Email cannot be empty'));
      return;
    }
    if (event.password.isEmpty) {
      emit(
          AuthUserCreationLoginErrorState(message: 'Password cannot be empty'));
      return;
    }
    try {
      final user = await auth.createUserWithEmailAndpassword(
          event.email, event.password);
      if (user != null) {
        await Future.sync(() => add(AuthUserEmailVerificationEvent()));
      }
    } on FirebaseAuthException catch (e) {
      String errorMessage;
      switch (e.code) {
        case 'invalid-email':
          errorMessage = 'The email address is badly formatted.';
          break;
        case 'email-already-in-use':
          errorMessage =
              'The email address is already in use by another account.';
          break;
        case 'weak-password':
          errorMessage = 'The password must be at least 6 characters long.';
          break;
        case 'operation-not-allowed':
          errorMessage =
              'Email/password accounts are not enabled. Contact support.';
          break;
        default:
          errorMessage = 'An unknown error occurred. Please try again.';
      }
      emit(AuthUserCreationLoginErrorState(message: errorMessage));
    } catch (e) {
      emit(AuthUserCreationLoginErrorState(
          message: 'An unexpected error occurred.'));
    }
  }

  FutureOr<void> authUserEmailVerificationEvent(
      AuthUserEmailVerificationEvent event, Emitter<AuthState> emit) async {
    try {
      emit(AuthUserEmailVerificationLoadingState());
      await auth.sendEmailVerificationLink();
      bool isEmailVerified = false;
      while (!isEmailVerified) {
        await Future.delayed(const Duration(seconds: 5));
        await FirebaseAuth.instance.currentUser?.reload();
        isEmailVerified =
            FirebaseAuth.instance.currentUser?.emailVerified ?? false;
      }
      emit(AuthUserEmailVerificationSuccessState());
    } catch (e) {
      emit(AuthUserEmailVerificationErrorState());
    }
  }

  FutureOr<void> authUserLoginEvent(
      AuthUserLoginEvent event, Emitter<AuthState> emit) async {
    emit(AuthUserLoginLoadingState());
    if (event.email.isEmpty && event.password.isEmpty) {
      emit(AuthLoginErrorActionState(
          message: 'Email and password cannot be empty'));
      return;
    }
    if (event.email.isEmpty) {
      emit(AuthLoginErrorActionState(message: 'Email cannot be empty'));
      return;
    }
    if (event.password.isEmpty) {
      emit(AuthLoginErrorActionState(message: 'Password cannot be empty'));
      return;
    }
    try {
      final userQuerySnapshot = await FirebaseFirestore.instance
          .collection('users')
          .where('email', isEqualTo: event.email)
          .get();
      if (userQuerySnapshot.docs.isNotEmpty) {
        final user = await auth.loginUserWithEmailAndpassword(
            event.email, event.password);
        if (user != null) {
          emit(AuthLoginSuccessActionState());
        }
      } else {
        emit(AuthLoginErrorActionState(message: 'User not found'));
      }
    } on FirebaseAuthException catch (e) {
      String errorLoginMessage;
      switch (e.code) {
        case 'invalid-email':
          errorLoginMessage = 'The email address is badly formatted';
          break;
        case 'user-disabled':
          errorLoginMessage = 'This account has been disabled.';
          break;
        case 'user-not-found':
          errorLoginMessage = 'No account found with this email.';
          break;
        case 'invalid-credential':
          errorLoginMessage = 'Invalid credentials';
          break;
        case 'too-many-requests':
          errorLoginMessage = 'Too many failed attempts. Try again later.';
          break;
        case 'network-request-failed':
          errorLoginMessage = 'Check your internet connection.';
          break;
        case 'operation-not-allowed':
          errorLoginMessage = 'Login is not allowed. Contact support.';
          break;
        default:
          errorLoginMessage = 'An unknown error occurred. Please try again.';
          print(e.code);
      }
      emit(AuthLoginErrorActionState(message: errorLoginMessage));
    } catch (e) {
      emit(AuthLoginErrorActionState(message: 'Error occured'));
    }
  }

  FutureOr<void> authUserGoogleLoginEvent(
      AuthUserGoogleLoginEvent event, Emitter<AuthState> emit) async {
    emit(AuthGoogleLoginLoadingActionState());
    try {
      final userCred = await auth.loginWithGoogle();
      final user = userCred?.user;
      if (user != null) {
        profilePicture = user.photoURL;
        // emit(AuthGoogleAuthenticated(profilePicture: profilePicture));
        emit(AuthGoogleLoginSuccessActionState());
      } else {
        emit(AuthGoogleLoginErrorActionState());
        // emit(AuthGoogleUnAuthenticated());
      }
    } catch (e) {
      emit(AuthGoogleLoginErrorActionState());
    }
  }

  FutureOr<void> authAdminLoginEvent(
      AuthAdminLoginEvent event, Emitter<AuthState> emit) async {
    emit(AuthAdminLoginLoadingState());
    if (event.email.isEmpty && event.password.isEmpty) {
      emit(AuthLoginErrorActionState(
          message: 'Email and password cannot be empty'));
      return;
    }
    if (event.email.isEmpty) {
      emit(AuthLoginErrorActionState(message: 'Email cannot be empty'));
      return;
    }
    if (event.password.isEmpty) {
      emit(AuthLoginErrorActionState(message: 'Password cannot be empty'));
      return;
    }
    try {
      final adminQuerySnapshot = await _firestore
          .collection('admin')
          .where('email', isEqualTo: event.email)
          .get();
      print('Query snapshot, $adminQuerySnapshot');
      if (adminQuerySnapshot.docs.isNotEmpty) {
        final adminData = adminQuerySnapshot.docs.first.data();
        if ((adminData['email'] == event.email &&
            adminData['password'] == event.password)) {
          final userCredential = await FirebaseAuth.instance
              .signInWithEmailAndPassword(
                  email: event.email, password: event.password);
          if (userCredential.user != null) {
            print('admin loggeddin');
            emit(AuthAdminLoginSuccessState(user: userCredential.user));
          } else {
            emit(AuthAdminLoginErrorState(message: 'Failed to login as admin'));
          }
        } else {
          emit(AuthAdminLoginErrorState(message: 'Invalid admin credentials'));
        }
      } else {
        emit(AuthAdminLoginErrorState(message: 'Admin not found'));
      }
    } on FirebaseAuthException catch (e) {
      String errorLoginMessage;
      switch (e.code) {
        case 'invalid-email':
          errorLoginMessage = 'The email address is badly formatted';
          break;
        case 'user-disabled':
          errorLoginMessage = 'This account has been disabled.';
          break;
        case 'user-not-found':
          errorLoginMessage = 'No account found with this email.';
          break;
        case 'invalid-credential':
          errorLoginMessage = 'Invalid credentials';
          break;
        case 'too-many-requests':
          errorLoginMessage = 'Too many failed attempts. Try again later.';
          break;
        case 'network-request-failed':
          errorLoginMessage = 'Check your internet connection.';
          break;
        case 'operation-not-allowed':
          errorLoginMessage = 'Login is not allowed. Contact support.';
          break;
        default:
          errorLoginMessage = 'An unknown error occurred. Please try again.';
          print(e.code);
      }
      emit(AuthAdminLoginErrorState(message: errorLoginMessage));
    } catch (e) {
      emit(AuthAdminLoginErrorState(message: 'Error occured: ${e.toString()}'));
    }
  }
}
