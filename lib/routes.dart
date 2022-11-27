import 'package:chat_with_push_notification/screens/chat/chat_screen.dart';
import 'package:chat_with_push_notification/screens/login/login_screen.dart';
import 'package:chat_with_push_notification/screens/registeration/registeration_screen.dart';
import 'package:flutter/material.dart';

final Map<String, WidgetBuilder> routes = {
  Login.screenID: (context) => const Login(),
  Registeration.screenID: (context) => const Registeration(),
  ChatScreen.screenID: (context) => ChatScreen(),
};
