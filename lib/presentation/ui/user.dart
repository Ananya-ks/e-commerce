import 'package:e_commerce_application/domain/services/auth_services.dart';
import 'package:flutter/material.dart';

class UserPage extends StatefulWidget {
  const UserPage({super.key});

  @override
  State<UserPage> createState() => _UserPageState();
}

class _UserPageState extends State<UserPage> {
  AuthService authService = AuthService();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          SizedBox(
            height: 200,
          ),
          Center(
            child: Text('Hello'),
          ),
          ElevatedButton(
              onPressed: () {
                authService.signout();
              },
              child: Text('signout'))
        ],
      ),
    );
  }
}
