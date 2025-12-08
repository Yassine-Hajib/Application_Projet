import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart'; // IMPORT THIS
import 'Parametres.dart'; 
import '../Yassine_Front/Login.dart'; 

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  // Variables to hold the real data
  String fullName = "Chargement...";
  String email = "...";
  String phone = "...";
  String role = "Supporteur";

  @override
  void initState() {
    super.initState();
    _loadUserData(); // Load data when page starts
  }

  // -------------------------------------------------------
  // LOAD DATA FROM PHONE MEMORY (SHARED PREFERENCES)
  // -------------------------------------------------------
  Future<void> _loadUserData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      String nom = prefs.getString('nom') ?? "Utilisateur";
      String prenom = prefs.getString('prenom') ?? "";
      fullName = "$prenom $nom"; // Combine First + Last Name
      
      email = prefs.getString('email') ?? "Pas d'email";
      phone = prefs.getString('telephone') ?? "Pas de numéro";
      role = prefs.getString('role') ?? "Supporteur";
    });
  }

  // -------------------------------------------------------
  // LOGOUT (Clear data and go to Login)
  // -------------------------------------------------------
  Future<void> _handleLogout() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.clear(); // DELETE ALL DATA
    
    if (!mounted) return;
    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(builder: (context) => const LoginPage()),
      (route) => false,
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
            // ----------------- HEADER (WAVE) -----------------
            Stack(
              children: [
                ClipPath(
                  clipper: StadiumWaveClipper(),
                  child: Container(
                    height: 260,
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
                  child: CircleAvatar(radius: 100, backgroundColor: Colors.white.withOpacity(0.05)),
                ),
                Positioned(
                  bottom: 80, left: -30,
                  child: CircleAvatar(radius: 60, backgroundColor: Colors.white.withOpacity(0.05)),
                ),
                SafeArea(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 25, vertical: 20),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            InkWell(
                              onTap: () => Navigator.pop(context),
                              child: const Icon(Icons.arrow_back_ios, color: Colors.white, size: 20),
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
                        const SizedBox(height: 35),
                        
                        // ----------------- PROFILE INFO ROW -----------------
                        Row(
                          children: [
                            Container(
                              padding: const EdgeInsets.all(4),
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                border: Border.all(color: moroccoGreen, width: 3),
                                color: Colors.white,
                              ),
                              child: const CircleAvatar(radius: 32, backgroundImage: AssetImage("assets/avatar.png")),
                            ),
                            const SizedBox(width: 20),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                // REAL NAME DISPLAYED HERE
                                Text(
                                  fullName, 
                                  style: const TextStyle(fontSize: 22, fontWeight: FontWeight.w900, color: Colors.white, letterSpacing: 0.5)
                                ),
                                const SizedBox(height: 4),
                                Container(
                                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                                  decoration: BoxDecoration(color: moroccoGreen, borderRadius: BorderRadius.circular(4)),
                                  // REAL ROLE DISPLAYED HERE
                                  child: Text(
                                    role.toUpperCase(), 
                                    style: const TextStyle(fontSize: 10, fontWeight: FontWeight.bold, color: Colors.white)
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),

            // ----------------- INFO CARDS (REAL DATA) -----------------
            Padding(
              padding: const EdgeInsets.only(top: 0),
              child: Column(
                children: [
                  _afconInfoCard(Icons.email_outlined, "Email", email, moroccoGreen),
                  _afconInfoCard(Icons.phone_outlined, "Téléphone", phone, moroccoGreen),
                  _afconInfoCard(Icons.confirmation_number_outlined, "Statut", "Actif", moroccoGreen),
                  _afconInfoCard(Icons.security, "Sécurité", "Vérifiée", moroccoGreen),
                ],
              ),
            ),

            const SizedBox(height: 30),

            // ----------------- BUTTONS -----------------
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 25),
              child: ElevatedButton(
                onPressed: () {
                  Navigator.push(context, MaterialPageRoute(builder: (context) => const ParametresPage()));
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: moroccoGreen,
                  foregroundColor: Colors.white,
                  minimumSize: const Size(double.infinity, 55),
                  elevation: 5,
                  shadowColor: moroccoGreen.withOpacity(0.4),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
                ),
                child: const Text("MODIFIER PROFIL", style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, letterSpacing: 1)),
              ),
            ),

            const SizedBox(height: 15),

            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 25),
              child: OutlinedButton(
                onPressed: _handleLogout, // LOGOUT FUNCTION
                style: OutlinedButton.styleFrom(
                  foregroundColor: moroccoRed,
                  minimumSize: const Size(double.infinity, 55),
                  side: const BorderSide(color: moroccoRed, width: 2),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
                ),
                child: const Text("DÉCONNEXION", style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, letterSpacing: 1)),
              ),
            ),
            const SizedBox(height: 40),
          ],
        ),
      ),
    );
  }
}

// ----------------- HELPER WIDGETS -----------------

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

Widget _afconInfoCard(IconData icon, String title, String value, Color accentColor) {
  return Container(
    margin: const EdgeInsets.symmetric(horizontal: 25, vertical: 8),
    padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
    decoration: BoxDecoration(
      color: Colors.white,
      borderRadius: BorderRadius.circular(15),
      boxShadow: [
        BoxShadow(color: Colors.grey.withOpacity(0.1), spreadRadius: 2, blurRadius: 10, offset: const Offset(0, 5)),
      ],
    ),
    child: Row(
      children: [
        Container(
          padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(color: accentColor.withOpacity(0.1), borderRadius: BorderRadius.circular(10)),
          child: Icon(icon, color: accentColor, size: 22),
        ),
        const SizedBox(width: 15),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(title.toUpperCase(), style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: Colors.grey.shade400, letterSpacing: 0.5)),
              const SizedBox(height: 2),
              Text(
                value, 
                style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w600, color: Colors.black87),
                overflow: TextOverflow.ellipsis,
              ),
            ],
          ),
        ),
      ],
    ),
  );
}