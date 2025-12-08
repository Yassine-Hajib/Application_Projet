import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class ParametresPage extends StatefulWidget {
  const ParametresPage({super.key});

  @override
  State<ParametresPage> createState() => _ParametresPageState();
}

class _ParametresPageState extends State<ParametresPage> {
  // ---------------- STATE VARIABLES ----------------
  final TextEditingController _firstNameController = TextEditingController();
  final TextEditingController _lastNameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();

  bool _notificationsEnabled = true;
  bool _isLoading = false;
  String? _currentSavedEmail; // To identify the user in DB

  // API URL (Ensure this matches your setup)
  final String apiUrl = "http://localhost:8888/Backend/api/update_profile.php";

  @override
  void initState() {
    super.initState();
    _loadUserData();
  }

  // 1. Load data from Phone Storage
  Future<void> _loadUserData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      _firstNameController.text = prefs.getString('prenom') ?? "";
      _lastNameController.text = prefs.getString('nom') ?? "";
      _emailController.text = prefs.getString('email') ?? "";
      _phoneController.text = prefs.getString('telephone') ?? "";
      
      // Keep track of the email used to login, so we know WHO to update in DB
      _currentSavedEmail = prefs.getString('email'); 
    });
  }

  // 2. Send Update to Database
  Future<void> _updateProfile() async {
    setState(() => _isLoading = true);

    try {
      final response = await http.post(
        Uri.parse(apiUrl),
        headers: {"Content-Type": "application/json"},
        body: jsonEncode({
          "old_email": _currentSavedEmail, // The key to find user in DB
          "nom": _lastNameController.text,
          "prenom": _firstNameController.text,
          "email": _emailController.text, // The new email
          "phone": _phoneController.text,
        }),
      );

      if (response.statusCode == 200) {
        var jsonResponse = jsonDecode(response.body);
        if (jsonResponse['success'] == true) {
          
          // 3. Update Local Storage with new values
          SharedPreferences prefs = await SharedPreferences.getInstance();
          await prefs.setString('nom', _lastNameController.text);
          await prefs.setString('prenom', _firstNameController.text);
          await prefs.setString('email', _emailController.text);
          await prefs.setString('telephone', _phoneController.text);
          
          // Update the tracking email in case they changed it
          setState(() {
             _currentSavedEmail = _emailController.text;
          });

          if(mounted) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text("Profil mis à jour avec succès !"), backgroundColor: Colors.green),
            );
          }
        } else {
          _showError(jsonResponse['message']);
        }
      } else {
        _showError("Erreur Serveur: ${response.statusCode}");
      }
    } catch (e) {
      _showError("Erreur de connexion: $e");
    } finally {
      setState(() => _isLoading = false);
    }
  }

  void _showError(String msg) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(msg), backgroundColor: Colors.red),
    );
  }

  @override
  Widget build(BuildContext context) {
    const Color moroccoRed = Color(0xFFC1272D);
    const Color moroccoGreen = Color(0xFF006233);
    const Color darkRed = Color(0xFF8A1C21);

    return Scaffold(
      backgroundColor: Colors.grey.shade50,
      body: SingleChildScrollView(
        child: Column(
          children: [
            // ----------------- HEADER SECTION -----------------
            Stack(
              children: [
                ClipPath(
                  clipper: StadiumWaveClipper(),
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
                  top: -40, right: -30,
                  child: CircleAvatar(radius: 80, backgroundColor: Colors.white.withOpacity(0.05)),
                ),
                SafeArea(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            IconButton(
                              onPressed: () {
                                if (Navigator.canPop(context)) Navigator.pop(context);
                              },
                              icon: const Icon(Icons.arrow_back_ios, color: Colors.white, size: 24),
                            ),
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                              decoration: BoxDecoration(
                                color: Colors.white.withOpacity(0.2),
                                borderRadius: BorderRadius.circular(20),
                                border: Border.all(color: Colors.white30),
                              ),
                              child: const Text("AFCON 2025 🇲🇦", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 12)),
                            ),
                          ],
                        ),
                        const SizedBox(height: 20),
                        const Padding(
                          padding: EdgeInsets.only(left: 10),
                          child: Text("Modifier Profil", style: TextStyle(fontSize: 28, fontWeight: FontWeight.w900, color: Colors.white, letterSpacing: 1)),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),

            // ----------------- EDIT FORM -----------------
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _sectionTitle("INFORMATIONS PERSONNELLES"),
                  Row(
                    children: [
                      Expanded(child: _inputField("Prénom", Icons.person, _firstNameController, moroccoGreen)),
                      const SizedBox(width: 15),
                      Expanded(child: _inputField("Nom", Icons.person_outline, _lastNameController, moroccoGreen)),
                    ],
                  ),
                  _inputField("Email", Icons.email_outlined, _emailController, moroccoGreen, isEmail: true),
                  _inputField("Téléphone", Icons.phone_outlined, _phoneController, moroccoGreen, isPhone: true),

                  const SizedBox(height: 25),
                  _sectionTitle("SÉCURITÉ & PRÉFÉRENCES"),
                  _clickableTile(
                    title: "Mot de passe",
                    subtitle: "Appuyez pour modifier",
                    icon: Icons.lock_outline,
                    color: moroccoRed,
                    onTap: () { /* Add password change logic later */ },
                  ),
                  _switchTile(
                    title: "Notifications",
                    icon: Icons.notifications_active_outlined,
                    value: _notificationsEnabled,
                    color: moroccoGreen,
                    onChanged: (val) => setState(() => _notificationsEnabled = val),
                  ),

                  const SizedBox(height: 30),

                  // --- SAVE BUTTON ---
                  SizedBox(
                    width: double.infinity,
                    height: 55,
                    child: ElevatedButton(
                      onPressed: _isLoading ? null : _updateProfile,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: moroccoGreen,
                        foregroundColor: Colors.white,
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
                        elevation: 5,
                        shadowColor: moroccoGreen.withOpacity(0.4),
                      ),
                      child: _isLoading 
                        ? const CircularProgressIndicator(color: Colors.white)
                        : const Text("ENREGISTRER LES MODIFICATIONS", style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold, letterSpacing: 1)),
                    ),
                  ),
                  const SizedBox(height: 40),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ----------------- WIDGETS (Unchanged Style) -----------------
  Widget _sectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.only(left: 5, bottom: 15),
      child: Text(title, style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: Colors.grey.shade500, letterSpacing: 1.2)),
    );
  }

  Widget _inputField(String label, IconData icon, TextEditingController controller, Color accentColor, {bool isEmail = false, bool isPhone = false}) {
    return Container(
      margin: const EdgeInsets.only(bottom: 15),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(15),
        boxShadow: [BoxShadow(color: Colors.grey.withOpacity(0.05), spreadRadius: 2, blurRadius: 10, offset: const Offset(0, 4))],
      ),
      child: TextField(
        controller: controller,
        keyboardType: isEmail ? TextInputType.emailAddress : (isPhone ? TextInputType.phone : TextInputType.text),
        decoration: InputDecoration(
          labelText: label,
          labelStyle: TextStyle(color: Colors.grey.shade500, fontSize: 14),
          prefixIcon: Icon(icon, color: accentColor.withOpacity(0.7), size: 22),
          border: InputBorder.none,
          contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
          enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(15), borderSide: BorderSide.none),
          focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(15), borderSide: BorderSide(color: accentColor, width: 1.5)),
        ),
      ),
    );
  }

  Widget _clickableTile({required String title, String? subtitle, required IconData icon, required Color color, required VoidCallback onTap}) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(15),
        boxShadow: [BoxShadow(color: Colors.grey.withOpacity(0.05), spreadRadius: 2, blurRadius: 10, offset: const Offset(0, 4))],
      ),
      child: ListTile(
        onTap: onTap,
        leading: Container(
          padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(color: color.withOpacity(0.1), borderRadius: BorderRadius.circular(10)),
          child: Icon(icon, color: color, size: 22),
        ),
        title: Text(title, style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 15)),
        subtitle: subtitle != null ? Text(subtitle, style: TextStyle(fontSize: 12, color: Colors.grey.shade400)) : null,
        trailing: Icon(Icons.arrow_forward_ios, size: 16, color: Colors.grey.shade300),
      ),
    );
  }

  Widget _switchTile({required String title, required IconData icon, required bool value, required Color color, required Function(bool) onChanged}) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(15),
        boxShadow: [BoxShadow(color: Colors.grey.withOpacity(0.05), spreadRadius: 2, blurRadius: 10, offset: const Offset(0, 4))],
      ),
      child: ListTile(
        leading: Container(
          padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(color: color.withOpacity(0.1), borderRadius: BorderRadius.circular(10)),
          child: Icon(icon, color: color, size: 22),
        ),
        title: Text(title, style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 15)),
        trailing: Switch(value: value, activeColor: Colors.white, activeTrackColor: color, onChanged: onChanged),
      ),
    );
  }
}

class StadiumWaveClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    var path = Path();
    path.lineTo(0, size.height - 60);
    var firstControlPoint = Offset(size.width / 4, size.height);
    var firstEndPoint = Offset(size.width / 2.25, size.height - 40);
    path.quadraticBezierTo(firstControlPoint.dx, firstControlPoint.dy, firstEndPoint.dx, firstEndPoint.dy);
    var secondControlPoint = Offset(size.width - (size.width / 3.25), size.height - 90);
    var secondEndPoint = Offset(size.width, size.height - 50);
    path.quadraticBezierTo(secondControlPoint.dx, secondControlPoint.dy, secondEndPoint.dx, secondEndPoint.dy);
    path.lineTo(size.width, size.height - 40);
    path.lineTo(size.width, 0);
    path.close();
    return path;
  }
  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) => false;
}