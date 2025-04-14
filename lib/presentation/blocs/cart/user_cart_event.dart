part of 'user_cart_bloc.dart';

sealed class UserCartEvent {}

class UserAddToCartButtonClicked extends UserCartEvent {
  final GlobalProductModel globalProductModel;

  UserAddToCartButtonClicked({required this.globalProductModel});
}

class UserCartQuantityIncreaseButtonClickedEvent extends UserCartEvent {
  final String docId;

  UserCartQuantityIncreaseButtonClickedEvent({required this.docId});
}

class UserCartQuantityDecrementButtonClickedEvent extends UserCartEvent {
  final String docId;

  UserCartQuantityDecrementButtonClickedEvent({required this.docId});
}

class UserCartDeletebuttonClickedEvent extends UserCartEvent {
  final String docId;

  UserCartDeletebuttonClickedEvent({required this.docId});
}

class UserCartPageClickedEvent extends UserCartEvent {}
