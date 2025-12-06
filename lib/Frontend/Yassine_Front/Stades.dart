import 'package:flutter/material.dart';

class StadesPage extends StatelessWidget {
  const StadesPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Stades"),
        backgroundColor: const Color(0xFFC1272D), // Morocco Red
        foregroundColor: Colors.white,
      ),
      body: const Center(
        child: Text(
          "Page Stades \n(En Construction)",
          textAlign: TextAlign.center,
          style: TextStyle(fontSize: 20, color: Colors.grey),
        ),
      ),
    );
  }
}