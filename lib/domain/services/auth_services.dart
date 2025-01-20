import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';

class AuthService {
  final _auth = FirebaseAuth.instance;
  final _firestore = FirebaseFirestore.instance;

  ///UserCredential -> an object that is returned after successful authentication

  ///_authenticate is a wrapper method. it is triggered when explicitly called in code
  Future<User?> _authenticate(
      Future<UserCredential> Function() authMethod) async {
    try {
      final credentials = await authMethod();

      /// .user -> creates user information returned bu authMethod
      return credentials.user;
    } on FirebaseAuthException catch (e) {
      throw e;
    } catch (e) {
      print("Unknown error: $e");
      rethrow;
    }
  }

  Future<User?> createUserWithEmailAndpassword(
      String email, String password) async {
    return _authenticate(() async {
      final credentials = await _auth.createUserWithEmailAndPassword(
          email: email, password: password);
      await _firestore
          .collection('users')
          .doc(credentials.user?.uid)
          .set({'email': email, 'password': password});
      return credentials;
    });
  }

  Future<User?> loginUserWithEmailAndpassword(
      String email, String password) async {
    return _authenticate(() =>
        _auth.signInWithEmailAndPassword(email: email, password: password));
  }

  Future<void> sendEmailVerificationLink() async {
    try {
      await _auth.currentUser?.sendEmailVerification();
    } catch (e) {
      print(e.toString());
    }
  }

  Future<void> signout() async {
    try {
      await _auth.signOut();
    } catch (e) {
      print('An error occured: $e');
    }
  }

  Future<UserCredential?> loginWithGoogle() async {
    try {
      await _auth.signOut();
      await GoogleSignIn().signOut();
      final googleUser = await GoogleSignIn().signIn();
      if (googleUser == null) {
        return null;
      }
      final googleAuth = await googleUser.authentication;
      final googleCred = GoogleAuthProvider.credential(
          idToken: googleAuth.idToken, accessToken: googleAuth.accessToken);

      print('googleUser $googleUser');
      print('signedinnnn');
      print(googleCred);
      final userCredential = await _auth.signInWithCredential(googleCred);
      final user = userCredential.user;
      if (user != null) {
        await _firestore.collection('users').doc(user.uid).set({
          'email': user.email,
          'name': user.displayName,
        }); 
      }
      return userCredential;
    } catch (e) {
      print('error occured ${e.toString()}');
    }
    return null;
  }
}
