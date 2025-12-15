import 'package:flutter/material.dart';

// -----------------------------------------------------------
// IMPORTS
// -----------------------------------------------------------
import 'Stades.dart';
// NOUVEL IMPORT: Importation de la page de suivi

import '../Hiba_Front/Reservation.dart';
import '../Hiba_Front/Evaluation.dart';
import '../Mohammed_Front/Parametres.dart';
import '../Mohammed_Front/Profile.dart';
import '../Rachid_Front/Aide.dart';
import '../Rachid_Front/aboutus.dart';
import '../Sara_Front/Suivie.dart';

class SupporteurAcceuil extends StatelessWidget {
  const SupporteurAcceuil({super.key});

  // LISTE MISE À JOUR : 'Trajets' remplacé par 'Suivi des Matchs'
  final List<MenuItem> menuItems = const [
    MenuItem(
        // Icône et titre mis à jour pour 'Suivi des Matchs'
        icon: Icons.live_tv_rounded, 
        title: "Suivi des Matchs",
        subtitle: "Matchs en direct et à venir"),
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
    
    // Ajout de la logique Dark Mode pour les couleurs de la tuile et du texte
    final bool isDark = Theme.of(context).brightness == Brightness.dark;
    final Color cardColor = isDark ? const Color(0xFF1E1E1E) : Colors.white;
    final Color textColor = Theme.of(context).textTheme.bodyLarge!.color!;


    return Scaffold(
      // Utilisation du fond d'écran dynamique
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
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

          // ----------------- INFO TEXT (Adapté au Dark Mode) -----------------
          Padding(
            padding: const EdgeInsets.fromLTRB(20, 10, 20, 20),
            child: Row(
              children: [
                Icon(Icons.local_activity_outlined, color: moroccoGreen, size: 26),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    "Réservez vos trajets et suivez tous les événements facilement.",
                    style: TextStyle(
                      fontSize: 14,
                      // Couleur dynamique du texte
                      color: isDark ? Colors.white70 : Colors.grey.shade800, 
                      fontWeight: FontWeight.w600,
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
                  // Passage des couleurs dynamiques au widget SupporterMenuTile
                  cardColor: cardColor, 
                  textColor: textColor,
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
      
      // CAS MIS À JOUR: Navigue vers SuiviPage
      
      case "Suivi des Matchs":
        Navigator.push(context, MaterialPageRoute(builder: (_) => const SuiviPage()));
        break;

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
  final Color cardColor; // Ajouté pour le Dark Mode
  final Color textColor; // Ajouté pour le Dark Mode
  final VoidCallback onTap;
  
  const SupporterMenuTile({
    super.key, required this.icon, required this.title, required this.subtitle, 
    required this.accentColor, required this.onTap, required this.cardColor, required this.textColor
  });

  @override
  Widget build(BuildContext context) {
    // Vérifie si le mode sombre est actif pour ajuster les couleurs de bordure
    final bool isDark = Theme.of(context).brightness == Brightness.dark;
    
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: cardColor, // Couleur dynamique
        borderRadius: BorderRadius.circular(12),
        // Bordure uniquement en mode clair pour un look plus net en mode sombre
        border: isDark ? null : Border.all(color: Colors.grey.shade100),
        boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.05), spreadRadius: 1, blurRadius: 5, offset: const Offset(0, 2))],
      ),
      child: ListTile(
        leading: Icon(icon, size: 28, color: accentColor),
        title: Text(title, style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15, color: textColor)), // Couleur dynamique
        subtitle: Text(subtitle, style: const TextStyle(fontSize: 12, color: Colors.grey)), 
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