import 'package:flutter/material.dart';

// -------------------------------------
// IMPORT YOUR REAL PAGES HERE
// -------------------------------------
import 'Stades.dart';
import 'Trajet.dart';
import '../Hiba_Front/Reservation.dart';
import '../Hiba_Front/Evaluation.dart';
import '../Mohammed_Front/Parametres.dart';
import '../Mohammed_Front/Profile.dart';
import '../Rachid_Front/Aide.dart';
import '../Rachid_Front/aboutus.dart';

/// ------------------------------------------------------------
///  SUPPORTER HOME PAGE
/// ------------------------------------------------------------
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
        icon: Icons.car_crash_outlined,
        title: "Parametres",
        subtitle: "Voir Parametres "),
    MenuItem(
        icon: Icons.car_crash_outlined, title: "Aide ", subtitle: " About Us"),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text("Accueil Supporter",
            style: TextStyle(fontWeight: FontWeight.bold)),
        centerTitle: true,
        backgroundColor: Colors.blue,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              "Bienvenue Supporter ⚽",
              style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 15),
            _buildInfoCard(),
            const SizedBox(height: 20),
            const Text("Menu Principal",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600)),
            const SizedBox(height: 10),
            Expanded(
              child: ListView.builder(
                itemCount: menuItems.length,
                itemBuilder: (context, index) {
                  final item = menuItems[index];
                  return SupporterMenuTile(
                    icon: item.icon,
                    title: item.title,
                    subtitle: item.subtitle,
                    onTap: () => _navigateToPage(context, item.title),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoCard() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.blue.withOpacity(0.12),
        borderRadius: BorderRadius.circular(15),
      ),
      child: const Row(
        children: [
          Icon(Icons.sports_soccer, color: Colors.blue, size: 40),
          SizedBox(width: 12),
          Expanded(
            child: Text(
              "Réservez vos trajets, achetez vos tickets et suivez tous les événements facilement.",
              style: TextStyle(fontSize: 15),
            ),
          ),
        ],
      ),
    );
  }

  /// -------------------------------------
  /// NAVIGATION FUNCTION (IMPORTANT)
  /// -------------------------------------
  void _navigateToPage(BuildContext context, String title) {
    switch (title) {
      case "Stades":
        Navigator.push(
            context, MaterialPageRoute(builder: (_) => const StadesPage()));
        break;
      //  Here we gonna put  the other pages just Like The Stade page using The switch
      default:
        Navigator.push(context,
            MaterialPageRoute(builder: (_) => PlaceholderPage(title: title)));
        break;
    }
  }
}

/// ----------------------
/// MENU ITEM MODEL (POO)
/// ----------------------
class MenuItem {
  final IconData icon;
  final String title;
  final String subtitle;

  const MenuItem({
    required this.icon,
    required this.title,
    required this.subtitle,
  });
}

/// ----------------------
/// TILE WIDGET
/// ----------------------
class SupporterMenuTile extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;
  final VoidCallback onTap;

  const SupporterMenuTile({
    super.key,
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 1,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      margin: const EdgeInsets.symmetric(vertical: 6),
      child: ListTile(
        leading: Icon(icon, size: 32, color: Colors.blue),
        title: Text(title, style: const TextStyle(fontWeight: FontWeight.bold)),
        subtitle: Text(subtitle),
        onTap: onTap,
      ),
    );
  }
}

/// ----------------------
/// PLACEHOLDER PAGE
/// ----------------------
class PlaceholderPage extends StatelessWidget {
  final String title;

  const PlaceholderPage({super.key, required this.title});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(title),
        backgroundColor: Colors.blue,
      ),
      body: Center(
        child: Text(
          "Page '$title' sera créée bientôt.",
          style: const TextStyle(fontSize: 18),
        ),
      ),
    );
  }
}
