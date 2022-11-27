import 'package:flutter/material.dart';

import 'login_fields.dart';

class Login extends StatelessWidget {
  const Login({Key? key}) : super(key: key);
  static const screenID = "login";
  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return GestureDetector(
      onTap: () => FocusManager.instance.primaryFocus!.unfocus(),
      child: Scaffold(
        body: Container(
          height: size.height * 1.0,
          decoration: const BoxDecoration(
              image: DecorationImage(
                  image: AssetImage("assets/imgs/primaryBg.png"),
                  fit: BoxFit.cover)),
          child: SafeArea(
            child: ListView(
              children: [
                SizedBox(
                  height: size.height * 0.1,
                ),
                // Text(
                //   "Login",
                //   style: Theme.of(context).textTheme.headline1,
                // ),
                Image.asset(
                  "assets/imgs/chat5.png",
                  height: size.height * 0.18,
                ),
                Image.asset(
                  "assets/imgs/logingif.gif",
                  height: size.height * 0.145,
                ),

                SizedBox(
                  height: size.height * 0.06,
                ),
                const LoginTextFields(),
                const SizedBox(
                  height: 20,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
