import 'package:chat_with_push_notification/assistant/chat_messages_db.dart';
import 'package:chat_with_push_notification/custom_methods.dart';
import 'package:chat_with_push_notification/push_notification/api.dart';
import 'package:chat_with_push_notification/push_notification/firebase_helper.dart';
// import 'package:chat_with_push_notification/push_notification/firebase_helper.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:quickalert/quickalert.dart';

class MessageSendingWidget extends StatefulWidget {
  const MessageSendingWidget({Key? key}) : super(key: key);

  @override
  State<MessageSendingWidget> createState() => _MessageSendingWidgetState();
}

class _MessageSendingWidgetState extends State<MessageSendingWidget> {
  final TextEditingController _messagesController = TextEditingController();
  final CollectionReference _userRefForTokens =
      FirebaseFirestore.instance.collection("user");
  @override
  void dispose() {
    // TODO: implement dispose
    FirebaseHelper firebaseHelper = FirebaseHelper();
    // firebaseHelper.listenFcm();
    super.dispose();
    _messagesController.dispose();
  }

  List<dynamic> totalTokensFromDB = [];
  String tokenValue = "";
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _userRefForTokens.get().then((value) {
      for (var element in value.docs) {
        tokenValue = element["token"];
        totalTokensFromDB.add(element["token"]);
        debugPrint("get tokens from db::$totalTokensFromDB");
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Row(
      children: [
        Container(
          margin: const EdgeInsets.only(left: 40, top: 30),
          padding: const EdgeInsets.symmetric(vertical: 10.5, horizontal: 10),
          width: size.width * 0.65,
          height: size.height * 0.2 / 1.66,
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(18.0),
              color: Colors.grey.shade300),
          child: TextField(
            controller: _messagesController,
            decoration: InputDecoration(
                // label: const Text("Message"),
                hintText: "Enter Message Here?",
                hoverColor: Colors.orange,
                prefixIcon: const Icon(Icons.message_outlined),
                border: InputBorder.none,

                // contentPadding:
                //     const EdgeInsets.symmetric(horizontal: 0, vertical: 0),
                filled: true,
                fillColor: Colors.grey.shade200),
            textInputAction: TextInputAction.next,
            keyboardType: TextInputType.name,
            maxLength: 55,
          ),
        ),
        const SizedBox(
          width: 10,
        ),
        ElevatedButton(
          onPressed: () async {
            ChatMessagesFirebase chat = ChatMessagesFirebase();
            CustomMethods customMethods = CustomMethods();
            // FirebaseHelper firebaseHelper = FirebaseHelper();
            Api apiFcm = Api();
            String message = _messagesController.text;
            if (message.isEmpty) {
              QuickAlert.show(
                  context: context,
                  type: QuickAlertType.warning,
                  title: "field is empty..",
                  text: "make sure field is not empty..");
              customMethods.toast(text: "field is empty?");
              return;
            }
            await chat.addMessagesInDb(message);
            FocusManager.instance.primaryFocus!.unfocus();

            apiFcm.sendFcm("title", message, totalTokensFromDB);
            QuickAlert.show(
                context: context,
                type: QuickAlertType.success,
                title: "Message is sent..",
                text: "you have sent message to other users..");
            customMethods.toast(text: "message is sent");
            _messagesController.text = "";
          },
          style: ElevatedButton.styleFrom(
              backgroundColor: Colors.grey.shade300,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(14)),
              fixedSize: const Size.fromRadius(30)),
          child: Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 10),
            margin: const EdgeInsets.only(right: 0),
            decoration: BoxDecoration(
                color: Colors.grey.shade300,
                borderRadius: BorderRadius.circular(16)),
            child: Icon(
              Icons.send_outlined,
              color: Colors.pink.shade500,
              size: 28.0,
            ),
          ),
        ),
      ],
    );
  }
}
