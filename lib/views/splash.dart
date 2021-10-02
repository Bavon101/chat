import 'package:chat/controllers/short_calls.dart';
import 'package:flutter/material.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({ Key? key }) : super(key: key);

  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Text("BAVON CHAT",
        textAlign: TextAlign.center,
        
        style: TextStyle(
          letterSpacing: 1.2,
          color: Colors.black,
          fontWeight: FontWeight.w400,
          fontSize: width(context: context)*.05
        ),),
      ),
    );
  }
}