import 'package:e_commerce_application/presentation/blocs/admin_product/admin_product_form_bloc.dart';
import 'package:e_commerce_application/routes/app_route_const.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
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
          GoRouter.of(context).pushNamed(
              MyAppRouteConstants.adminNewProductForm,
              extra: BlocProvider.of<AdminProductFormBloc>(context));
        },
        child: Icon(Icons.add),
      ),
      body: Center(
        child: Text('admin products'),
      ),
    );
  }
}
