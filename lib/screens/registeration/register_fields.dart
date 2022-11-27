import 'package:chat_with_push_notification/custom_methods.dart';
import 'package:chat_with_push_notification/firebase_auth/user_auth.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../customs.dart';

class RegisterationTextFields extends StatefulWidget {
  const RegisterationTextFields({Key? key}) : super(key: key);

  @override
  State<RegisterationTextFields> createState() =>
      _RegisterationTextFieldsState();
}

class _RegisterationTextFieldsState extends State<RegisterationTextFields> {
  bool isPasswordVisible = true;
  bool isUserDone = false;
  GlobalKey<FormState> key = GlobalKey<FormState>();
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    _usernameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final CustomMethods customMethods = CustomMethods();
    return SingleChildScrollView(
      child: Form(
        key: key,
        autovalidateMode: AutovalidateMode.always,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
          child: Column(
            children: [
              TextFormField(
                controller: _usernameController,
                decoration: InputDecoration(
                    label: const Text("UserName"),
                    hintText: "Enter username Here?",
                    hoverColor: Colors.orange,
                    prefixIcon: const Icon(Icons.person_outline),
                    border: InputBorder.none,
                    suffixIcon: const Icon(Icons.person_add_alt),
                    contentPadding: const EdgeInsets.symmetric(
                        horizontal: 15, vertical: 15),
                    filled: true,
                    fillColor: Colors.grey.shade200),
                validator: (value) {
                  if (value == null) {
                    return "please enter user name?";
                  } else if (value.length < 3) {
                    return "user name is too short?";
                  } else {
                    return null;
                  }
                },
                textInputAction: TextInputAction.next,
                keyboardType: TextInputType.name,
              ),
              const SizedBox(
                height: 14,
              ),
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
                      return customMethods.toast(
                          text: "wrong/invalid user info please try again?");
                    }
                    UserAuth userAuth = UserAuth();
                    String username = _usernameController.text;
                    String email = _emailController.text;
                    String password = _passwordController.text;
                    customMethods.showLoaderDialog(context,
                        "storing process begins...\nwhile creating user info please wait...");
                    setState(() {
                      isUserDone = true;
                    });
                    await userAuth.userRegisterationWithFirestoreDB(
                        username, email, password);
                    customMethods.toast(
                        text: "user is registered successfully");
                    setState(() {
                      isUserDone = false;
                    });
                    if (!mounted) return;
                    Navigator.pop(context);
                    SharedPreferences userSharedPrefs =
                        await SharedPreferences.getInstance();
                    userSharedPrefs.setString("username", username);
                  },
                  style: elevatedButtonStyle,
                  child: isUserDone
                      ? const CircularProgressIndicator()
                      : Text(
                          "Register Now",
                          style: Theme.of(context).textTheme.caption,
                        ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
