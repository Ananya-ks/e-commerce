import 'dart:async';
import 'dart:io';

import 'package:bloc/bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

part 'user_profile_event.dart';
part 'user_profile_state.dart';

class UserProfileBloc extends Bloc<UserProfileEvent, UserProfileState> {
  final user = FirebaseAuth.instance.currentUser;

  UserProfileBloc() : super(UserProfileInitial()) {
    on<UserProfilePictureEditButtonClickEvent>(
        userProfilePictureEditButtonClickEvent);
    on<UserprofileNameEditButtonClickedEvent>(
        userprofileNameEditButtonClickedEvent);
    on<UserprofilePasswordEditButtonClickedEvent>(
        userprofilePasswordEditButtonClickedEvent);
  }

  FutureOr<void> userProfilePictureEditButtonClickEvent(
      UserProfilePictureEditButtonClickEvent event,
      Emitter<UserProfileState> emit) async {
    try {
      print('path is ${event.newImagePath}');
      final String image = event.newImagePath;
      final File file = File(image);
      final SupabaseClient supabaseClient = Supabase.instance.client;
      final String uniqueBatchId =
          DateTime.now().millisecondsSinceEpoch.toString();
      final fileName = 'profilePicture_${uniqueBatchId}.jpg';
      final filePath = 'profile-pic/$fileName';
      await supabaseClient.storage
          .from('display-picture')
          .upload(filePath, file);
      final imageurl =
          supabaseClient.storage.from('display-picture').getPublicUrl(filePath);
      FirebaseFirestore.instance
          .collection('users')
          .doc(user!.uid)
          .update({'photoUrl': imageurl});
    } catch (e) {
      print('error is ${e.toString()}');
    }
  }

  FutureOr<void> userprofileNameEditButtonClickedEvent(
      UserprofileNameEditButtonClickedEvent event,
      Emitter<UserProfileState> emit) {
    try {
      FirebaseFirestore.instance
          .collection('users')
          .doc(user!.uid)
          .update({'name': event.newUserName});
    } catch (e) {
      print('Error to update name is ${e.toString()}');
    }
  }

  FutureOr<void> userprofilePasswordEditButtonClickedEvent(
      UserprofilePasswordEditButtonClickedEvent event,
      Emitter<UserProfileState> emit) {
    try {
      FirebaseFirestore.instance
          .collection('users')
          .doc(user!.uid)
          .update({'password': event.newUserPassword});
    } catch (e) {
      print('Error to update name is ${e.toString()}');
    }
  }
}
