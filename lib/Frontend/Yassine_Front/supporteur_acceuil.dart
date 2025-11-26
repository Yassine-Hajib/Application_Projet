import 'package:flutter/material.dart';

class SupporteurAccueil extends StatelessWidget {
  const SupporteurAccueil({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Text(
          "Supporter Home Page 🇲🇦",
          style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
        ),
      ),
    );
  }
}
