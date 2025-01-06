library admin_product_form_bloc;

import 'dart:async';
import 'dart:io';
import 'package:bloc/bloc.dart';
import '../../../data/models/admin_product_model.dart';
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
    on<AdminProductEditButtonClickEvent>(adminProductEditButtonClickEvent);
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
      DocumentReference docRef = await collRef.add({
        'product_name': event.productName,
        'product_price': event.productPrice,
        'product_quantity': event.productQuantity,
        'product_desc': event.productDescription,
        'product_urls': imageUrls,
        'created-at': FieldValue.serverTimestamp(),
      });
      await docRef.update({'product_id': docRef.id});
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

  FutureOr<void> adminProductEditButtonClickEvent(
      AdminProductEditButtonClickEvent event,
      Emitter<AdminProductFormState> emit) async {
    emit(AdminProductEditLoadingState());
    try {
      List<dynamic> updatedProductUrls = event.adminProductModel.productUrls;
      if (event.newProductImages.isNotEmpty) {
        await _deleteOldImageFromSupabase(event.adminProductModel.productUrls);
        updatedProductUrls = await _uploadNewImages(event.newProductImages);
      }
      //update firebase with edited product
      AdminProdcutModel updatedProductmodel = AdminProdcutModel(
        productDesc: event.adminProductModel.productDesc,
        productId: event.adminProductModel.productId,
        productName: event.adminProductModel.productName,
        productPrice: event.adminProductModel.productPrice,
        productQuantity: event.adminProductModel.productQuantity,
        productUrls: updatedProductUrls,
      );  
      await FirebaseFirestore.instance
          .collection('admin')
          .doc(adminEmail)
          .collection('product')
          .doc(event.adminProductModel.productId)
          .update(updatedProductmodel.toJson());
      emit(AdminProductEditSuccessState());
    } catch (e) {
      emit(AdminProductEditErrorState(errorMessage: e.toString()));
    }
  }

  _uploadNewImages(List newProductImages) async {
    try {
      List<String> newImageUrls = [];
      final SupabaseClient supabaseClient = Supabase.instance.client;
      final String uniqueBatchId =
          DateTime.now().millisecondsSinceEpoch.toString();
      for (int i = 0; i < newProductImages.length; i++) {
        final File image = newProductImages[i];
        final filename = 'image-${uniqueBatchId}_$i.jpg';
        final filepath = 'product-image/$filename';
        await supabaseClient.storage
            .from('product-image')
            .upload(filepath, image);
        final imageUrl =
            supabaseClient.storage.from('product-image').getPublicUrl(filepath);
        newImageUrls.add(imageUrl);
      }
      return newImageUrls;
    } catch (e) {
      print(e.toString());
    }
  }
}

_deleteOldImageFromSupabase(List productUrls) async {
  try {
    for (var url in productUrls) {
      final filepath =
          url.split('/storage/v1/object/public/product-image/').last;
      await Supabase.instance.client.storage
          .from('product-image')
          .remove([filepath]);
    }
  } catch (e) {}
}
