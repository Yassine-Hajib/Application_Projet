import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

// --- IMPORTS ---
import 'Acceuil.dart'; // Supporter Home
import 'Login.dart';   // Login Page
import '../Yassine_Front/Chauffeur_acceuil.dart'; // <--- CRITICAL IMPORT FOR CHAUFFEUR HOME

class SignupPage extends StatefulWidget {
  const SignupPage({super.key});

  @override
  State<SignupPage> createState() => _SignupPageState();
}

class _SignupPageState extends State<SignupPage> {
  final _formKey = GlobalKey<FormState>();

  // Common Fields
  final nameCtrl = TextEditingController();
  final prenomCtrl = TextEditingController();
  final emailCtrl = TextEditingController();
  final passCtrl = TextEditingController();
  final phoneCtrl = TextEditingController();

  // Chauffeur Specific Fields
  final permisCtrl = TextEditingController();
  final expirationCtrl = TextEditingController(); 

  String selectedRole = "Supporteur";
  bool isLoading = false;

  // -------------------------------------------------------------
  // API URL (Ensure port matches MAMP: 8888 or 80)
  // -------------------------------------------------------------
  final String apiUrl = "http://localhost:8888/Backend/api/signup.php"; 

  @override
  void dispose() {
    nameCtrl.dispose(); prenomCtrl.dispose(); emailCtrl.dispose();
    passCtrl.dispose(); phoneCtrl.dispose();
    permisCtrl.dispose(); expirationCtrl.dispose();
    super.dispose();
  }

  // Date Picker Helper
  Future<void> _selectDate() async {
    DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now().add(const Duration(days: 365)), 
      firstDate: DateTime.now(),
      lastDate: DateTime(2040),
      builder: (context, child) {
        return Theme(
          data: ThemeData.light().copyWith(
            primaryColor: const Color(0xFFC1272D),
            colorScheme: const ColorScheme.light(primary: Color(0xFFC1272D)),
          ),
          child: child!,
        );
      },
    );
    if (picked != null) {
      setState(() {
        // Format: YYYY-MM-DD for MySQL
        expirationCtrl.text = "${picked.year}-${picked.month.toString().padLeft(2, '0')}-${picked.day.toString().padLeft(2, '0')}";
      });
    }
  }

  // -------------------------------------------------------------
  // SIGNUP LOGIC
  // -------------------------------------------------------------
  Future<void> _handleSignup() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => isLoading = true);

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
          // Specific fields sent only if Chauffeur is selected
          "numero_permis": selectedRole == 'Chauffeur' ? permisCtrl.text : "",
          "date_expiration": selectedRole == 'Chauffeur' ? expirationCtrl.text : "",
        }),
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        var jsonResponse = jsonDecode(response.body);
        
        if (jsonResponse['success'] == true) {
          
          // 1. Save Data Locally (SharedPreferences)
          SharedPreferences prefs = await SharedPreferences.getInstance();
          await prefs.setString('nom', nameCtrl.text);
          await prefs.setString('prenom', prenomCtrl.text);
          await prefs.setString('email', emailCtrl.text);
          await prefs.setString('telephone', phoneCtrl.text);
          await prefs.setString('role', selectedRole);
          await prefs.setBool('isLoggedIn', true);

          if(mounted) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text("Bienvenue ${prenomCtrl.text} !"), backgroundColor: Colors.green),
            );

            // 2. SMART NAVIGATION BASED ON ROLE
            if (selectedRole == 'Chauffeur') {
               // Navigate to Chauffeur Dashboard
               Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => const ChauffeurHomePage()));
            } else {
               // Navigate to Supporter Home
               Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => const SupporteurAcceuil()));
            }
          }

        } else {
          if(mounted) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text("Erreur: ${jsonResponse['message']}"), backgroundColor: Colors.red),
            );
          }
        }
      } else {
         if(mounted) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text("Erreur Serveur (PHP)"), backgroundColor: Colors.red),
            );
         }
      }
    } catch (e) {
       if(mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text("Erreur connexion: $e"), backgroundColor: Colors.red),
          );
       }
    } finally {
      if(mounted) setState(() => isLoading = false);
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
                  clipper: SignupWaveClipper(),
                  child: Container(
                    height: 220,
                    width: double.infinity,
                    decoration: const BoxDecoration(
                      gradient: LinearGradient(begin: Alignment.topLeft, end: Alignment.bottomRight, colors: [moroccoRed, darkRed]),
                    ),
                  ),
                ),
                SafeArea(
                  child: Padding(
                    padding: const EdgeInsets.only(top: 20, left: 20),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        IconButton(icon: const Icon(Icons.arrow_back_ios, color: Colors.white), onPressed: () => Navigator.pop(context)),
                        const SizedBox(height: 10),
                        const Text("Créer un compte", style: TextStyle(fontSize: 32, fontWeight: FontWeight.bold, color: Colors.white)),
                        const Text("Rejoignez l'ambiance AFCON 2025", style: TextStyle(fontSize: 16, color: Colors.white70)),
                      ],
                    ),
                  ),
                ),
              ],
            ),

            // FORM
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

                    // ------------------------------------------------
                    // CHAUFFEUR FIELDS (PERMIS & DATE)
                    // ------------------------------------------------
                    if (selectedRole == 'Chauffeur') ...[
                      const Divider(),
                      const Padding(
                        padding: EdgeInsets.symmetric(vertical: 10),
                        child: Text("Informations Permis", style: TextStyle(fontWeight: FontWeight.bold, color: Colors.grey)),
                      ),
                      
                      _customTextField("Numéro de Permis", Icons.card_membership, permisCtrl),
                      const SizedBox(height: 15),
                      
                      // Custom Date Picker Field
                      GestureDetector(
                        onTap: _selectDate,
                        child: AbsorbPointer(
                          child: _customTextField("Date d'expiration", Icons.calendar_today, expirationCtrl),
                        ),
                      ),
                      const SizedBox(height: 25),
                    ],

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
                    GestureDetector(
                      onTap: () => Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => const LoginPage())),
                      child: const Text("Déjà un compte ? Se connecter", style: TextStyle(color: moroccoRed, fontWeight: FontWeight.bold)),
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
}

class SignupWaveClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    var path = Path();
    path.lineTo(0, size.height - 40);
    path.quadraticBezierTo(size.width / 4, size.height, size.width / 2.25, size.height - 30);
    path.quadraticBezierTo(size.width - (size.width / 3.25), size.height - 80, size.width, size.height - 50);
    path.lineTo(size.width, 0);
    path.close();
    return path;
  }
  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) => false;
}