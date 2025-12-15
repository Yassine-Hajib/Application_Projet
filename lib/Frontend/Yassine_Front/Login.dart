import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart'; 

// IMPORTS
import 'Signup.dart';
import 'Acceuil.dart'; // Supporter Home
import '../Yassine_Front/Chauffeur_acceuil.dart'; // <--- IMPORT CHAUFFEUR HOME

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _formKey = GlobalKey<FormState>();
  final emailCtrl = TextEditingController();
  final passCtrl = TextEditingController();

  String selectedRole = "Supporteur"; 
  bool isLoading = false;

  // -------------------------------------------------------------
  // CHECK YOUR PORT (8888 for MAMP, 80 for XAMPP)
  // -------------------------------------------------------------
  final String apiUrl = "http://localhost:8888/Backend/api/login.php"; 

  @override
  void dispose() {
    emailCtrl.dispose();
    passCtrl.dispose();
    super.dispose();
  }

  // ----------------- LOGIN LOGIC -----------------
  Future<void> _handleLogin() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => isLoading = true);

    try {
      final response = await http.post(
        Uri.parse(apiUrl),
        headers: {"Content-Type": "application/json"},
        body: jsonEncode({
          "email": emailCtrl.text,
          "password": passCtrl.text,
          "role": selectedRole, // <--- CRITICAL: Sends the role to PHP
        }),
      );

      print("Status: ${response.statusCode}");
      print("Body: ${response.body}");

      if (response.statusCode == 200) {
        var jsonResponse = jsonDecode(response.body);

        if (jsonResponse['success'] == true) {
          // ---------------------------------------------------
          // 1. SAVE USER DATA LOCALLY (SHARED PREFERENCES)
          // ---------------------------------------------------
          var user = jsonResponse['user']; 
          // The backend returns the REAL role (e.g. "Chauffeur" or "Supporteur")
          String dbRole = user['role_utilisateur'] ?? selectedRole;

          SharedPreferences prefs = await SharedPreferences.getInstance();
          
          await prefs.setString('nom', user['nom_utilisateur'] ?? "");
          await prefs.setString('prenom', user['prenom_utilisateur'] ?? "");
          await prefs.setString('email', user['email_utilisateur'] ?? "");
          await prefs.setString('telephone', user['telephone_utilisateur'] ?? "");
          await prefs.setString('role', dbRole); 
          await prefs.setBool('isLoggedIn', true);

          if (mounted) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text("Bienvenue ${user['prenom_utilisateur']} !"), backgroundColor: Colors.green),
            );

            // ---------------------------------------------------
            // 2. NAVIGATE BASED ON DATABASE ROLE
            // ---------------------------------------------------
            if (dbRole == 'Chauffeur') {
               Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => const ChauffeurHomePage()));
            } else if (dbRole == 'Supporteur') {
               Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => const SupporteurAcceuil()));
            } else {
               ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Espace Admin en construction...")));
            }
          }

        } else {
          if (mounted) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text("Erreur: ${jsonResponse['message']}"), backgroundColor: Colors.red),
            );
          }
        }
      } else {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text("Erreur Serveur"), backgroundColor: Colors.red),
          );
        }
      }
    } catch (e) {
      print(e);
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Erreur de connexion"), backgroundColor: Colors.red),
        );
      }
    } finally {
      if (mounted) setState(() => isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    const moroccoRed = Color(0xFFC1272D);
    const darkRed = Color(0xFF8A1C21);
    const moroccoGreen = Color(0xFF006233);

    return Scaffold(
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: Column(
          children: [
            // HEADER
            Stack(
              children: [
                ClipPath(
                  clipper: LoginWaveClipper(),
                  child: Container(
                    height: 280,
                    width: double.infinity,
                    decoration: const BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                        colors: [moroccoRed, darkRed],
                      ),
                    ),
                  ),
                ),
                Positioned(
                  top: -50, right: -50,
                  child: CircleAvatar(radius: 90, backgroundColor: Colors.white.withOpacity(0.05)),
                ),
                Positioned(
                  bottom: 50, left: -20,
                  child: CircleAvatar(radius: 60, backgroundColor: Colors.white.withOpacity(0.05)),
                ),
                const SafeArea(
                  child: SizedBox(
                    width: double.infinity,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        SizedBox(height: 20),
                        Icon(Icons.sports_soccer, size: 70, color: Colors.white), 
                        SizedBox(height: 15),
                        Text("AFCON 2025 🇲🇦", style: TextStyle(fontSize: 26, fontWeight: FontWeight.bold, color: Colors.white, letterSpacing: 1.2)),
                        SizedBox(height: 5),
                        Text("Espace Connexion", style: TextStyle(fontSize: 14, color: Colors.white70, fontWeight: FontWeight.w500, letterSpacing: 1)),
                      ],
                    ),
                  ),
                ),
              ],
            ),

            // FORM
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: Form(
                key: _formKey,
                child: Column(
                  children: [
                    const SizedBox(height: 20),
                    _customTextField(controller: emailCtrl, label: "Email", icon: Icons.email_outlined, isEmail: true),
                    const SizedBox(height: 20),
                    _customTextField(controller: passCtrl, label: "Mot de passe", icon: Icons.lock_outline, isPassword: true),
                    
                    const SizedBox(height: 25),

                    const Align(
                      alignment: Alignment.centerLeft,
                      child: Text("Je suis un :", style: TextStyle(fontWeight: FontWeight.bold, color: Colors.grey)),
                    ),
                    const SizedBox(height: 10),
                    SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: Row(
                        children: [
                          _roleChip("Supporteur", Icons.sports_soccer, moroccoRed),
                          const SizedBox(width: 10),
                          _roleChip("Chauffeur", Icons.directions_car, moroccoGreen),
                          const SizedBox(width: 10),
                          _roleChip("Admin", Icons.admin_panel_settings, Colors.black87),
                        ],
                      ),
                    ),

                    const SizedBox(height: 30),

                    // LOGIN BUTTON
                    SizedBox(
                      width: double.infinity,
                      height: 55,
                      child: ElevatedButton(
                        onPressed: isLoading ? null : _handleLogin,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: moroccoGreen,
                          elevation: 5,
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
                        ),
                        child: isLoading 
                          ? const CircularProgressIndicator(color: Colors.white)
                          : const Text("SE CONNECTER", style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white, letterSpacing: 1)),
                      ),
                    ),

                    const SizedBox(height: 20),

                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text("Pas encore de compte ? ", style: TextStyle(color: Colors.grey.shade600)),
                        GestureDetector(
                          onTap: () => Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => const SignupPage())),
                          child: const Text("S'inscrire", style: TextStyle(color: moroccoRed, fontWeight: FontWeight.bold)),
                        ),
                      ],
                    ),
                    const SizedBox(height: 40),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // WIDGETS
  Widget _customTextField({required TextEditingController controller, required String label, required IconData icon, bool isPassword = false, bool isEmail = false}) {
    return TextFormField(
      controller: controller,
      obscureText: isPassword,
      keyboardType: isEmail ? TextInputType.emailAddress : TextInputType.text,
      validator: (value) {
        if (value == null || value.isEmpty) return 'Requis';
        if (isEmail && !value.contains('@')) return 'Email invalide';
        return null;
      },
      decoration: InputDecoration(
        labelText: label,
        labelStyle: TextStyle(color: Colors.grey.shade500),
        prefixIcon: Icon(icon, color: const Color(0xFFC1272D).withOpacity(0.7)),
        filled: true,
        fillColor: Colors.grey.shade50,
        contentPadding: const EdgeInsets.symmetric(vertical: 18, horizontal: 20),
        enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(15), borderSide: BorderSide(color: Colors.grey.shade200)),
        focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(15), borderSide: const BorderSide(color: Color(0xFFC1272D))),
      ),
    );
  }

  Widget _roleChip(String label, IconData icon, Color color) {
    bool isSelected = selectedRole == label;
    return GestureDetector(
      onTap: () => setState(() => selectedRole = label),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
        decoration: BoxDecoration(
          color: isSelected ? color : Colors.white,
          borderRadius: BorderRadius.circular(25),
          border: Border.all(color: isSelected ? color : Colors.grey.shade300),
          boxShadow: isSelected ? [BoxShadow(color: color.withOpacity(0.3), blurRadius: 8, offset: const Offset(0, 4))] : [],
        ),
        child: Row(
          children: [
            Icon(icon, color: isSelected ? Colors.white : Colors.grey, size: 18),
            const SizedBox(width: 8),
            Text(label, style: TextStyle(color: isSelected ? Colors.white : Colors.black54, fontWeight: FontWeight.bold, fontSize: 13)),
          ],
        ),
      ),
    );
  }
}

class LoginWaveClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    var path = Path();
    path.lineTo(0, size.height - 50);
    path.quadraticBezierTo(size.width / 4, size.height, size.width / 2.25, size.height - 40);
    path.quadraticBezierTo(size.width - (size.width / 3.25), size.height - 90, size.width, size.height - 60);
    path.lineTo(size.width, 0);
    path.close();
    return path;
  }
  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) => false;
}