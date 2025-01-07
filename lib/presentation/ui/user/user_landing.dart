import 'package:e_commerce_application/presentation/ui/user/user_cart.dart';
import 'package:e_commerce_application/presentation/ui/user/user_home.dart';
import 'package:e_commerce_application/presentation/ui/user/user_profile.dart';
import 'package:e_commerce_application/presentation/ui/user/user_wishlist.dart';
import 'package:flutter/material.dart';
import 'package:google_nav_bar/google_nav_bar.dart';

class UserLandingPage extends StatefulWidget {
  const UserLandingPage({super.key});

  @override
  State<UserLandingPage> createState() => _UserLandingPageState();
}

class _UserLandingPageState extends State<UserLandingPage> {
  int _selectedIndex = 0;
  void _onTabChange(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    final List<Widget> _pages = [
      UserHome(),
      UserWishlist(),
      UserCart(
        // userCartProductModel: UserCartProductModel(
        //     productId: productId,
        //     productName: productName,
        //     quantity: quantity,
        //     pricePerUnit: pricePerUnit,
        //     imageUrl: imageUrl),
      ),
      UserProfile(),
    ];
    return Scaffold(
      bottomNavigationBar: Container(
        color: Colors.brown.shade400,
        child: Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: 15,
            vertical: 10,
          ),
          child: GNav(
            padding: const EdgeInsets.all(15),
            backgroundColor: Colors.brown.shade400,
            color: Colors.white,
            tabBackgroundColor: Colors.grey,
            gap: 8,
            activeColor: Colors.white,
            tabs: const [
              GButton(
                icon: Icons.home,
                text: 'Home',
              ),
              GButton(
                icon: Icons.favorite,
                text: 'Wishlist',
              ),
              GButton(
                icon: Icons.shopping_bag_rounded,
                text: 'Cart',
              ),
              GButton(
                icon: Icons.person,
                text: 'Profile',
              )
            ],
            onTabChange: _onTabChange,
          ),
        ),
      ),
      body: IndexedStack(
        index: _selectedIndex,
        children: _pages,
      ),
    );
  }
}
