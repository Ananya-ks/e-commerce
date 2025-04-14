import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:e_commerce_application/data/models/admin_product_model.dart';
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
  _deleteProduct(String productName) {
    final bloc = BlocProvider.of<AdminProductFormBloc>(context);
    bloc.add(AdminProductDeleteButtonClickEvent(productName: productName));
  }

  _editProduct(String productName, String adminEmail) async {
    final querySnapshot = await FirebaseFirestore.instance
        .collection('admin')
        .doc(adminEmail)
        .collection('product')
        .where('product_name', isEqualTo: productName)
        .get();
    if (querySnapshot.docs.isNotEmpty) {
      final doc = querySnapshot.docs.first;
      final adminProductModel = AdminProdcutModel(
        productDesc: doc['product_desc'],
        productId: doc.id,
        productName: doc['product_name'],
        productPrice: doc['product_price'],
        productQuantity: doc['product_quantity'],
        productUrls: List<String>.from(doc['product_urls']),
      );
      context.pushNamed(
        MyAppRouteConstants.adminEditProductForm,
        extra: {
          'adminProductModel': adminProductModel,
          'newProductImages': []
        },
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final adminEmail = widget.adminEmail;
    return BlocConsumer<AdminProductFormBloc, AdminProductFormState>(
      listener: (context, state) {
        if (state is AdminProductDeleteSuccessState) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Product deleted successfully')),
          );
        } else if (state is AdminProductDeleteErrorState) {
          ScaffoldMessenger.of(context)
              .showSnackBar(SnackBar(content: Text(state.errorMessage)));
        }
      },
      builder: (context, state) {
        if (state is AdminProductDeleteLoadingState) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        }

        return Scaffold(
          appBar: AppBar(
            title: const Text('Products'),
          ),
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
          body: StreamBuilder<QuerySnapshot>(
            stream: FirebaseFirestore.instance
                .collection('admin')
                .doc(adminEmail)
                .collection('product')
                .snapshots(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(child: CircularProgressIndicator());
              }

              if (snapshot.hasError) {
                return Center(child: Text('Error: ${snapshot.error}'));
              }

              final products = snapshot.data?.docs ?? [];

              if (products.isEmpty) {
                return const Center(child: Text('No products found.'));
              }

              return Padding(
                padding: const EdgeInsets.all(8.0),
                child: GridView.builder(
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    crossAxisSpacing: 10.0,
                    mainAxisSpacing: 10.0,
                    childAspectRatio: 1 / 2.21,
                  ),
                  itemCount: products.length,
                  itemBuilder: (context, index) {
                    final productData =
                        products[index].data() as Map<String, dynamic>;
                    final productName =
                        productData['product_name'] ?? 'Unknown';
                    final productPrice = productData['product_price'] ?? '0';
                    final productQuantity =
                        productData['product_quantity'] ?? '0';
                    final productDesc =
                        productData['product_desc'] ?? 'No description';
                    final productImages = (productData['product_urls'] != null &&
                            productData['product_urls'] is List)
                        ? List<String>.from(productData['product_urls'])
                        : [];

                    return Card(
                      elevation: 4,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(20.0),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              productName.toString().toUpperCase(),
                              style: const TextStyle(
                                fontSize: 18.0,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(height: 5.0),
                            productImages.isNotEmpty
                                ? AspectRatio(
                                    aspectRatio: 1,
                                    child: Image.network(
                                      productImages[0],
                                      fit: BoxFit.cover,
                                    ),
                                  )
                                : const Icon(Icons.image_not_supported),
                            const SizedBox(height: 10.0),
                            Text(
                              "Rs: $productPrice",
                              style: const TextStyle(fontSize: 18),
                            ),
                            const SizedBox(height: 5.0),
                            Text("Quantity: $productQuantity"),
                            const SizedBox(height: 5.0),
                            Text(
                              "Description: $productDesc",
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                            ),
                            const SizedBox(height: 10),
                            Column(
                              children: [
                                SizedBox(
                                  height: 30,
                                  width: 300,
                                  child: ElevatedButton.icon(
                                    onPressed: () => _editProduct(
                                        productName, widget.adminEmail),
                                    icon: const Icon(Icons.edit,
                                        color: Colors.black),
                                    label: const Text(
                                      'Edit',
                                      style: TextStyle(
                                          color: Colors.black, fontSize: 15),
                                    ),
                                  ),
                                ),
                                const SizedBox(height: 10),
                                SizedBox(
                                  height: 30,
                                  width: 300,
                                  child: ElevatedButton.icon(
                                    onPressed: () =>
                                        _deleteProduct(productName),
                                    icon: const Icon(Icons.delete,
                                        color: Colors.red),
                                    label: const Text(
                                      'Delete',
                                      style: TextStyle(
                                          color: Colors.red, fontSize: 15),
                                    ),
                                    style: ButtonStyle(
                                      backgroundColor:
                                          WidgetStateProperty.all(
                                              Colors.red.shade50),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
              );
            },
          ),
        );
      },
    );
  }
}
