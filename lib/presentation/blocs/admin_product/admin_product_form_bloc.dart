import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:meta/meta.dart';


part 'admin_product_form_event.dart';
part 'admin_product_form_state.dart';

class AdminProductFormBloc
    extends Bloc<AdminProductFormEvent, AdminProductFormState> {
  final FirebaseFirestore firestore;
  final String adminEmail;

  AdminProductFormBloc({required this.firestore, required this.adminEmail})
      : super(AdminProductFormInitial()) {
    on<AdminNewProductUploadButtonClickEvent>(
        adminNewProductUploadButtonClickEvent);
  }

  FutureOr<void> adminNewProductUploadButtonClickEvent(
      AdminNewProductUploadButtonClickEvent event,
      Emitter<AdminProductFormState> emit) async {
    emit(AdminNewProductUploadLoadingState());
    try {
      CollectionReference collRef = await FirebaseFirestore.instance
          .collection('admin')
          .doc(adminEmail)
          .collection('product');
      collRef.add({
        'product_name': event.productName,
        'product_price': event.productPrice,
        'product_quantity': event.productQuantity,
        'product_desc': event.productDescription,
        'created-at': FieldValue.serverTimestamp(),
      });
      emit(AdminNewProductUploadSuccessState());
    } catch (e) {
      emit(AdminNewProductUploadErrorState(errorMessage: e.toString()));
    }
  }
}
