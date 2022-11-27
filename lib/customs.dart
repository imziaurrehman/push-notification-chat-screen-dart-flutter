import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

ButtonStyle elevatedButtonStyle = ElevatedButton.styleFrom(
    backgroundColor: Colors.teal,
    padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 15),
    textStyle:
        const TextStyle(fontFamily: "assets/fonts/Montserrat-Medium.ttf"));
ButtonStyle customButtonStyle = ElevatedButton.styleFrom(
    backgroundColor: Colors.grey.shade200,
    padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 15),
    textStyle:
        const TextStyle(fontFamily: "assets/fonts/Montserrat-Medium.ttf"));
final FirebaseAuth authState = FirebaseAuth.instance;
