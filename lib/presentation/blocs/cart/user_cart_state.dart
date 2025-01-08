part of 'user_cart_bloc.dart';

sealed class UserCartState {}

final class UserCartStateInitial extends UserCartState {}

class UserCartAddLoadingState extends UserCartState {}

class UserCartAddUploadSuccessState extends UserCartState {}

class UserCartAddUploadErrorState extends UserCartState {
  String errorMessage;
  UserCartAddUploadErrorState({required this.errorMessage});
}

class UserCartQuantityDecrementErrorState extends UserCartState {
  String errorMessage;
  UserCartQuantityDecrementErrorState({required this.errorMessage});
}

class UserCartDeletionLoadingState extends UserCartState {}

class UserCartDeletionSuccessState extends UserCartState {}

class UserCartDeletionErrorState extends UserCartState {
  String errorMessage;
  UserCartDeletionErrorState({required this.errorMessage});
}

class UserCartTotalCheckOutAmt extends UserCartState {
  num totalCheckoutAmt;
  UserCartTotalCheckOutAmt({required this.totalCheckoutAmt});
}
