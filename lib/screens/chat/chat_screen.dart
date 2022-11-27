import 'package:chat_with_push_notification/custom_methods.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../push_notification/firebase_helper.dart';
import '../../widgets/send_messages.dart';

class ChatScreen extends StatefulWidget {
  const ChatScreen({Key? key}) : super(key: key);
  static const screenID = "chat";

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final FirebaseAuth _authStateFirebase = FirebaseAuth.instance;
  @override
  void initState() {
    FirebaseHelper firebaseHelper = FirebaseHelper();
    firebaseHelper.setForegroundChannel();
    // FirebaseMessaging.onMessage.listen(firebaseHelper.showFlutterNotification);

    // TODO: implement initState
    super.initState();
  }

  final CollectionReference _messageRef =
      FirebaseFirestore.instance.collection("Messages");

  final String _currentUserId = FirebaseAuth.instance.currentUser!.uid;

  String? usrName;
  final formatter = DateFormat('yyyy-MM-dd hh:mm');

  @override
  Widget build(BuildContext context) {
    CustomMethods customMethods = CustomMethods();
    final size = MediaQuery.of(context).size;
    return GestureDetector(
        onTap: () => FocusManager.instance.primaryFocus!.unfocus(),
        child: Scaffold(
          appBar: AppBar(
            title: Text(
              "Push Notification Chat App\n\t\t\t\t${_authStateFirebase.currentUser?.email}",
              style: const TextStyle(color: Colors.black),
            ),
            backgroundColor: Colors.pink.shade400,
            actions: [
              InkWell(
                onTap: () async {
                  // SharedPreferences userSharedPrefs =
                  //     await SharedPreferences.getInstance();
                  await _authStateFirebase.signOut();
                  customMethods.toast(text: "user is signed out");
                  // userSharedPrefs.remove("username");
                },
                child: Image.asset(
                  "assets/imgs/logout2.png",
                  scale: 25.0,
                  color: Colors.pink.shade800,
                ),
              ),
            ],
          ),
          bottomSheet: const MessageSendingWidget(),
          body: SingleChildScrollView(
            child: Container(
                height: size.height * 1.0,
                width: double.infinity,
                // margin: const EdgeInsets.symmetric(vertical: 20),
                decoration: const BoxDecoration(
                    image: DecorationImage(
                        image: AssetImage("assets/imgs/chatbg.jpg"),
                        fit: BoxFit.cover,
                        opacity: 0.3)),
                child: StreamBuilder(
                  stream: _messageRef
                      // .where("user_id", isEqualTo: _currentUserId,)
                      .orderBy("created_at", descending: true)
                      .snapshots(),
                  builder: (context, snapshot) {
                    if (!snapshot.hasData) {
                      return Center(
                          child: Padding(
                        padding: const EdgeInsets.all(15.0),
                        child: Dialog(
                            alignment: Alignment.topCenter,
                            child: Column(
                              children: [
                                Image.asset(
                                  "assets/imgs/something_went_wrong.png",
                                ),
                                Padding(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 20),
                                  child: Container(
                                    padding: const EdgeInsets.only(
                                        left: 10,
                                        right: 10,
                                        top: 10,
                                        bottom: 10),
                                    decoration: BoxDecoration(
                                        color: Colors.grey.shade300,
                                        borderRadius:
                                            BorderRadius.circular(15)),
                                    child: Text(
                                      snapshot.error.toString(),
                                      textAlign: TextAlign.center,
                                    ),
                                  ),
                                ),
                              ],
                            )),
                      ));
                    } else if (snapshot.hasError) {
                      return Center(
                          child: SizedBox(
                        height: size.height * 0.6,
                        child: Dialog(
                            child: Image.asset(
                                "assets/imgs/something_went_wrong.png")),
                      ));
                    } else if (snapshot.connectionState ==
                        ConnectionState.waiting) {
                      return Center(
                        child: Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 20, vertical: 20),
                            decoration: BoxDecoration(
                                color: Colors.grey.shade300,
                                borderRadius: BorderRadius.circular(16)),
                            child: const CircularProgressIndicator()),
                      );
                    } else {
                      return SizedBox(
                        height: size.height * 1.0,
                        child: ListView.builder(
                          itemBuilder: (context, index) {
                            DocumentSnapshot data = snapshot.data!.docs[index];
                            usrName = data["username"] ?? "nothing";
                            // var timestamp =
                            //     snapshot.data!.docs[index]['created_at'];

                            return SingleChildScrollView(
                              child: Container(
                                margin: const EdgeInsets.only(
                                    top: 10, left: 10, right: 10),
                                child: data["user_id"] == _currentUserId
                                    ? customMethods.customContainer(
                                        text: data["message"],
                                        colors: Colors.pink.shade400,
                                        textColor: Colors.black,
                                        subTitle:
                                            formattedDate(data['created_at']),
                                        bottomLeftRadius: 16,
                                        bottomRightRadius: 30,
                                        topRightRadius: 0,
                                        topLeftRadius: 16,
                                        margin: EdgeInsets.only(
                                            left: size.width * 0.38))
                                    : customMethods.customContainer(
                                        text: data["message"],
                                        colors: Colors.grey.shade500,
                                        textColor: Colors.black,
                                        bottomRightRadius: 16,
                                        bottomLeftRadius: 25,
                                        topRightRadius: 16,
                                        topLeftRadius: 0,
                                        subTitle:
                                            formattedDate(data['created_at']),
                                        margin: EdgeInsets.only(
                                            right: size.width * 0.38)),
                              ),
                            );
                          },
                          itemCount: snapshot.data!.docs.length,
                          primary: true,
                          physics: const ScrollPhysics(),
                          padding: EdgeInsets.only(bottom: size.height * 0.2),
                          reverse: true,
                        ),
                      );
                    }
                  },
                )),
          ),
        ));
  }

  String formattedDate(timestamp) {
    // var dateFromTimeStamp =
    //     DateTime.fromMillisecondsSinceEpoch(timestamp.seconds * 1000);
    // return DateFormat('dd-MM-yyyy hh:mm a').format(dateFromTimeStamp);
    String date = DateFormat().format(DateTime.parse(timestamp));
    // var myDate = DateFormat('dd/MM/yyyy,hh:mm').format(date);

    return date;
  }
}
