import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

class CustomMethods {
  void toast({required String text}) {
    Fluttertoast.showToast(
        msg: text,
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
        timeInSecForIosWeb: 1,
        backgroundColor: Colors.grey.shade500,
        textColor: Colors.white,
        fontSize: 16.5);
  }

  String? validateEmail(String? value) {
    String pattern =
        r"^[a-zA-Z0-9.!#$%&'*+/=?^_`{|}~-]+@[a-zA-Z0-9](?:[a-zA-Z0-9-]"
        r"{0,253}[a-zA-Z0-9])?(?:\.[a-zA-Z0-9](?:[a-zA-Z0-9-]"
        r"{0,253}[a-zA-Z0-9])?)*$";
    RegExp regex = RegExp(pattern);
    if (value == null ||
        value.isEmpty ||
        !regex.hasMatch(value) ||
        !value.contains("@gmail.com")) {
      return 'Enter a valid email address';
    } else {
      return null;
    }
  }

  showLoaderDialog(BuildContext context, String text) {
    Dialog alert = Dialog(
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Row(
          children: [
            const CircularProgressIndicator(),
            const SizedBox(
              width: 6,
            ),
            Text(
              text,
              textAlign: TextAlign.center,
              overflow: TextOverflow.ellipsis,
            ),
          ],
        ),
      ),
    );
    showDialog(
      barrierDismissible: false,
      context: context,
      builder: (BuildContext context) {
        return alert;
      },
    );
  }

  //for message ui
  Container customContainer({
    var text,
    required Color colors,
    required Color textColor,
    required EdgeInsets margin,
    required String subTitle,
    required double bottomLeftRadius,
    required double bottomRightRadius,
    required double topLeftRadius,
    required double topRightRadius,
    Widget? leadingWidget,
  }) {
    return Container(
      width: 220,
      height: 80,
      margin: margin,
      decoration: BoxDecoration(
        color: colors,
        borderRadius: BorderRadius.only(
            topLeft: Radius.circular(topLeftRadius),
            bottomLeft: Radius.circular(bottomLeftRadius),
            bottomRight: Radius.circular(bottomRightRadius),
            topRight: Radius.circular(topRightRadius)),
      ),
      child: ListTile(
        trailing: Chip(
          label: leadingWidget!,
        ),
        subtitle: Text(
          subTitle,
          style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w400),
        ),
        title: Text(
          text,
          // maxLines: 3,
          style: TextStyle(color: textColor, fontWeight: FontWeight.w500),
        ),
      ),
    );
  }
}
