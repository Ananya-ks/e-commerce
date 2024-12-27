import 'package:e_commerce_application/routes/app_route_const.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class AdminProductsPage extends StatefulWidget {
  const AdminProductsPage({super.key});

  @override
  State<AdminProductsPage> createState() => _AdminProductsPageState();
}

class _AdminProductsPageState extends State<AdminProductsPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.brown.shade400,
        foregroundColor: Colors.white,
        onPressed: () {
          GoRouter.of(context).pushNamed(MyAppRouteConstants.adminNewProductForm);
        },
        child: Icon(Icons.add),
      ),
      body: Center(
        child: Text('admin products'),
      ),
    );
  }
}
