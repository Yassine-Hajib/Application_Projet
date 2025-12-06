import 'package:flutter/material.dart';

class EvaluationPage extends StatelessWidget {
  const EvaluationPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Évaluations"),
        backgroundColor: const Color(0xFFC1272D),
        foregroundColor: Colors.white,
      ),
      body: const Center(
        child: Text(
          "Page Évaluations \n(En Construction)",
          textAlign: TextAlign.center,
          style: TextStyle(fontSize: 20, color: Colors.grey),
        ),
      ),
    );
  }
}