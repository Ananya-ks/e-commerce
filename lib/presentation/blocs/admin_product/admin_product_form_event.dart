part of 'admin_product_form_bloc.dart';

@immutable
sealed class AdminProductFormEvent {}

// ignore: must_be_immutable
class AdminNewProductUploadButtonClickEvent extends AdminProductFormEvent {
  String productName;
  double productPrice;
  int productQuantity;
  List<File> productImages;
  String productDescription;

  AdminNewProductUploadButtonClickEvent({
    required this.productName,
    required this.productPrice,
    required this.productQuantity,
    required this.productImages,
    required this.productDescription,
  });
}

// ignore: must_be_immutable
class AdminProductDeleteButtonClickEvent extends AdminProductFormEvent {
  String productName;
  AdminProductDeleteButtonClickEvent({required this.productName});
}

// ignore: must_be_immutable
class AdminNewProductEditButtonClickEvent extends AdminProductFormEvent {
  Iterable<Map<String, dynamic>> dataList;
  AdminNewProductEditButtonClickEvent({required this.dataList});
}
