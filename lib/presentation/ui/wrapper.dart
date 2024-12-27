import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:e_commerce_application/presentation/blocs/auth_bloc.dart';
import 'package:e_commerce_application/presentation/ui/admin/admin_landing.dart';
import 'package:e_commerce_application/presentation/ui/email_verification.dart';
import 'package:e_commerce_application/presentation/ui/user.dart';
import 'package:e_commerce_application/presentation/ui/landing.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../routes/app_route_const.dart';

class Wrapper extends StatefulWidget {
  const Wrapper({super.key});

  @override
  State<Wrapper> createState() => _WrapperState();
}

class _WrapperState extends State<Wrapper> {
  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AuthBloc, AuthState>(
      listener: (context, state) {
        if (state is AuthUserCreationLoginErrorState) {
          ScaffoldMessenger.of(context)
              .showSnackBar(SnackBar(content: Text(state.message)));
        } else if (state is AuthLoginErrorActionState) {
          ScaffoldMessenger.of(context)
              .showSnackBar(SnackBar(content: Text(state.message)));
        } else if (state is AuthAdminLoginErrorState) {
          ScaffoldMessenger.of(context)
              .showSnackBar(SnackBar(content: Text(state.message)));
        } else if (state is AuthUserEmailVerificationSuccessState ||
            state is AuthLoginSuccessActionState ||
            state is AuthGoogleLoginSuccessActionState) {
          GoRouter.of(context).pushNamed(MyAppRouteConstants.wrapperRoute);
        } else if (state is AuthAdminLoginSuccessState) {
          GoRouter.of(context).pushNamed(MyAppRouteConstants.adminLandingPage);
        }
      },
      builder: (context, state) {
        if (state is AuthUserCreationLoginLoadingState ||
            state is AuthUserEmailVerificationLoadingState ||
            state is AuthUserLoginLoadingState ||
            state is AuthGoogleLoginLoadingActionState ||
            state is AuthAdminLoginLoadingState) {
          return Center(
            child: Container(
              color: Colors.white,
              child: const CircularProgressIndicator(),
            ),
          );
        }
        return StreamBuilder(
          stream: FirebaseAuth.instance.authStateChanges(),
          builder: (context, snapshot) {
            print('Wrapper state $state');
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(
                child: CircularProgressIndicator(),
              );
            } else if (snapshot.hasError) {
              return const Center(
                child: Text('Has error'),
              );
            } else {
              if (snapshot.data == null) {
                print('User not logged in');
                return Landing();
              } else {
                final user = snapshot.data!;
                print('User email is ${user.email}');

                // Check if the email is verified
                if (!user.emailVerified) {
                  return EmailVerificationScreen();
                }

                // Check if the user is an admin or regular user
                return FutureBuilder<bool>(
                  future: _isAdminEmail(user.email),
                  builder: (context, futureSnapshot) {
                    if (futureSnapshot.connectionState ==
                        ConnectionState.waiting) {
                      return const Center(
                        child: CircularProgressIndicator(),
                      );
                    } else if (futureSnapshot.hasError ||
                        futureSnapshot.data == false) {
                      return UserPage();
                    } else {
                      return AdminLandinPage();
                    }
                  },
                );
              }
            }
          },
        );
      },
    );
  }

  Future<bool> _isAdminEmail(String? userEmail) async {
    if (userEmail == null) return false;
    try {
      final docSnapshot = await FirebaseFirestore.instance
          .collection('admin')
          .where('email', isEqualTo: userEmail)
          .get();
      print('Admin check result: $docSnapshot');
      return docSnapshot.docs.isNotEmpty;
    } catch (e) {
      print('Error checking admin email: $e');
      return false;
    }
  }
}
