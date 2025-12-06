import 'package:flutter/material.dart';

// -----------------------------------------------------------
// IMPORTS (Checked against your file structure screenshot)
// -----------------------------------------------------------
import 'Stades.dart';
// import 'Trajet.dart'; 

import '../Hiba_Front/Reservation.dart';
import '../Hiba_Front/Evaluation.dart';
import '../Mohammed_Front/Parametres.dart';
import '../Mohammed_Front/Profile.dart';
import '../Rachid_Front/Aide.dart';
import '../Rachid_Front/aboutus.dart'; // Note: your file is lowercase 'aboutus.dart'

class SupporteurAcceuil extends StatelessWidget {
  const SupporteurAcceuil({super.key});

  final List<MenuItem> menuItems = const [
    MenuItem(
        icon: Icons.directions_bus_filled,
        title: "Trajets",
        subtitle: "Voir les trajets disponibles"),
    MenuItem(
        icon: Icons.stadium,
        title: "Stades",
        subtitle: "Liste des stades ajoutés"),
    MenuItem(
        icon: Icons.book_online,
        title: "Réservations",
        subtitle: "Mes réservations"),
    MenuItem(
        icon: Icons.star_rate,
        title: "Évaluations",
        subtitle: "Voir ou ajouter une évaluation"),
    MenuItem(
        icon: Icons.person,
        title: "Profile",
        subtitle: "Consulter votre Profile"),
    MenuItem(
        icon: Icons.settings,
        title: "Parametres",
        subtitle: "Modifier profil & préférences"),
    MenuItem(
        icon: Icons.help_outline, 
        title: "Aide", 
        subtitle: "About Us & FAQ"),
  ];

  @override
  Widget build(BuildContext context) {
    const Color moroccoRed = Color(0xFFC1272D);
    const Color darkRed = Color(0xFF8A1C21);
    const Color moroccoGreen = Color(0xFF006233);

    return Scaffold(
      backgroundColor: Colors.grey.shade50,
      body: Column(
        children: [
          // ----------------- HEADER (WAVE DESIGN) -----------------
          Stack(
            children: [
              ClipPath(
                clipper: StadiumWaveClipper(),
                child: Container(
                  height: 200,
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
                top: -30, right: -30,
                child: CircleAvatar(radius: 70, backgroundColor: Colors.white.withOpacity(0.05)),
              ),
              SafeArea(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                           const Text("Bienvenue Supporter ⚽", style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: Colors.white)),
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                            decoration: BoxDecoration(color: Colors.white.withOpacity(0.2), borderRadius: BorderRadius.circular(15)),
                            child: const Text("AFCON 2025", style: TextStyle(color: Colors.white, fontSize: 10, fontWeight: FontWeight.bold)),
                          )
                        ],
                      ),
                      const SizedBox(height: 10),
                      const Text("Gérez vos trajets et réservations.", style: TextStyle(color: Colors.white70, fontSize: 14)),
                    ],
                  ),
                ),
              ),
            ],
          ),

          // ----------------- INFO TEXT (UPDATED) -----------------
          // Replaced the generic "i" with a Ticket Icon + Clean Text
          Padding(
            padding: const EdgeInsets.fromLTRB(20, 10, 20, 20),
            child: Row(
              children: [
                // Change: Ticket icon looks more relevant than 'info'
                Icon(Icons.local_activity_outlined, color: moroccoGreen, size: 26),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    "Réservez vos trajets et suivez tous les événements facilement.",
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.grey.shade800,
                      fontWeight: FontWeight.w600, // Slightly bolder for readability
                      height: 1.3,
                    ),
                  ),
                ),
              ],
            ),
          ),

          // ----------------- MENU LIST -----------------
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.only(top: 0, left: 16, right: 16, bottom: 20),
              itemCount: menuItems.length,
              itemBuilder: (context, index) {
                final item = menuItems[index];
                return SupporterMenuTile(
                  icon: item.icon,
                  title: item.title,
                  subtitle: item.subtitle,
                  accentColor: moroccoGreen,
                  onTap: () => _navigateToPage(context, item.title),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  // ----------------- NAVIGATION -----------------
  void _navigateToPage(BuildContext context, String title) {
    switch (title) {
      
      case "Stades":
        Navigator.push(context, MaterialPageRoute(builder: (_) => const StadesPage()));
        break;

      case "Réservations":
        Navigator.push(context, MaterialPageRoute(builder: (_) => const ReservationPage()));
        break;

      case "Évaluations":
        Navigator.push(context, MaterialPageRoute(builder: (_) => const EvaluationPage()));
        break;
      
      case "Profile":
        Navigator.push(context, MaterialPageRoute(builder: (_) => const ProfilePage()));
        break;

      case "Parametres":
        Navigator.push(context, MaterialPageRoute(builder: (_) => const ParametresPage()));
        break;
      
      case "Aide":
         Navigator.push(context, MaterialPageRoute(builder: (_) => const AidePage()));
         break;
      
      default:
        Navigator.push(context, MaterialPageRoute(builder: (_) => PlaceholderPage(title: title)));
        break;
    }
  }
}

// ---------------------- MODELS & WIDGETS ----------------------

class MenuItem {
  final IconData icon;
  final String title;
  final String subtitle;
  const MenuItem({required this.icon, required this.title, required this.subtitle});
}

class SupporterMenuTile extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;
  final Color accentColor;
  final VoidCallback onTap;
  const SupporterMenuTile({super.key, required this.icon, required this.title, required this.subtitle, required this.accentColor, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey.shade100),
        boxShadow: [BoxShadow(color: Colors.grey.withOpacity(0.05), spreadRadius: 1, blurRadius: 5, offset: const Offset(0, 2))],
      ),
      child: ListTile(
        leading: Icon(icon, size: 28, color: accentColor),
        title: Text(title, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15)),
        subtitle: Text(subtitle, style: const TextStyle(fontSize: 12)),
        trailing: Icon(Icons.arrow_forward_ios, size: 14, color: Colors.grey.shade400),
        onTap: onTap,
      ),
    );
  }
}

class StadiumWaveClipper extends CustomClipper<Path> {
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

class PlaceholderPage extends StatelessWidget {
  final String title;
  const PlaceholderPage({super.key, required this.title});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(title), backgroundColor: const Color(0xFFC1272D)),
      body: Center(child: Text("Page '$title' en construction...")),
    );
  }
}