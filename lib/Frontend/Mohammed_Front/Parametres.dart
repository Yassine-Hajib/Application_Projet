import 'package:flutter/material.dart';

class ParametresPage extends StatefulWidget {
  const ParametresPage({super.key});

  @override
  State<ParametresPage> createState() => _ParametresPageState();
}

class _ParametresPageState extends State<ParametresPage> {
  // ---------------- STATE VARIABLES ----------------
  // We use Controllers to handle text input
  final TextEditingController _firstNameController = TextEditingController(text: "Mohammed");
  final TextEditingController _lastNameController = TextEditingController(text: "Alami");
  final TextEditingController _emailController = TextEditingController(text: "mohammed@example.com");
  final TextEditingController _phoneController = TextEditingController(text: "+212 6 00 00 00 00");

  bool _notificationsEnabled = true;

  @override
  Widget build(BuildContext context) {
    // ---------------- COLORS ----------------
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
                // 1. Red Wave Background
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

                // 2. Decorative Pattern
                Positioned(
                  top: -40,
                  right: -30,
                  child: CircleAvatar(
                    radius: 80,
                    backgroundColor: Colors.white.withOpacity(0.05),
                  ),
                ),

                // 3. Top Bar
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
                              child: const Text(
                                "AFCON 2025 🇲🇦",
                                style: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 12,
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 20),
                        const Padding(
                          padding: EdgeInsets.only(left: 10),
                          child: Text(
                            "Modifier Profil",
                            style: TextStyle(
                              fontSize: 28,
                              fontWeight: FontWeight.w900,
                              color: Colors.white,
                              letterSpacing: 1,
                            ),
                          ),
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
                  
                  // --- SECTION: INFORMATIONS ---
                  _sectionTitle("INFORMATIONS PERSONNELLES"),
                  
                  // Row for First & Last Name
                  Row(
                    children: [
                      Expanded(
                        child: _inputField("Prénom", Icons.person, _firstNameController, moroccoGreen),
                      ),
                      const SizedBox(width: 15),
                      Expanded(
                        child: _inputField("Nom", Icons.person_outline, _lastNameController, moroccoGreen),
                      ),
                    ],
                  ),
                  
                  _inputField("Email", Icons.email_outlined, _emailController, moroccoGreen, isEmail: true),
                  _inputField("Téléphone", Icons.phone_outlined, _phoneController, moroccoGreen, isPhone: true),

                  const SizedBox(height: 25),

                  // --- SECTION: SÉCURITÉ ---
                  _sectionTitle("SÉCURITÉ & PRÉFÉRENCES"),
                  
                  // Password Change Button (Special Style)
                  _clickableTile(
                    title: "Mot de passe",
                    subtitle: "Appuyez pour modifier",
                    icon: Icons.lock_outline,
                    color: moroccoRed, // Red for security
                    onTap: () {
                      // TODO: Show password change dialog
                    },
                  ),

                  // Notifications Switch
                  _switchTile(
                    title: "Notifications",
                    icon: Icons.notifications_active_outlined,
                    value: _notificationsEnabled,
                    color: moroccoGreen,
                    onChanged: (val) {
                      setState(() => _notificationsEnabled = val);
                    },
                  ),

                  const SizedBox(height: 25),

                  // --- SECTION: SUPPORT ---
                  _sectionTitle("SUPPORT"),
                  
                  _clickableTile(
                    title: "Aide & Support",
                    icon: Icons.help_outline,
                    color: Colors.grey.shade700,
                    onTap: () {},
                  ),
                  _clickableTile(
                    title: "À propos de nous",
                    icon: Icons.info_outline,
                    color: Colors.grey.shade700,
                    onTap: () {},
                  ),

                  const SizedBox(height: 30),

                  // --- SAVE BUTTON ---
                  SizedBox(
                    width: double.infinity,
                    height: 55,
                    child: ElevatedButton(
                      onPressed: () {
                        // TODO: Save logic here
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: moroccoGreen,
                        foregroundColor: Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(15),
                        ),
                        elevation: 5,
                        shadowColor: moroccoGreen.withOpacity(0.4),
                      ),
                      child: const Text(
                        "ENREGISTRER LES MODIFICATIONS",
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                          letterSpacing: 1,
                        ),
                      ),
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

  // ----------------- WIDGETS -----------------

  Widget _sectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.only(left: 5, bottom: 15),
      child: Text(
        title,
        style: TextStyle(
          fontSize: 12,
          fontWeight: FontWeight.bold,
          color: Colors.grey.shade500,
          letterSpacing: 1.2,
        ),
      ),
    );
  }

  // 1. Text Input Field
  Widget _inputField(
      String label, IconData icon, TextEditingController controller, Color accentColor,
      {bool isEmail = false, bool isPhone = false}) {
    return Container(
      margin: const EdgeInsets.only(bottom: 15),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(15),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.05),
            spreadRadius: 2,
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: TextField(
        controller: controller,
        keyboardType: isEmail
            ? TextInputType.emailAddress
            : (isPhone ? TextInputType.phone : TextInputType.text),
        decoration: InputDecoration(
          labelText: label,
          labelStyle: TextStyle(color: Colors.grey.shade500, fontSize: 14),
          prefixIcon: Icon(icon, color: accentColor.withOpacity(0.7), size: 22),
          border: InputBorder.none,
          contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(15),
            borderSide: BorderSide.none,
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(15),
            borderSide: BorderSide(color: accentColor, width: 1.5),
          ),
        ),
      ),
    );
  }

  // 2. Clickable Tile (Password, Help, About)
  Widget _clickableTile({
    required String title,
    String? subtitle,
    required IconData icon,
    required Color color,
    required VoidCallback onTap,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(15),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.05),
            spreadRadius: 2,
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: ListTile(
        onTap: onTap,
        leading: Container(
          padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(
            color: color.withOpacity(0.1),
            borderRadius: BorderRadius.circular(10),
          ),
          child: Icon(icon, color: color, size: 22),
        ),
        title: Text(
          title,
          style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 15),
        ),
        subtitle: subtitle != null
            ? Text(subtitle, style: TextStyle(fontSize: 12, color: Colors.grey.shade400))
            : null,
        trailing: Icon(Icons.arrow_forward_ios, size: 16, color: Colors.grey.shade300),
      ),
    );
  }

  // 3. Switch Tile (Notifications)
  Widget _switchTile({
    required String title,
    required IconData icon,
    required bool value,
    required Color color,
    required Function(bool) onChanged,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(15),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.05),
            spreadRadius: 2,
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: ListTile(
        leading: Container(
          padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(
            color: color.withOpacity(0.1),
            borderRadius: BorderRadius.circular(10),
          ),
          child: Icon(icon, color: color, size: 22),
        ),
        title: Text(
          title,
          style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 15),
        ),
        trailing: Switch(
          value: value,
          activeColor: Colors.white,
          activeTrackColor: color,
          onChanged: onChanged,
        ),
      ),
    );
  }
}

// ----------------- CLIPPER CLASS -----------------
class StadiumWaveClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    var path = Path();
    path.lineTo(0, size.height - 60);
    var firstControlPoint = Offset(size.width / 4, size.height);
    var firstEndPoint = Offset(size.width / 2.25, size.height - 40);
    path.quadraticBezierTo(firstControlPoint.dx, firstControlPoint.dy,
        firstEndPoint.dx, firstEndPoint.dy);
    var secondControlPoint =
        Offset(size.width - (size.width / 3.25), size.height - 90);
    var secondEndPoint = Offset(size.width, size.height - 50);
    path.quadraticBezierTo(secondControlPoint.dx, secondControlPoint.dy,
        secondEndPoint.dx, secondEndPoint.dy);
    path.lineTo(size.width, size.height - 40);
    path.lineTo(size.width, 0);
    path.close();
    return path;
  }
  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) => false;
}