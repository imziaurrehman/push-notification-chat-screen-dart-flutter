import 'package:chat_with_push_notification/custom_methods.dart';
import 'package:chat_with_push_notification/push_notification/firebase_helper.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';

class UserAuth {
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  final CollectionReference _userFirebaseFirestore =
      FirebaseFirestore.instance.collection("user");
  final CustomMethods _customMethods = CustomMethods();
  final FirebaseHelper _firebaseHelper = FirebaseHelper();
  Future userRegisterationWithFirestoreDB(
      String username, String email, String password) async {
    // String userId = _firebaseAuth.currentUser!.uid;

    try {
      UserCredential userCredential = await _firebaseAuth
          .createUserWithEmailAndPassword(email: email, password: password);
      String userId = userCredential.user!.uid;
      await _userFirebaseFirestore.doc(userId).set({
        "userID": userId,
        "username": username,
        "email": email,
      }).then((_) => _firebaseHelper.storeTokenDB());
    } on FirebaseAuthException catch (error) {
      debugPrint("Error Occurred:\t$error");
      _customMethods.toast(text: "\t\t\tsomething happened:\n$error");
    }
  }

  Future userLogin(String email, String password) async {
    try {
      await _firebaseAuth.signInWithEmailAndPassword(
          email: email, password: password);
    } on FirebaseAuthException catch (error) {
      debugPrint("something happened:\t$error");
      _customMethods.toast(text: "\t\t\tsomething happened:\n$error");
    }
  }
}
