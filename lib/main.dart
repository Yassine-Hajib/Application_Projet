import 'package:flutter/material.dart';

// Import your pages
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

      /// -----------------------------
      /// Initial route (Login Page)
      /// -----------------------------
      initialRoute: '/',

      /// -----------------------------
      /// App routes
      /// -----------------------------
      routes: {
        '/': (context) => const LoginPage(), // Login
        '/signup': (context) => const SignupPage(), // Signup
        '/admin_home': (context) => const AdminHomePage(), // Admin dashboard
        '/chauffeur_home': (context) =>
            ChauffeurHomePage(), // Chauffeur dashboard
        '/support_home': (context) =>
            const SupporteurAcceuil(), // Supporter dashboard
      },
    );
  }
}
