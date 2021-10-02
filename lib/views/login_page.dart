import 'package:chat/controllers/short_calls.dart';
import 'package:chat/models/user_model.dart';
import 'package:chat/views/home.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../main.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  bool _loading = false;
  void _upateLoadingStatus() {
    if (mounted) {
      setState(() {
        _loading = !_loading;
      });
    }
  }

 

  Future<void> _handleAuth() async {
    final snapshot = await FirebaseFirestore.instance
        .collection('testusers')
        .doc(user?.uid)
        .get();
    if (snapshot.exists) {
      // just navigate user to homepage without saving any data
      goTo(context: context, child: const HomePage(), forever: true);
    } else {
      // new user, the data has to be pushed
       UserModel _user = UserModel(
          userName: user?.displayName,
          userEmail: user?.email,
          userId: user?.uid,
          created: DateTime.now().millisecondsSinceEpoch.toString(),
          userProfilePhoto: user?.photoURL);
      fireData.saveUser(user: _user).then((value) =>
          goTo(context: context, child: const HomePage(), forever: true));
    }
  }

  Future<void> _signIn() async {
    _upateLoadingStatus();
    try {
      await service.signInwithGoogle();
      await _handleAuth();
    } catch (e) {
      if (e is FirebaseAuthException) {
        showToast(message: e.message!);
      }
    }
    _upateLoadingStatus();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Spacer(),
          Text(
            "Welcome to\nBavon Chat",
            textAlign: TextAlign.center,
            style: TextStyle(
                color: Colors.black,
                fontWeight: FontWeight.w400,
                fontSize: width(context: context) * .10),
          ),
          const Padding(
            padding: EdgeInsets.all(8.0),
            child: Text("Sign in to Continue"),
          ),
          const Spacer(),
          Align(
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Container(
                decoration: BoxDecoration(
                    color: Theme.of(context).primaryColor,
                    borderRadius: BorderRadius.circular(30)),
                child: _loading
                    ? Center(
                        child: showProgress(color: Colors.white),
                      )
                    : TextButton(
                        onPressed: () {
                          _signIn();
                        },
                        child: const Padding(
                          padding: EdgeInsets.all(8.0),
                          child: Text(
                            "Continue with Google",
                            style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold),
                          ),
                        )),
              ),
            ),
          )
        ],
      ),
    );
  }
}
