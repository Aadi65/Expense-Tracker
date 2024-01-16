import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:com_cipherschools_assignment/utils/functions.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:com_cipherschools_assignment/models/user.dart' as models;
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:shared_preferences/shared_preferences.dart';

class FirebaseMethods {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firebaseFirestore = FirebaseFirestore.instance;

  Stream<User?> get authStateChange => _auth.idTokenChanges();
  Future<User?> signInWithEmailPassword({
    required String email,
    required String password,
    required BuildContext context,
  }) async {
    try {
      final result = await _auth.signInWithEmailAndPassword(
          email: email, password: password);
      return result.user;
    } on FirebaseAuthException catch (e) {
      showSnackBar(context, e.message!);
    }
    return null;
  }

  Future<void> signOut() async {
    await _auth.signOut();
  }

  Future<void> signUpWithEmailPassword({
    required BuildContext context,
    required String email,
    required String password,
    required String name,
  }) async {
    try {
      UserCredential userCredential = await _auth
          .createUserWithEmailAndPassword(email: email, password: password);
      if (userCredential.user != null) {
        final prefs = await SharedPreferences.getInstance();
        prefs.setString('id', userCredential.user!.uid);
        models.User user = models.User(
          email: email,
          name: name,
          uid: userCredential.user!.uid,
        );
        await _firebaseFirestore
            .collection('users')
            .doc(userCredential.user!.uid)
            .set(user.toJson());
      }
    } on FirebaseAuthException catch (e) {
      showSnackBar(context, e.message!);
    }
  }

  Future<void> signInWithGoogle(
    BuildContext context,
  ) async {
    try {
      //both signUp and signIn process is same for google authentication
      final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();
      final GoogleSignInAuthentication? googleAuth =
          await googleUser?.authentication;
      if (googleAuth?.accessToken != null && googleAuth?.idToken != null) {
        final credential = GoogleAuthProvider.credential(
            accessToken: googleAuth?.accessToken, idToken: googleAuth?.idToken);
        UserCredential userCredential =
            await _auth.signInWithCredential(credential);
        if (userCredential.user != null) {
          if (userCredential.additionalUserInfo!.isNewUser) {
            models.User user = models.User(
              email: userCredential.user!.email!,
              name: '',
              uid: userCredential.user!.uid,
            );
            await _firebaseFirestore
                .collection('users')
                .doc(userCredential.user!.uid)
                .set(user.toJson());
          }
        }
      }
    } on FirebaseAuthException catch (e) {
      showSnackBar(context, e.message!);
    }
  }

  Future<models.User> getUserDetails(String uid) async {
    DocumentSnapshot snap =
        await _firebaseFirestore.collection('users').doc(uid).get();
    return models.User.fromSnap(snap);
  }
}

class AuthException implements Exception {
  final String message;
  AuthException(this.message);
  @override
  String toString() {
    return message;
  }
}
