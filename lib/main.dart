import 'package:chat/controllers/fire_google_service.dart';
import 'package:chat/controllers/short_calls.dart';
import 'package:chat/views/home.dart';
import 'package:chat/views/login_page.dart';
import 'package:chat/views/splash.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'controllers/app_state.dart';
import 'controllers/fire_data_handler.dart';

final FireGoogleService service = FireGoogleService();
late FireData fireData;
Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final FirebaseApp app = await Firebase.initializeApp();
  fireData = FireData(app: app);
  fireData.init();
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => AppState()),
      ],
      child: const MyApp(),
    ),
  );
}
final FirebaseAuth _auth = FirebaseAuth.instance;

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: StreamBuilder<User?>(
          stream:  _auth.authStateChanges(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const SplashScreen();
            } else {
              if (!snapshot.hasData ) {
                return const LoginPage();
              }
              else{
                state(context: context).getUser();
              }

              return const HomePage();
            }
          }),
    );
  }
}
