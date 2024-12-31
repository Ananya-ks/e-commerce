import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:e_commerce_application/presentation/blocs/admin_product/admin_product_form_bloc.dart';
import 'package:e_commerce_application/routes/app_route_const.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

class AdminProductsPage extends StatefulWidget {
  final String adminEmail;
  const AdminProductsPage({super.key, required this.adminEmail});

  @override
  State<AdminProductsPage> createState() => _AdminProductsPageState();
}

class _AdminProductsPageState extends State<AdminProductsPage> {
  Future<List<Map<String, dynamic>>> _fetchProducts(String adminEmail) async {
    try {
      final querySnapshot = await FirebaseFirestore.instance
          .collection('admin')
          .doc(adminEmail)
          .collection('product')
          .get();
      print(querySnapshot.docs
          .map((doc) => doc.data() as Map<String, dynamic>)
          .toList());
      return querySnapshot.docs
          .map((doc) => doc.data() as Map<String, dynamic>)
          .toList();
    } catch (e) {
      debugPrint("Error fetching products: $e");
      return [];
    }
  }

  @override
  Widget build(BuildContext context) {
    final adminEmail = widget.adminEmail;
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.brown.shade400,
        foregroundColor: Colors.white,
        onPressed: () {
          GoRouter.of(context).pushNamed(
            MyAppRouteConstants.adminNewProductForm,
            extra: BlocProvider.of<AdminProductFormBloc>(context),
          );
        },
        child: const Icon(Icons.add),
      ),
      body: FutureBuilder<List<Map<String, dynamic>>>(
        future: _fetchProducts(adminEmail),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          }

          final products = snapshot.data ?? [];
          if (products.isEmpty) {
            return const Center(child: Text('No products found.'));
          }

          return ListView.builder(
            itemCount: products.length,
            itemBuilder: (context, index) {
              final product = products[index];
              final productName = product['product_name'] ?? 'Unknown';
              final productPrice = product['product_price'] ?? '0';
              final productQuantity = product['product_quantity'] ?? '0';
              final productDesc = product['product_desc'] ?? 'No description';
              final productImages = (product['product_urls'] != null &&
                      product['product_urls'] is List)
                  ? List<String>.from(product['product_urls'])
                  : [];
              return Card(
                child: ListTile(
                  title: Text(productName),
                  leading: productImages.isNotEmpty
                      ? Image.network(
                          productImages[0],
                          fit: BoxFit.cover,
                          width: 50,
                          height: 50,
                        )
                      : const Icon(Icons.image_not_supported),
                  subtitle: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text("Price: $productPrice"),
                      Text("Quantity: $productQuantity"),
                      Text(
                        "Description: $productDesc",
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
