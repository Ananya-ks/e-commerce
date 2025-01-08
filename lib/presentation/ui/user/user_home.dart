import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:e_commerce_application/routes/app_route_const.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class UserHome extends StatefulWidget {
  const UserHome({super.key});

  @override
  State<UserHome> createState() => _UserHomeState();
}

class _UserHomeState extends State<UserHome> {
  @override
  Widget build(BuildContext context) {
    // final userCartBloc = BlocProvider.of<UserCartBloc>(context);

    return Scaffold(
      body: StreamBuilder(
          stream: FirebaseFirestore.instance.collection('products').snapshots(),
          builder: (context, snapshot) {
            final allProducts = snapshot.data?.docs ?? [];
            return Padding(
              padding: const EdgeInsets.all(9.0),
              child: GridView.builder(
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      crossAxisSpacing: 10.0,
                      mainAxisSpacing: 10.0,
                      childAspectRatio: 1 / 1.8),
                  itemCount: allProducts.length,
                  itemBuilder: (context, index) {
                    final productData = allProducts[index].data();
                    final productName = productData['product_name'];
                    final productPrice = productData['product_price'];
                    final productQuantity = productData['product_quantity'];
                    final productDesc = productData['product_desc'];
                    final productImages = productData['product_urls'] is List
                        ? List<String>.from(productData['product_urls'])
                        : (productData['product_urls'] is String
                            ? [productData['product_urls']]
                            : []);

                    return GestureDetector(
                      onTap: () {
                        context.pushNamed(MyAppRouteConstants.userProdDetails,
                            extra: productData);
                      },
                      child: Card(
                        elevation: 4,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Padding(
                          padding: EdgeInsets.all(20.0),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Expanded(
                                    child: Text(
                                      productName.toString().toUpperCase(),
                                      style: const TextStyle(fontSize: 19.0),
                                    ),
                                  ),
                                  Icon(Icons.favorite_outline),
                                ],
                              ),
                              const SizedBox(
                                height: 5.0,
                              ),
                              productImages.isNotEmpty
                                  ? AspectRatio(
                                      aspectRatio: 1,
                                      child: Image.network(productImages[0],
                                          fit: BoxFit.cover))
                                  : const Icon(
                                      Icons.image_not_supported_outlined),
                              const SizedBox(
                                height: 5.0,
                              ),
                              Text(
                                'Rs. $productPrice',
                                style: const TextStyle(fontSize: 19.0),
                              ),
                              const SizedBox(
                                height: 5.0,
                              ),
                              Text(
                                'Description: $productDesc',
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                              ),
                              const SizedBox(
                                height: 5.0,
                              ),
                              Text(
                                'Quantity. $productQuantity',
                              ),
                            ],
                          ),
                        ),
                      ),
                    );
                  }),
            );
          }),
    );
  }
}
