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
