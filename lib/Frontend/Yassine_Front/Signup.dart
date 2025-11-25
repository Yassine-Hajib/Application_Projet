import 'package:flutter/material.dart';

class SignupPage extends StatefulWidget {
  @override
  _SignupPageState createState() => _SignupPageState();
}

class _SignupPageState extends State<SignupPage> {
  // Controllers
  final TextEditingController usernameController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  // Selected user type
  String userType = "support"; // default

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(25),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // -----------------------
              // Title
              // -----------------------
              const Text(
                "Créer un compte",
                style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 5),
              const Text(
                "Inscrivez-vous pour continuer",
                style: TextStyle(fontSize: 14, color: Colors.black54),
              ),

              const SizedBox(height: 40),

              // -----------------------
              // Username
              // -----------------------
              TextField(
                controller: usernameController,
                decoration: InputDecoration(
                  labelText: "Nom d'utilisateur",
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
              ),

              const SizedBox(height: 20),

              // -----------------------
              // Password
              // -----------------------
              TextField(
                controller: passwordController,
                obscureText: true,
                decoration: InputDecoration(
                  labelText: "Mot de passe",
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
              ),

              const SizedBox(height: 25),

              // -----------------------
              // USER TYPE DROPDOWN
              // -----------------------
              const Text(
                "Type d'utilisateur",
                style: TextStyle(fontSize: 15, fontWeight: FontWeight.w600),
              ),
              const SizedBox(height: 5),

              DropdownButtonFormField<String>(
                value: userType,
                decoration: InputDecoration(
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                items: const [
                  DropdownMenuItem(value: "support", child: Text("Supporteur")),
                  DropdownMenuItem(
                    value: "chauffeur",
                    child: Text("Chauffeur"),
                  ),
                  DropdownMenuItem(value: "admin", child: Text("Admin")),
                ],
                onChanged: (value) {
                  setState(() {
                    userType = value!;
                  });
                },
              ),

              const SizedBox(height: 35),

              // -----------------------
              // SIGNUP BUTTON
              // -----------------------
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.green,
                  minimumSize: const Size(double.infinity, 50),
                ),
                onPressed: () {
                  _handleSignup(context);
                },
                child: const Text(
                  "S'inscrire",
                  style: TextStyle(color: Colors.white, fontSize: 18),
                ),
              ),

              const SizedBox(height: 20),

              // -----------------------
              // Already have account?
              // -----------------------
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text("Vous avez déjà un compte ? "),
                  GestureDetector(
                    onTap: () {
                      Navigator.pushNamed(context, '/login');
                    },
                    child: const Text(
                      "Se connecter",
                      style: TextStyle(
                        color: Colors.green,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  // ============================================
  // SIGNUP LOGIC (POO)
  // ============================================
  void _handleSignup(BuildContext context) {
    if (usernameController.text.isEmpty || passwordController.text.isEmpty) {
      _showMessage(context, "Veuillez remplir tous les champs.");
      return;
    }

    // REDIRECT BASED ON USER TYPE
    if (userType == "admin") {
      Navigator.pushNamed(context, '/admin_home');
    } else if (userType == "chauffeur") {
      Navigator.pushNamed(context, '/chauffeur_home');
    } else {
      Navigator.pushNamed(context, '/support_home');
    }
  }

  // Simple popup message
  void _showMessage(BuildContext context, String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message), backgroundColor: Colors.red),
    );
  }
}
