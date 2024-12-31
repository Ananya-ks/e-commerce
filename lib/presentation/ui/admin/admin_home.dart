import 'package:flutter/material.dart';

class AdminHomePage extends StatefulWidget {
  const AdminHomePage({super.key});

  @override
  State<AdminHomePage> createState() => _AdminHomePageState();
}

class _AdminHomePageState extends State<AdminHomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        // child: Image.network(
        //   'https://nitxzpjfocjiazstpqdk.supabase.co/storage/v1/object/public/product-image/public/1735580539415.jpg',
        //   // 'https://nitxzpjfocjiazstpqdk.supabase.co/storage/v1/object/public/product-image/product-image/public/1735580738986.jpg',
        //   errorBuilder: (context, error, stackTrace) {
        //     return Icon(Icons
        //         .error); // Display an error icon if the image fails to load.
        //   },
        // ),
        child: Center(
          child: Text('admin home'),
        ),
      ),
    );
  }
}
