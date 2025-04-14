import 'package:flutter/material.dart';

class UserWishlist extends StatefulWidget {
  const UserWishlist({super.key});

  @override
  State<UserWishlist> createState() => _UserWishlistState();
}

class _UserWishlistState extends State<UserWishlist> {
  @override
  Widget build(BuildContext context) {
    return const Column(
      children: [
        SizedBox(
          height: 100,
        ),
        Center(
          child: Text('User Wishlist'),
        ),
      ],
    );
  }
}
