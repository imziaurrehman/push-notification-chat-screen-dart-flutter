import 'package:chat_with_push_notification/push_notification/firebase_helper.dart';
import 'package:chat_with_push_notification/routes.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import 'screens/chat/chat_screen.dart';
import 'screens/login/login_screen.dart';

Future<void> firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  if (kDebugMode) {
    print("Handling a background message: ${message.messageId}");
    print('Message data: ${message.data}');
    print('Message notification: ${message.notification?.title}');
    print('Message notification: ${message.notification?.body}');
  }
  FirebaseHelper firebaseHelper = FirebaseHelper();
  firebaseHelper.showFlutterNotification(message);
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  FirebaseHelper firebaseHelper = FirebaseHelper();
  await firebaseHelper.setupFirebaseMsg();
  // firebaseHelper.setupFlutterNotifications();
  FirebaseMessaging.onBackgroundMessage(firebaseMessagingBackgroundHandler);
  firebaseHelper.fcmSubscribe();
  firebaseHelper.getToken();
  // firebaseHelper.showFlutterNotification;
  if (!kIsWeb) {
    await firebaseHelper.setupFlutterNotifications();
  }
  runApp(const MyApp());
  // It requests a registration token for sending messages to users from your App server or other trusted server environment.
  // String? token = await messaging.getToken();
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'single chat with push notification flutter',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
          primarySwatch: Colors.indigo,
          buttonTheme: const ButtonThemeData(
              textTheme: ButtonTextTheme.normal,
              buttonColor: Colors.amber,
              focusColor: Colors.orange,
              hoverColor: Colors.indigo,
              layoutBehavior: ButtonBarLayoutBehavior.padded,
              materialTapTargetSize: MaterialTapTargetSize.shrinkWrap),
          textTheme: const TextTheme(
            button: TextStyle(
                fontSize: 17,
                fontWeight: FontWeight.w500,
                color: Colors.teal,
                overflow: TextOverflow.ellipsis,
                fontStyle: FontStyle.normal,
                textBaseline: TextBaseline.alphabetic,
                decorationStyle: TextDecorationStyle.dotted,
                fontFamily: "assets/fonts/Montserrat-Medium.ttf"),
            caption: TextStyle(
              fontWeight: FontWeight.w500,
              fontSize: 18.0,
              color: Colors.black,
              fontFamily: "assets/fonts/Montserrat-Regular.ttf",
              overflow: TextOverflow.ellipsis,
              textBaseline: TextBaseline.alphabetic,
            ),
            headline1: TextStyle(
              fontWeight: FontWeight.w700,
              fontSize: 28.0,
              fontFamily: "assets/fonts/Montserrat-Bold.ttf",
              overflow: TextOverflow.ellipsis,
              textBaseline: TextBaseline.alphabetic,
            ),
          ),
          appBarTheme: AppBarTheme(
            elevation: 0.0,
            backgroundColor: Theme.of(context).scaffoldBackgroundColor,
            centerTitle: true,
            iconTheme: const IconThemeData(color: Colors.pink),
          )),
      // initialRoute: Login.screenID,
      home: StreamBuilder(
        stream: FirebaseAuth.instance.authStateChanges(),
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
      ),
      routes: routes,
    );
  }
}
