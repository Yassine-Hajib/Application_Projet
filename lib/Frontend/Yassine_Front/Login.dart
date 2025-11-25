import 'package:flutter/material.dart';

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final emailController = TextEditingController();
  final passController = TextEditingController();

  String selectedType = "support";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Login"), backgroundColor: Colors.green),

      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            TextField(
              controller: emailController,
              decoration: InputDecoration(labelText: "Email"),
            ),

            TextField(
              controller: passController,
              decoration: InputDecoration(labelText: "Password"),
              obscureText: true,
            ),

            const SizedBox(height: 15),

            DropdownButtonFormField(
              value: selectedType,
              items: const [
                DropdownMenuItem(value: "admin", child: Text("Admin")),
                DropdownMenuItem(value: "chauffeur", child: Text("Chauffeur")),
                DropdownMenuItem(value: "support", child: Text("Supporteur")),
              ],
              onChanged: (value) {
                setState(() {
                  selectedType = value.toString();
                });
              },
            ),

            const SizedBox(height: 20),

            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.green,
                minimumSize: const Size(double.infinity, 50),
              ),
              onPressed: () {
                if (selectedType == "admin") {
                  Navigator.pushNamed(context, '/admin_home');
                } else if (selectedType == "chauffeur") {
                  Navigator.pushNamed(context, '/chauffeur_home');
                } else {
                  Navigator.pushNamed(context, '/support_home');
                }
              },
              child: Text("Login", style: TextStyle(color: Colors.white)),
            ),

            TextButton(
              onPressed: () => Navigator.pushNamed(context, '/signup'),
              child: Text("Create a new account"),
            ),
          ],
        ),
      ),
    );
  }
}
