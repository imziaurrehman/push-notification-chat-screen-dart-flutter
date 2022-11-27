import 'package:chat_with_push_notification/screens/registeration/registeration_screen.dart';
import 'package:flutter/material.dart';

import '../../custom_methods.dart';
import '../../customs.dart';
import '../../firebase_auth/user_auth.dart';

class LoginTextFields extends StatefulWidget {
  const LoginTextFields({Key? key}) : super(key: key);

  @override
  State<LoginTextFields> createState() => _LoginTextFieldsState();
}

class _LoginTextFieldsState extends State<LoginTextFields> {
  bool isPasswordVisible = true;
  bool loginLoader = false;
  GlobalKey<FormState> key = GlobalKey<FormState>();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    final CustomMethods customMethods = CustomMethods();
    return Form(
      key: key,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
        child: SingleChildScrollView(
          child: Column(
            children: [
              TextFormField(
                controller: _emailController,
                decoration: InputDecoration(
                    label: const Text("Email"),
                    hintText: "Enter Email Address Here?",
                    hoverColor: Colors.orange,
                    prefixIcon: const Icon(Icons.alternate_email_outlined),
                    border: InputBorder.none,
                    suffixIcon: const Icon(Icons.email_outlined),
                    contentPadding: const EdgeInsets.symmetric(
                        horizontal: 15, vertical: 15),
                    filled: true,
                    fillColor: Colors.grey.shade200),
                validator: (value) => customMethods.validateEmail(value),
                textInputAction: TextInputAction.next,
                keyboardType: TextInputType.emailAddress,
              ),
              const SizedBox(
                height: 14,
              ),
              TextFormField(
                controller: _passwordController,
                decoration: InputDecoration(
                    label: const Text("Password"),
                    hintText: "Enter Password Here?",
                    hoverColor: Colors.orange,
                    prefixIcon: const Icon(Icons.lock_outline),
                    border: InputBorder.none,
                    suffixIcon: IconButton(
                        onPressed: () {
                          setState(() {
                            isPasswordVisible = !isPasswordVisible;
                          });
                        },
                        icon: isPasswordVisible
                            ? const Icon(Icons.visibility_off_outlined)
                            : const Icon(
                                Icons.visibility_outlined,
                                color: Colors.indigo,
                              )),
                    contentPadding: const EdgeInsets.symmetric(
                        horizontal: 15, vertical: 15),
                    filled: true,
                    fillColor: Colors.grey.shade200),
                obscureText: isPasswordVisible,
                validator: (value) {
                  if (value == null) {
                    return "please enter password?";
                  } else if (value.length < 4 || value.length > 8) {
                    return "invalid password?";
                  } else {
                    return null;
                  }
                },
                textInputAction: TextInputAction.done,
                keyboardType: TextInputType.visiblePassword,
              ),
              const SizedBox(
                height: 15,
              ),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () async {
                    if (!key.currentState!.validate()) {
                      return customMethods.toast(text: "something went wrong?");
                    }

                    UserAuth userAuth = UserAuth();
                    String email = _emailController.text;
                    String password = _passwordController.text;
                    customMethods.showLoaderDialog(context,
                        "loading process begins...\nwhile fetching user info please wait...");
                    // setState(() {
                    //   loginLoader = true;
                    // });
                    await userAuth.userLogin(email, password);
                    customMethods.toast(text: "user is logged in successfully");
                    // setState(() {
                    //   loginLoader = false;
                    // });
                    if (!mounted) return;
                    Navigator.pop(context);
                  },
                  style: elevatedButtonStyle,
                  child: loginLoader
                      ? const CircularProgressIndicator()
                      : Text(
                          "Login",
                          style: Theme.of(context).textTheme.caption,
                        ),
                ),
              ),
              const SizedBox(
                height: 15,
              ),
              OutlinedButton(
                onPressed: () {
                  Navigator.pushReplacementNamed(
                      context, Registeration.screenID);
                },
                child: Text(
                  "if user is not logged in then simply\nRegistered yourself here?",
                  textAlign: TextAlign.center,
                  style: Theme.of(context).textTheme.button,
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
