part of 'user_profile_bloc.dart';

sealed class UserProfileEvent {}

class UserProfilePictureEditButtonClickEvent extends UserProfileEvent {
  String newImagePath;
  UserProfilePictureEditButtonClickEvent({required this.newImagePath});
}

class UserprofileNameEditButtonClickedEvent extends UserProfileEvent {
  String newUserName;
  UserprofileNameEditButtonClickedEvent({required this.newUserName});
}

class UserprofilePasswordEditButtonClickedEvent extends UserProfileEvent {
  String newUserPassword;
  UserprofilePasswordEditButtonClickedEvent({required this.newUserPassword});
}
