import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../screens/chat/chat_screen.dart';
import '../screens/login/login_screen.dart';

class StreamScreensChangingStates extends StatelessWidget {
  StreamScreensChangingStates({Key? key}) : super(key: key);
  final FirebaseAuth authFirebase = FirebaseAuth.instance;
  final CollectionReference firebaseFirestoreUser =
      FirebaseFirestore.instance.collection("user");
  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: authFirebase.authStateChanges(),
      builder: (BuildContext context, AsyncSnapshot<User?> snapshot) {
        if (snapshot.hasData) {
          return ChatScreen();
        } else if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        } else if (snapshot.connectionState == ConnectionState.none ||
            snapshot.hasError) {
          return Text("something went wrong:\t${snapshot.error}");
        } else {
          return const Login();
        }
      },
    );
  }
}
