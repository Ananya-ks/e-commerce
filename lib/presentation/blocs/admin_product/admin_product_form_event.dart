part of 'admin_product_form_bloc.dart';

@immutable
abstract class AdminProductFormEvent {}

// ignore: must_be_immutable
class AdminNewProductUploadButtonClickEvent extends AdminProductFormEvent {
  String productName;
  double productPrice;
  int productQuantity;
  List<File> productImages;
  String productId;
  String productDescription;

  AdminNewProductUploadButtonClickEvent({
    required this.productName,
    required this.productPrice,
    required this.productQuantity,
    required this.productImages,
    required this.productId,
    required this.productDescription,
  });
}

// ignore: must_be_immutable
class AdminProductDeleteButtonClickEvent extends AdminProductFormEvent {
  String productName;
  AdminProductDeleteButtonClickEvent({required this.productName});
}

// ignore: must_be_immutable
// class AdminProductEditButtonClickEvent extends AdminProductFormEvent {
//   Iterable<Map<String, dynamic>> dataList;
//   String productName;
//   double productPrice;
//   int productQuantity;
//   List<dynamic> productImages;
//   List<File> newProductImages;
//   String productDescription;
//   AdminProductEditButtonClickEvent(
//       {required this.dataList,
//       required this.productName,
//       required this.productPrice,
//       required this.productQuantity,
//       required this.productImages,
//       required this.newProductImages,
//       required this.productDescription});
// }

class AdminProductEditButtonClickEvent extends AdminProductFormEvent {
  final AdminProdcutModel adminProductModel;
  final List<File> newProductImages;

  AdminProductEditButtonClickEvent(
      {required this.adminProductModel, required this.newProductImages});
}
