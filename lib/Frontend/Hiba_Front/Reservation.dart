import 'package:flutter/material.dart';

class ReservationPage extends StatelessWidget {
  const ReservationPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Réservations"),
        backgroundColor: const Color(0xFFC1272D),
        foregroundColor: Colors.white,
      ),
      body: const Center(
        child: Text(
          "Page Réservations \n(En Construction)",
          textAlign: TextAlign.center,
          style: TextStyle(fontSize: 20, color: Colors.grey),
        ),
      ),
    );
  }
}