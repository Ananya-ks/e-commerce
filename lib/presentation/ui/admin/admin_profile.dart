import 'package:e_commerce_application/domain/services/auth_services.dart';
import 'package:flutter/material.dart';

class AdminProfilePage extends StatefulWidget {
  const AdminProfilePage({super.key});

  @override
  State<AdminProfilePage> createState() => _AdminProfilePageState();
}

class _AdminProfilePageState extends State<AdminProfilePage> {
  AuthService authService = AuthService();
  @override
  Widget build(BuildContext context) {
    return  Scaffold(
      body: Column(
        children: [
          const SizedBox(height: 200,),
          const Center(
            child: Text('admin profile'),
          ),
          ElevatedButton(
              onPressed: () {
                authService.signout();
              },
              child: const Text('signout'))
        ],
      ),
    );
  }
}
