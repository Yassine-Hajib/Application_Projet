import 'dart:convert'; // For encoding JSON
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http; // For API Connection
import 'package:shared_preferences/shared_preferences.dart'; // <--- IMPORT ADDED

// Imports
import 'Acceuil.dart'; 
import 'Login.dart';

class SignupPage extends StatefulWidget {
  const SignupPage({super.key});

  @override
  State<SignupPage> createState() => _SignupPageState();
}

class _SignupPageState extends State<SignupPage> {
  final _formKey = GlobalKey<FormState>();

  // Controllers
  final nameCtrl = TextEditingController();
  final prenomCtrl = TextEditingController();
  final emailCtrl = TextEditingController();
  final passCtrl = TextEditingController();
  final phoneCtrl = TextEditingController();

  // Chauffeur specific
  final carModelCtrl = TextEditingController();
  final matriculeCtrl = TextEditingController();
  String carEtat = "En service";

  String selectedRole = "Supporteur";
  bool isLoading = false; // To show a loading spinner

  @override
  void dispose() {
    nameCtrl.dispose();
    prenomCtrl.dispose();
    emailCtrl.dispose();
    passCtrl.dispose();
    phoneCtrl.dispose();
    carModelCtrl.dispose();
    matriculeCtrl.dispose();
    super.dispose();
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
            // ----------------- HEADER -----------------
            Stack(
              children: [
                ClipPath(
                  clipper: SignupWaveClipper(),
                  child: Container(
                    height: 220,
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
                  top: -40, right: -40,
                  child: CircleAvatar(radius: 80, backgroundColor: Colors.white.withOpacity(0.05)),
                ),
                SafeArea(
                  child: Padding(
                    padding: const EdgeInsets.only(top: 20, left: 20),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        IconButton(
                          icon: const Icon(Icons.arrow_back_ios, color: Colors.white),
                          onPressed: () => Navigator.pop(context),
                        ),
                        const SizedBox(height: 10),
                        const Text("Créer un compte", style: TextStyle(fontSize: 32, fontWeight: FontWeight.bold, color: Colors.white)),
                        const Text("Rejoignez l'ambiance AFCON 2025", style: TextStyle(fontSize: 16, color: Colors.white70)),
                      ],
                    ),
                  ),
                ),
              ],
            ),

            // ----------------- FORM -----------------
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 10),
              child: Form(
                key: _formKey,
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        _roleChip("Supporteur", Icons.sports_soccer, moroccoRed),
                        const SizedBox(width: 15),
                        _roleChip("Chauffeur", Icons.directions_car, moroccoGreen),
                      ],
                    ),
                    const SizedBox(height: 25),

                    Row(
                      children: [
                        Expanded(child: _customTextField("Nom", Icons.person_outline, nameCtrl)),
                        const SizedBox(width: 10),
                        Expanded(child: _customTextField("Prénom", Icons.person, prenomCtrl)),
                      ],
                    ),
                    const SizedBox(height: 15),
                    _customTextField("Email", Icons.email_outlined, emailCtrl, isEmail: true),
                    const SizedBox(height: 15),
                    _customTextField("Téléphone", Icons.phone_outlined, phoneCtrl, isPhone: true),
                    const SizedBox(height: 15),
                    _customTextField("Mot de passe", Icons.lock_outline, passCtrl, isPassword: true),
                    const SizedBox(height: 25),

                    if (selectedRole == 'Chauffeur') ...[
                      const Divider(),
                      const Padding(
                        padding: EdgeInsets.symmetric(vertical: 10),
                        child: Text("Info Véhicule", style: TextStyle(fontWeight: FontWeight.bold, color: Colors.grey)),
                      ),
                      _customTextField("Modèle Voiture", Icons.car_rental, carModelCtrl),
                      const SizedBox(height: 15),
                      _customTextField("Matricule", Icons.confirmation_number_outlined, matriculeCtrl),
                      const SizedBox(height: 25),
                    ],

                    // Sign Up Button with Loading State
                    SizedBox(
                      width: double.infinity,
                      height: 55,
                      child: ElevatedButton(
                        onPressed: isLoading ? null : _handleSignup,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: moroccoGreen,
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
                          elevation: 5,
                        ),
                        child: isLoading 
                          ? const CircularProgressIndicator(color: Colors.white)
                          : const Text("S'INSCRIRE", style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white, letterSpacing: 1)),
                      ),
                    ),

                    const SizedBox(height: 20),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text("Déjà un compte ? ", style: TextStyle(color: Colors.grey.shade600)),
                        GestureDetector(
                          onTap: () => Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => const LoginPage())),
                          child: const Text("Se connecter", style: TextStyle(color: moroccoRed, fontWeight: FontWeight.bold)),
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

  // ----------------- WIDGETS -----------------
  Widget _roleChip(String label, IconData icon, Color color) {
    bool isSelected = selectedRole == label;
    return GestureDetector(
      onTap: () => setState(() => selectedRole = label),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
        decoration: BoxDecoration(
          color: isSelected ? color : Colors.grey.shade100,
          borderRadius: BorderRadius.circular(30),
          border: Border.all(color: isSelected ? color : Colors.transparent),
          boxShadow: isSelected ? [BoxShadow(color: color.withOpacity(0.3), blurRadius: 8, offset: const Offset(0, 4))] : [],
        ),
        child: Row(
          children: [
            Icon(icon, color: isSelected ? Colors.white : Colors.grey, size: 20),
            const SizedBox(width: 8),
            Text(label, style: TextStyle(color: isSelected ? Colors.white : Colors.black54, fontWeight: FontWeight.bold)),
          ],
        ),
      ),
    );
  }

  Widget _customTextField(String label, IconData icon, TextEditingController ctrl, {bool isPassword = false, bool isEmail = false, bool isPhone = false}) {
    return TextFormField(
      controller: ctrl,
      obscureText: isPassword,
      keyboardType: isEmail ? TextInputType.emailAddress : (isPhone ? TextInputType.phone : TextInputType.text),
      validator: (value) {
        if (value == null || value.isEmpty) return 'Requis';
        if (isEmail && !value.contains('@')) return 'Email invalide';
        if (isPassword && value.length < 6) return 'Min 6 caractères';
        return null;
      },
      decoration: InputDecoration(
        labelText: label,
        labelStyle: TextStyle(color: Colors.grey.shade500),
        prefixIcon: Icon(icon, color: const Color(0xFFC1272D).withOpacity(0.7)),
        filled: true,
        fillColor: Colors.grey.shade50,
        contentPadding: const EdgeInsets.symmetric(vertical: 16, horizontal: 20),
        enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(15), borderSide: BorderSide(color: Colors.grey.shade200)),
        focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(15), borderSide: const BorderSide(color: Color(0xFFC1272D))),
        errorBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(15), borderSide: const BorderSide(color: Colors.red)),
      ),
    );
  }

  // ----------------- API LOGIC (UPDATED WITH SHARED PREFERENCES) -----------------
  Future<void> _handleSignup() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => isLoading = true);

    const String apiUrl = "http://localhost:8888/Backend/api/signup.php";

    try {
      final response = await http.post(
        Uri.parse(apiUrl),
        headers: {"Content-Type": "application/json"},
        body: jsonEncode({
          "nom": nameCtrl.text,
          "prenom": prenomCtrl.text,
          "email": emailCtrl.text,
          "password": passCtrl.text,
          "phone": phoneCtrl.text,
          "role": selectedRole,
        }),
      );

      if (response.statusCode == 201) {
        var jsonResponse = jsonDecode(response.body);
        
        if (jsonResponse['success'] == true) {
          
          // --- FIX: SAVE USER DATA TO PHONE ---
          SharedPreferences prefs = await SharedPreferences.getInstance();
          await prefs.setString('nom', nameCtrl.text);
          await prefs.setString('prenom', prenomCtrl.text);
          await prefs.setString('email', emailCtrl.text);
          await prefs.setString('telephone', phoneCtrl.text);
          await prefs.setString('role', selectedRole);
          await prefs.setBool('isLoggedIn', true);
          // ------------------------------------

          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text("Succès: ${jsonResponse['message']}"), backgroundColor: Colors.green),
          );

          if (selectedRole == 'Chauffeur') {
             // Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => const ChauffeurHomePage()));
             ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Compte Chauffeur créé !")));
          } else {
             Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => const SupporteurAcceuil()));
          }
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text("Erreur: ${jsonResponse['message']}"), backgroundColor: Colors.red),
          );
        }
      } else {
        var jsonResponse = jsonDecode(response.body);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Erreur: ${jsonResponse['message']}"), backgroundColor: Colors.red),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Erreur connexion: $e"), backgroundColor: Colors.red),
      );
    } finally {
      setState(() => isLoading = false);
    }
  }
}

class SignupWaveClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    var path = Path();
    path.lineTo(0, size.height - 40);
    var firstControlPoint = Offset(size.width / 4, size.height);
    var firstEndPoint = Offset(size.width / 2.25, size.height - 30);
    path.quadraticBezierTo(firstControlPoint.dx, firstControlPoint.dy, firstEndPoint.dx, firstEndPoint.dy);
    var secondControlPoint = Offset(size.width - (size.width / 3.25), size.height - 80);
    var secondEndPoint = Offset(size.width, size.height - 50);
    path.quadraticBezierTo(secondControlPoint.dx, secondControlPoint.dy, secondEndPoint.dx, secondEndPoint.dy);
    path.lineTo(size.width, 0);
    path.close();
    return path;
  }
  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) => false;
}