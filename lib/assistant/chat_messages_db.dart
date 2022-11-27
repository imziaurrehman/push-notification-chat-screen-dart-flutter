import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

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
    await _messageRef.doc(docId).set({
      "user_id": userId,
      "doc_id": docId,
      "message": message,
      "email": userInfo.email,
      "username": userName ?? "nothing",
      "created_at": DateTime.now().toString(),
    });
  }
}
