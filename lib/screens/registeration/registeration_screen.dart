import 'package:chat_with_push_notification/screens/login/login_screen.dart';
import 'package:chat_with_push_notification/screens/registeration/register_fields.dart';
import 'package:flutter/material.dart';

class Registeration extends StatelessWidget {
  const Registeration({Key? key}) : super(key: key);
  static const screenID = "registeration";
  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return GestureDetector(
      onTap: () => FocusManager.instance.primaryFocus!.unfocus(),
      child: Scaffold(
        body: Container(
          height: size.height * 1.0,
          width: double.infinity,
          decoration: const BoxDecoration(
              image: DecorationImage(
                  image: AssetImage("assets/imgs/primaryBg.png"),
                  fit: BoxFit.cover)),
          child: SafeArea(
              child: ListView(
            children: [
              IconButton(
                onPressed: () =>
                    Navigator.pushReplacementNamed(context, Login.screenID),
                padding: EdgeInsets.only(right: size.width * 0.85, top: 20),
                focusColor: Colors.amber,
                autofocus: true,
                hoverColor: Colors.green,
                icon: Icon(
                  Icons.arrow_back_ios_outlined,
                  color: Colors.indigo.shade600,
                ),
              ),
              SizedBox(
                height: size.height * 0.08,
              ),
              // Image.asset(
              //   "assets/imgs/chat5.png",
              //   height: size.height * 0.15,
              // ),
              Image.asset(
                "assets/imgs/reg_img.png",
                height: size.height * 0.2,
              ),
              Image.asset(
                "assets/imgs/register_now2.png",
                height: size.height * 0.15,
              ),

              SizedBox(
                height: size.height * 0.06,
              ),
              const RegisterationTextFields(),
            ],
          )),
        ),
      ),
    );
  }
}
