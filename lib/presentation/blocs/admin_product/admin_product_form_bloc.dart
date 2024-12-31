import 'dart:async';
import 'dart:io';
import 'package:bloc/bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:meta/meta.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

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
      final SupabaseClient supabaseClient = Supabase.instance.client;

      List<String> imageUrls = [];
      for (File image in event.productImages) {
        final filename = '${DateTime.now().millisecondsSinceEpoch}.jpg';
        final filepath = 'product-image/$filename';
        await supabaseClient.storage
            .from('product-image')
            .upload(filepath, image);
        final imageUrl =
            supabaseClient.storage.from('product-image').getPublicUrl(filepath);
        imageUrls.add(imageUrl);

        CollectionReference collRef = FirebaseFirestore.instance
            .collection('admin')
            .doc(adminEmail)
            .collection('product');
        await collRef.add({
          'product_name': event.productName,
          'product_price': event.productPrice,
          'product_quantity': event.productQuantity,
          'product_desc': event.productDescription,
          'product_urls': imageUrls,
          'created-at': FieldValue.serverTimestamp(),
        });

        emit(AdminNewProductUploadSuccessState());
      }
    } catch (e) {
      emit(AdminNewProductUploadErrorState(errorMessage: e.toString()));
    }
  }
}
