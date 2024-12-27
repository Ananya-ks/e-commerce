import 'package:e_commerce_application/domain/services/auth_services.dart';
import 'package:e_commerce_application/presentation/ui/admin/admin_home.dart';
import 'package:e_commerce_application/presentation/ui/admin/admin_orders.dart';
import 'package:e_commerce_application/presentation/ui/admin/admin_products.dart';
import 'package:e_commerce_application/presentation/ui/admin/admin_profile.dart';
import 'package:flutter/material.dart';
import 'package:google_nav_bar/google_nav_bar.dart';

class AdminLandinPage extends StatefulWidget {
  const AdminLandinPage({super.key});

  @override
  State<AdminLandinPage> createState() => _AdminLandinPageState();
}

class _AdminLandinPageState extends State<AdminLandinPage> {
  AuthService authService = AuthService();
  int _selectedIndex = 0;

  final List<Widget> _pages = [
    AdminHomePage(),
    AdminProductsPage(),
    AdminOrdersPage(),
    AdminProfilePage(),
  ];

  void _onTabChange(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        bottomNavigationBar: Container(
          color: Colors.brown.shade400,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
            child: GNav(
              backgroundColor: Colors.brown.shade400,
              color: Colors.white,
              gap: 8,
              padding: const EdgeInsets.all(15),
              tabBackgroundColor: Colors.grey,
              activeColor: Colors.white,
              tabs: const [
                GButton(
                  icon: Icons.home,
                  text: 'Home',
                ),
                GButton(
                  icon: Icons.pie_chart,
                  text: 'Products',
                ),
                GButton(
                  icon: Icons.shopping_bag,
                  text: 'Orders',
                ),
                GButton(
                  icon: Icons.person,
                  text: 'Profile',
                ),
              ],
              onTabChange: _onTabChange,
            ),
          ),
        ),
        body: IndexedStack(
          index: _selectedIndex,
          children: _pages,
        ));
  }
}
