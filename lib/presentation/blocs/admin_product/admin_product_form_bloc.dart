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
      // Get the product name from the event data
      var productName = event.dataList.isNotEmpty
          ? event.dataList.toList()[0]['product_name']
          : null;

      // Fetch the document snapshot from Firebase for the product
      final docSnapshot = await FirebaseFirestore.instance
          .collection('admin')
          .doc(adminEmail)
          .collection('product')
          .where('product_name', isEqualTo: productName)
          .get();

      if (docSnapshot.docs.isEmpty) {
        emit(AdminProductEditErrorState(errorMessage: "Product not found."));
        return;
      }

      final productDocRef = docSnapshot.docs.first.reference;
      final existingProductData = docSnapshot.docs.first.data();
      print('Existing product ${existingProductData}');
      // Get existing image URLs
      final existingImageUrls =
          List<String>.from(existingProductData['product_urls']);
      final newImageFiles = event.newProductImages;
      print('New images $newImageFiles');
      List<String> updatedImageUrls = existingImageUrls;

      if (newImageFiles.isNotEmpty) {
        // If new images are selected, delete old images from Supabase
        final supabaseStorage =
            Supabase.instance.client.storage.from('product-image');
        for (final imageUrl in existingImageUrls) {
          final pathSegments = Uri.parse(imageUrl).path.split('/');
          final filePath = pathSegments
              .skip(pathSegments.indexOf('product-image') + 1)
              .join('/');
          await supabaseStorage.remove([filePath]);
        }

        // Upload new images to Supabase
        updatedImageUrls = [];
        for (var i = 0; i < newImageFiles.length; i++) {
          final file = newImageFiles[i];
          final fileName =
              'image_${DateTime.now().millisecondsSinceEpoch}_$i.jpg';
          final filePath = 'product-image/$fileName';

          await supabaseStorage.upload(filePath, file);

          // Get public URL of the uploaded image
          final newImageUrl = supabaseStorage.getPublicUrl(filePath);
          updatedImageUrls.add(newImageUrl);
        }
      }

      // Update product in Firebase
      await productDocRef.update({
        'product_name': event.productName,
        'product_price': event.productPrice,
        'product_quantity': event.productQuantity,
        'product_desc': event.productDescription,
        'product_urls': updatedImageUrls, // Updated image URLs
        'created-at': FieldValue.serverTimestamp(),
      });

      emit(AdminProductEditSuccessState());
    } catch (e) {
      print("Error: $e");
      emit(AdminProductEditErrorState(errorMessage: e.toString()));
    }
  }
}
