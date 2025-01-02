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
    on<AdminProductDeleteButtonClickEvent>(adminProductDeleteButtonClickEvent);
    on<AdminNewProductEditButtonClickEvent>(adminNewProductEditButtonClickEvent);
  }

  FutureOr<void> adminNewProductUploadButtonClickEvent(
      AdminNewProductUploadButtonClickEvent event,
      Emitter<AdminProductFormState> emit) async {
    emit(AdminNewProductUploadLoadingState());
    try {
      final SupabaseClient supabaseClient = Supabase.instance.client;
      final String uniqueBatchId =
          DateTime.now().millisecondsSinceEpoch.toString();
      List<String> imageUrls = [];
      for (int i = 0; i < event.productImages.length; i++) {
        final File image = event.productImages[i];
        final filename = 'image_${uniqueBatchId}_$i.jpg';
        final filepath = 'product-image/$filename';
        await supabaseClient.storage
            .from('product-image')
            .upload(filepath, image);
        final imageUrl =
            supabaseClient.storage.from('product-image').getPublicUrl(filepath);
        imageUrls.add(imageUrl);
      }
      CollectionReference collRef = FirebaseFirestore.instance
          .collection('admin')
          .doc(adminEmail)
          .collection('product');
      await collRef.doc(event.productName).set({
        'product_name': event.productName,
        'product_price': event.productPrice,
        'product_quantity': event.productQuantity,
        'product_desc': event.productDescription,
        'product_urls': imageUrls,
        'created-at': FieldValue.serverTimestamp(),
      });
      emit(AdminNewProductUploadSuccessState());
    } catch (e) {
      emit(AdminNewProductUploadErrorState(errorMessage: e.toString()));
    }
  }

  FutureOr<void> adminProductDeleteButtonClickEvent(
      AdminProductDeleteButtonClickEvent event,
      Emitter<AdminProductFormState> emit) async {
    emit(AdminProductDeleteLoadingState());
    try {
      final productCollection = await FirebaseFirestore.instance
          .collection('admin')
          .doc(adminEmail)
          .collection('product')
          .where('product_name', isEqualTo: event.productName)
          .get();

      List<String> productUrls = [];
      for (var doc in productCollection.docs) {
        final data = doc.data();
        if (data.containsKey('product_urls')) {
          List<dynamic> imageUrls = doc['product_urls'];
          productUrls.addAll(imageUrls.map((url) => url.toString()));
        }
        await doc.reference.delete();
      }
      for (String url in productUrls) {
        await deleteImageFromSupabase(url);
      }
      emit(AdminProductDeleteSuccessState());
    } catch (e) {
      emit(AdminProductDeleteErrorState(errorMessage: e.toString()));
    }
  }

  deleteImageFromSupabase(String url) async {
    try {
      final SupabaseClient supabaseClient = Supabase.instance.client;
      final path = Uri.parse(url)
          .path
          .split('/storage/v1/object/public/product-image/')
          .last;
      print('path is $path');
      await supabaseClient.storage.from('product-image').remove([path]);
      print('deleted');
    } catch (e) {
      print(e.toString());
    }
  }

  FutureOr<void> adminNewProductEditButtonClickEvent(AdminNewProductEditButtonClickEvent event, Emitter<AdminProductFormState> emit) {
    print(event.dataList);
  }
}
