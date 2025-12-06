import 'package:flutter/material.dart';

class AidePage extends StatelessWidget {
  const AidePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Aide & Support"),
        backgroundColor: const Color(0xFFC1272D),
        foregroundColor: Colors.white,
      ),
      body: const Center(
        child: Text(
          "Page Aide \n(En Construction)",
          textAlign: TextAlign.center,
          style: TextStyle(fontSize: 20, color: Colors.grey),
        ),
      ),
    );
  }
}