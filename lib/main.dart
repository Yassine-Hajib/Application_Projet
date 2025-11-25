import 'package:flutter/material.dart';

// Imports des pages
import './Frontend/yassine_front/Login.dart';
import './Frontend/yassine_front/Signup.dart';
import './Frontend/yassine_front/Supporteur_acceuil.dart';
import './Frontend/yassine_front/admin_acceuil.dart';
import './Frontend/yassine_front/Chauffeur_acceuil.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: "CAN 2025 App",

      initialRoute: '/login',
routes: {
  '/login': (context) => LoginPage(),
  '/signup': (context) => SignupPage(),
  '/supporteur_acceuil': (context) => SupportHomePage(),
  '/chauffeur_home': (context) => ChauffeurHomePage(),
  '/admin_home': (context) => AdminHomePage(),
}

    );
  }
}
