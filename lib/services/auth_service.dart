import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:yemekler_uygulamasi/ui/views/tab_sayfa.dart';

class AuthService {
  final userCollection = FirebaseFirestore.instance.collection("users");
  final firebaseAuth = FirebaseAuth.instance;

  static String? _savedEmail;

  /*
  static String removeSpecialCharacters(String email) {
    // @ işaretini ve . işaretini kaldır
    email = email.replaceAll('@', '').replaceAll('.', '');
    return email;
  }
   */

  static void saveEmail(String email) {
    _savedEmail = email;
  }

  static String? getSavedEmail() {
    return _savedEmail;
  }

  Future<void> signUp(BuildContext context,
      {required String name,
      required String email,
      required String password}) async {
    final navigator = Navigator.of(context);
    try {
      final UserCredential userCredential = await firebaseAuth
          .createUserWithEmailAndPassword(email: email, password: password);
      if (userCredential.user != null) {
        saveEmail(email);
        await _registerUser(name: name, email: email, password: password);
        navigator.pushReplacement(MaterialPageRoute(
          builder: (context) => const TabSayfa(),
        ));
      }
    } on FirebaseAuthException catch (e) {
      Fluttertoast.showToast(msg: e.message!, toastLength: Toast.LENGTH_LONG);
    }
  }

  Future<void> signIn(BuildContext context,
      {required String email, required String password}) async {
    final navigator = Navigator.of(context);
    try {
      final UserCredential userCredential = await firebaseAuth
          .signInWithEmailAndPassword(email: email, password: password);
      if (userCredential.user != null) {
        saveEmail(email);
        navigator.pushReplacement(MaterialPageRoute(
          builder: (context) => const TabSayfa(),
        ));
      }
    } on FirebaseAuthException catch (e) {
      Fluttertoast.showToast(msg: e.message!, toastLength: Toast.LENGTH_LONG);
    }
  }

  Future<void> _registerUser(
      {required String name,
      required String email,
      required String password}) async {
    await userCollection
        .doc()
        .set({"email": email, "name": name, "password": password});
    saveEmail(email);
  }
}
