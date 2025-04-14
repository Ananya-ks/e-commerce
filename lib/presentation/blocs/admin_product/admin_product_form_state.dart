part of 'admin_product_form_bloc.dart';

@immutable
sealed class AdminProductFormState {}

final class AdminProductFormInitial extends AdminProductFormState {}

class AdminNewProductUploadLoadingState extends AdminProductFormState {}

class AdminNewProductUploadSuccessState extends AdminProductFormState {}

// ignore: must_be_immutable
class AdminNewProductUploadErrorState extends AdminProductFormState {
  String errorMessage;
  AdminNewProductUploadErrorState({required this.errorMessage});
}

class AdminProductDeleteLoadingState extends AdminProductFormState {}

class AdminProductDeleteSuccessState extends AdminProductFormState {}

// ignore: must_be_immutable
class AdminProductDeleteErrorState extends AdminProductFormState {
  String errorMessage;
  AdminProductDeleteErrorState({required this.errorMessage});
}

class AdminProductEditLoadingState extends AdminProductFormState {}

class AdminProductEditSuccessState extends AdminProductFormState {}

// ignore: must_be_immutable
class AdminProductEditErrorState extends AdminProductFormState {
  String errorMessage;
  AdminProductEditErrorState({required this.errorMessage});
}
