import 'package:flutter/material.dart';

// Import correctly
import 'Frontend/Yassine_Front/Acceuil.dart'; 

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
      theme: ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFFC1272D),
          primary: const Color(0xFFC1272D),
          secondary: const Color(0xFF006233),
        ),
        scaffoldBackgroundColor: Colors.grey.shade50,
        appBarTheme: const AppBarTheme(
          backgroundColor: Color(0xFFC1272D),
          foregroundColor: Colors.white,
          centerTitle: true,
        ),
      ),
      // FIX: Ensure this class name matches the one in Acceuil.dart
      home: const SupporteurAcceuil(),
    );
  }
}