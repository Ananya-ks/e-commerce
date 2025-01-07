import 'package:carousel_slider/carousel_slider.dart';
import 'package:e_commerce_application/data/models/gloabl_product_model.dart';
import 'package:e_commerce_application/routes/app_route_const.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:go_router/go_router.dart';

import '../../blocs/cart/user_cart_bloc.dart';

class UserProductDetailsPage extends StatefulWidget {
  final Map<String, dynamic> product;
  const UserProductDetailsPage({super.key, required this.product});

  @override
  State<UserProductDetailsPage> createState() => _UserProductDetailsPageState();
}

class _UserProductDetailsPageState extends State<UserProductDetailsPage> {
  @override
  Widget build(BuildContext context) {
    final productUrlLength = widget.product['product_urls'].length;
    UserCartBloc userCartBloc = UserCartBloc();
    return BlocConsumer<UserCartBloc, UserCartState>(
      bloc: userCartBloc,
      listener: (context, state) {
        if (state is UserCartAddUploadSuccessState) {
          Fluttertoast.showToast(msg: 'Product added to cart');
          context.pushNamed(MyAppRouteConstants.userLandingPage);
        } else if (state is UserCartAddUploadErrorState) {
          Fluttertoast.showToast(msg: state.errorMessage);
        }
      },
      builder: (context, state) {
        return Scaffold(
            appBar: AppBar(
              title: Text('${widget.product['product_name']}'),
            ),
            body: Column(
              children: [
                Container(
                    padding: EdgeInsets.all(20),
                    decoration:
                        BoxDecoration(borderRadius: BorderRadius.circular(5)),
                    child: CarouselSlider(
                        items: List.generate(
                            productUrlLength,
                            (i) => Image.network(
                                  widget.product['product_urls'][i],
                                  fit: BoxFit.cover,
                                  height: 500,
                                  width: 500,
                                )),
                        options: CarouselOptions(
                            height: 300,
                            enableInfiniteScroll: false,
                            autoPlay: true,
                            enlargeCenterPage: true,
                            viewportFraction: 0.9))),
                Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: Text(
                    '${widget.product['product_desc']}',
                    textAlign: TextAlign.justify,
                  ),
                ),
              ],
            ),
            bottomNavigationBar: Container(
              color: Colors.grey.shade100,
              child: Padding(
                padding: const EdgeInsets.all(10),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    Text(
                      'Rs. ${widget.product['product_price']}',
                      style: const TextStyle(color: Colors.brown, fontSize: 30),
                    ),
                    ElevatedButton(
                      onPressed: () {
                        final globalProductModel =
                            GlobalProductModel.fromJson(widget.product);
                        userCartBloc.add(UserCartButtonClicked(
                            globalProductModel: globalProductModel));
                      },
                      style: ButtonStyle(
                          fixedSize: WidgetStateProperty.all(Size(200, 50)),
                          backgroundColor:
                              WidgetStateProperty.all(Colors.grey)),
                      child: Text(
                        'Add to cart',
                        style: TextStyle(
                            fontSize: 20, color: Colors.brown.shade900),
                      ),
                    )
                  ],
                ),
              ),
            ));
      },
    );
  }
}
