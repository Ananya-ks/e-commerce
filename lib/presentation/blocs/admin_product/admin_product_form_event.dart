part of 'admin_product_form_bloc.dart';

@immutable
sealed class AdminProductFormEvent {}

class AdminNewProductUploadButtonClickEvent extends AdminProductFormEvent {
  String productName;
  double productPrice;
  int productQuantity;
  String productDescription;

  AdminNewProductUploadButtonClickEvent({
    required this.productName,
    required this.productPrice,
    required this.productQuantity,
    required this.productDescription,
  });
}
