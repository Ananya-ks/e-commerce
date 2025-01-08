import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:e_commerce_application/presentation/blocs/cart/user_cart_bloc.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fluttertoast/fluttertoast.dart';

class UserCart extends StatefulWidget {
  const UserCart({
    super.key,
  });

  @override
  State<UserCart> createState() => _UserCartState();
}

class _UserCartState extends State<UserCart> {
  @override
  Widget build(BuildContext context) {
    final userCartBloc = BlocProvider.of<UserCartBloc>(context);
    onIncrement(String docName) {
      userCartBloc
          .add(UserCartQuantityIncreaseButtonClickedEvent(docId: docName));
    }

    onDecrement(String docName) {
      userCartBloc
          .add(UserCartQuantityDecrementButtonClickedEvent(docId: docName));
    }

    removeFromCart(String docName) {
      userCartBloc.add(UserCartDeletebuttonClickedEvent(docId: docName));
    }

    final currentUser = FirebaseAuth.instance.currentUser;
    if (currentUser == null) {
      return Scaffold(
        appBar: AppBar(
          title: Text('Cart'),
        ),
        body: const Center(
          child: Text('Please login to view cart'),
        ),
      );
    }
    final userCartRef = FirebaseFirestore.instance
        .collection('users')
        .doc(currentUser.uid)
        .collection('userCart');
    return BlocConsumer<UserCartBloc, UserCartState>(
      bloc: userCartBloc,
      listener: (context, state) {
        if (state is UserCartDeletionSuccessState) {
          Fluttertoast.showToast(msg: 'Product removed from cart');
        } else if (state is UserCartQuantityDecrementErrorState) {
          Fluttertoast.showToast(msg: state.errorMessage);
        }
      },
      builder: (context, state) {
        num totalCheckoutAmt = 0;
        print('user cart state is $state');
        if (state is UserCartDeletionLoadingState) {
          const Center(
            child: CircularProgressIndicator(),
          );
        } else if (state is UserCartTotalCheckOutAmt) {
          totalCheckoutAmt = state.totalCheckoutAmt;
        }
        return Scaffold(
          appBar: AppBar(
            title: const Text('Cart'),
          ),
          body: StreamBuilder(
              stream: userCartRef.snapshots(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                }

                if (snapshot.hasError) {
                  return const Center(child: Text('Error fetching cart data.'));
                }

                if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                  return const Center(child: Text('Your cart is empty.'));
                }
                final cartProducts = snapshot.data!.docs;
                return ListView.builder(
                    itemCount: cartProducts.length,
                    itemBuilder: (context, index) {
                      final product = cartProducts[index];
                      final productData = product.data();
                      final prodQuantity = productData['product_quantity'];
                      final docName = product.id;
                      return Card(
                        child: Padding(
                          padding: const EdgeInsets.all(10.0),
                          child: Row(
                            children: [
                              Column(
                                children: [
                                  Image.network(
                                    productData['product_urls'][0],
                                    height: 100,
                                    width: 100,
                                    fit: BoxFit.cover,
                                  ),
                                ],
                              ),
                              const SizedBox(
                                width: 20,
                              ),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      productData['product_name']
                                          .toString()
                                          .toUpperCase(),
                                      style: TextStyle(fontSize: 20),
                                    ),
                                    Text(productData['product_price_per_unit']
                                        .toString()),
                                  ],
                                ),
                              ),
                              const SizedBox(
                                width: 20,
                              ),
                              Column(
                                children: [
                                  Padding(
                                    padding:
                                        const EdgeInsets.fromLTRB(70, 0, 0, 10),
                                    child: IconButton(
                                      onPressed: () => removeFromCart(docName),
                                      icon: const Icon(Icons.close),
                                      iconSize: 20.0,
                                    ),
                                  ),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.end,
                                    children: [
                                      Container(
                                        decoration: BoxDecoration(
                                            border:
                                                Border.all(color: Colors.brown),
                                            shape: BoxShape.circle),
                                        child: IconButton(
                                            onPressed: () =>
                                                onIncrement(docName),
                                            icon: const Icon(Icons.add)),
                                      ),
                                      const SizedBox(
                                        width: 10,
                                      ),
                                      Text(
                                        '$prodQuantity',
                                      ),
                                      const SizedBox(
                                        width: 10,
                                      ),
                                      Container(
                                        decoration: BoxDecoration(
                                            border:
                                                Border.all(color: Colors.brown),
                                            shape: BoxShape.circle),
                                        child: IconButton(
                                            onPressed: () {
                                              onDecrement(docName);
                                            },
                                            icon: const Icon(Icons.remove)),
                                      ),
                                    ],
                                  )
                                ],
                              ),
                            ],
                          ),
                        ),
                      );
                    });
              }),
          bottomNavigationBar: Container(
            color: Colors.grey.shade100,
            padding: const EdgeInsets.fromLTRB(0, 10, 10, 20),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Text(
                  '$totalCheckoutAmt',
                  style: TextStyle(fontSize: 20.0, fontWeight: FontWeight.w900),
                ),
                ElevatedButton(
                    onPressed: () {},
                    style: ButtonStyle(
                      fixedSize: WidgetStateProperty.all(Size(200, 50)),
                      backgroundColor:
                          WidgetStateProperty.all(Colors.brown.shade300),
                    ),
                    child: const Text(
                      'Checkout',
                      style: TextStyle(fontSize: 20, color: Colors.white),
                    )),
              ],
            ),
          ),
        );
      },
    );
  }
}
