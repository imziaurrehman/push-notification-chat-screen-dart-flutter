import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ChatMessagesFirebase {
  final CollectionReference _messageRef =
      FirebaseFirestore.instance.collection("Messages");
  final FirebaseAuth _userAuth = FirebaseAuth.instance;
  Future addMessagesInDb(String message) async {
    String docId = _messageRef.doc().id;
    String userId = _userAuth.currentUser!.uid;
    User? userInfo = _userAuth.currentUser;
    String? userName = userInfo!.displayName;
    // if (userName == null || userName.isEmpty) return;
    SharedPreferences namePrefs = await SharedPreferences.getInstance();

    await _messageRef.doc(docId).set({
      "user_id": userId,
      "doc_id": docId,
      "message": message,
      "email": userInfo.email,
      "username": namePrefs.getString("username"),
      "created_at": DateTime.now().toString(),
    });
    if (kDebugMode) {
      print("${namePrefs.getString("username")}");
    }
  }
}
