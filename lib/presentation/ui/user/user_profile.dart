import 'package:e_commerce_application/domain/services/auth_services.dart';
import 'package:e_commerce_application/routes/app_route_const.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class UserProfile extends StatefulWidget {
  const UserProfile({super.key});

  @override
  State<UserProfile> createState() => _UserProfileState();
}

class _UserProfileState extends State<UserProfile> {
  @override
  Widget build(BuildContext context) {
    AuthService authService = AuthService();

    return Column(
      children: [
        SizedBox(
          height: 100,
        ),
        Center(
          child: Text('User profile'),
        ),
        ElevatedButton(
            onPressed: () {
              authService.signout();
              GoRouter.of(context).goNamed(MyAppRouteConstants.wrapperRoute);
            },
            child: const Text('signout'))
      ],
    );
  }
}
