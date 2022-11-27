import 'package:chat_with_push_notification/custom_methods.dart';
import 'package:chat_with_push_notification/push_notification/firebase_helper.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:shared_preferences/shared_preferences.dart';

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
      SharedPreferences usernamePrefs = await SharedPreferences.getInstance();
      debugPrint("username::");
      debugPrint(usernamePrefs.getString("username").toString());
      usernamePrefs.setString("username", username);
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
    SharedPreferences namePrefs = await SharedPreferences.getInstance();

    try {
      await _firebaseAuth
          .signInWithEmailAndPassword(email: email, password: password)
          .whenComplete(() => namePrefs.getString("username"));
    } on FirebaseAuthException catch (error) {
      debugPrint("something happened:\t$error");
      _customMethods.toast(text: "\t\t\tsomething happened:\n$error");
    }
  }
}
