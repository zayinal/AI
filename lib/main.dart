
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'my_home_page.dart';
import 'firebase_options.dart';
import 'log_in.dart';
import 'sign_up.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Cotton  Predictor',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      // home:  const MyHomePage(),
      initialRoute: LoginPage.id,
      routes: {
        MyHomePage.id:(context) => const MyHomePage(),
        SignupPage.id:(context) => const SignupPage(),
        LoginPage.id:(context) => const LoginPage()
      },
    );
  }
}
