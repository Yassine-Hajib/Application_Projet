import 'package:flutter/material.dart';
import 'Frontend/yassine_front/Login.dart';
import 'Frontend/yassine_front/Signup.dart';
import 'Frontend/yassine_front/admin_acceuil.dart';
import 'Frontend/yassine_front/Chauffeur_acceuil.dart';
import 'Frontend/yassine_front/supporteur_acceuil.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Transport CAN 2025',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(primarySwatch: Colors.green),
      initialRoute: '/',
      routes: {
        '/': (context) => const LoginPage(),
        '/signup': (context) => const SignupPage(),
        // These must match the class names in your files:
        '/admin_home': (context) => const AdminHomePage(),
        '/chauffeur_home': (context) => const ChauffeurAcceuil(),
        '/support_home': (context) => const SupporteurAccueil(),
      },
    );
  }
}
