import 'package:flutter/material.dart';
import './Frontend/yassine_front/Login.dart';
import './Frontend/yassine_front/Signup.dart';
import './Frontend/yassine_front/acceuil.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: "Can App",
      initialRoute: '/login',
      routes: {
        '/login': (context) => LoginPage(),
        '/signup': (context) => SignupPage(),
        '/home': (context) => HomePage(),
      },
    );
  }
}
