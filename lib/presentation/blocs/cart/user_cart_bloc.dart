import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:e_commerce_application/data/models/gloabl_product_model.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../../../data/models/user_cart_model.dart';

part 'user_cart_event.dart';
part 'user_cart_state.dart';

class UserCartBloc extends Bloc<UserCartEvent, UserCartState> {
  UserCartBloc() : super(UserCartStateInitial()) {
    on<UserCartButtonClicked>(userCartButtonClicked);
    on<UserCartQuantityIncreaseButtonClickedEvent>(
        userCartQuantityIncreaseButtonClickedEvent);
    on<UserCartQuantityDecrementButtonClickedEvent>(
        userCartQuantityDecrementButtonClickedEvent);
    on<UserCartDeletebuttonClickedEvent>(userCartDeletebuttonClickedEvent);
  }

  FutureOr<void> userCartButtonClicked(
      UserCartButtonClicked event, Emitter<UserCartState> emit) async {
    emit(UserCartAddLoadingState());
    try {
      final user = FirebaseAuth.instance.currentUser;

      CollectionReference userCartRef = FirebaseFirestore.instance
          .collection('users')
          .doc(user?.uid)
          .collection('userCart');
      await userCartRef.get();
      UserCartProductModel userCartProductModel = UserCartProductModel(
          productId: event.globalProductModel.productId,
          productName: event.globalProductModel.productName,
          quantity: 1,
          pricePerUnit: event.globalProductModel.productPrice,
          imageUrl: event.globalProductModel.productUrls);
      

      await userCartRef
          .where('product_id', isEqualTo: userCartProductModel.productId)
          .get();


      await userCartRef.doc(userCartProductModel.productId).set({
        'product_id': userCartProductModel.productId,
        'product_name': userCartProductModel.productName,
        'product_price_per_unit': userCartProductModel.pricePerUnit,
        'product_quantity': userCartProductModel.quantity,
        'product_urls': userCartProductModel.imageUrl,
      });
      print(event.globalProductModel.productDesc);
      emit(UserCartAddUploadSuccessState());
    } catch (e) {
      print(e.toString());
      UserCartAddUploadErrorState(errorMessage: e.toString());
    }
  }

  FutureOr<void> userCartQuantityIncreaseButtonClickedEvent(
      UserCartQuantityIncreaseButtonClickedEvent event,
      Emitter<UserCartState> emit) async {
    try {
      final user = FirebaseAuth.instance.currentUser;

      DocumentReference userCartDocRef = FirebaseFirestore.instance
          .collection('users')
          .doc(user!.uid)
          .collection('userCart')
          .doc(event.docId);
      final data = await userCartDocRef.get();
      if (data.exists) {
        final productData = data.data() as Map<String, dynamic>;
        final prodQuantity = productData['product_quantity'];
        userCartDocRef.update({'product_quantity': prodQuantity + 1});
      }

      print('event id is ${data.data()}');
    } catch (e) {}
  }

  FutureOr<void> userCartQuantityDecrementButtonClickedEvent(
      UserCartQuantityDecrementButtonClickedEvent event,
      Emitter<UserCartState> emit) async {
    try {
      final user = FirebaseAuth.instance.currentUser;

      DocumentReference userCartDocRef = FirebaseFirestore.instance
          .collection('users')
          .doc(user!.uid)
          .collection('userCart')
          .doc(event.docId);
      final data = await userCartDocRef.get();
      if (data.exists) {
        final productData = data.data() as Map<String, dynamic>;
        final prodQuantity = productData['product_quantity'];
        if (prodQuantity > 0) {
          userCartDocRef.update({'product_quantity': prodQuantity - 1});
        } else {
          emit(UserCartQuantityDecrementErrorState(
              errorMessage: 'Cart cannot be less than 0'));
        }
      }
    } catch (e) {
      emit(UserCartQuantityDecrementErrorState(errorMessage: e.toString()));
    }
  }

  FutureOr<void> userCartDeletebuttonClickedEvent(
      UserCartDeletebuttonClickedEvent event,
      Emitter<UserCartState> emit) async {
    emit(UserCartDeletionLoadingState());
    try {
      final user = FirebaseAuth.instance.currentUser;

      DocumentReference userCartDocRef = FirebaseFirestore.instance
          .collection('users')
          .doc(user!.uid)
          .collection('userCart')
          .doc(event.docId);
      await userCartDocRef.delete();
      emit(UserCartDeletionSuccessState());
    } catch (e) {
      emit(UserCartDeletionErrorState(errorMessage: e.toString()));
    }
  }
}
