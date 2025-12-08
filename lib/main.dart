import 'package:flutter/material.dart';

// -----------------------------------------------------------
// IMPORT THE LOGIN PAGE
// -----------------------------------------------------------
import 'Frontend/Yassine_Front/Login.dart'; 

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'AFCON 2025 App',
      
      // ---------------- THEME DATA ----------------
      theme: ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFFC1272D), // Morocco Red
          primary: const Color(0xFFC1272D),
          secondary: const Color(0xFF006233), // Morocco Green
        ),
        scaffoldBackgroundColor: Colors.white,
        appBarTheme: const AppBarTheme(
          backgroundColor: Color(0xFFC1272D),
          foregroundColor: Colors.white,
          centerTitle: true,
        ),
      ),

      // ---------------- STARTING PAGE ----------------
      // Now starts at Login
      home: const LoginPage(),
    );
  }
}