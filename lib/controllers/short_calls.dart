import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:provider/provider.dart';

import 'package:timeago/timeago.dart' as timeago;

import 'app_state.dart';

double height({required BuildContext context}) {
  return MediaQuery.of(context).size.height;
}

final User? user = FirebaseAuth.instance.currentUser;
double width({required BuildContext context}) {
  return MediaQuery.of(context).size.width;
}

goBack({required BuildContext context}) => Navigator.pop(context);
goTo(
        {required BuildContext context,
        required Widget child,
        bool forever = false}) =>
    !forever
        ? Navigator.push(
            context, MaterialPageRoute(builder: (context) => child))
        : Navigator.pushReplacement(
            context, MaterialPageRoute(builder: (context) => child));
Widget showProgress({double? thickness, Color? color}) =>
    CircularProgressIndicator(
      valueColor: AlwaysStoppedAnimation<Color>(color ?? Colors.blue),
      strokeWidth: thickness ?? 3,
    );

String getAgo({required int epoch}) =>
    timeago.format(DateTime.fromMillisecondsSinceEpoch(epoch));
AppState state({required BuildContext context, bool listen = false}) =>
    Provider.of<AppState>(context, listen: listen);
void showToast(
    {required String message,
    Color backgroundColor = Colors.grey,
    Color textColor = Colors.white}) {
  Fluttertoast.showToast(
      msg: message,
      toastLength: Toast.LENGTH_SHORT,
      gravity: ToastGravity.CENTER,
      timeInSecForIosWeb: 1,
      backgroundColor: backgroundColor,
      textColor: textColor,
      fontSize: 16.0);
}
