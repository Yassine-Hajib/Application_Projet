import 'package:flutter/material.dart';

/// ------------------------------------------------------------
///  SUPPORTER HOME PAGE
/// ------------------------------------------------------------
/// This page serves as a dashboard for the supporter.
/// It uses POO, is clean, commented, and easy to edit.
/// Each menu item navigates to a placeholder page
/// for now (can be replaced later by real pages).
/// ------------------------------------------------------------

class SupporteurAcceuil extends StatelessWidget {
  const SupporteurAcceuil({super.key});

  /// -----------------------------
  /// Dummy list of menu items
  /// -----------------------------
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
        icon: Icons.event_available,
        title: "Événements",
        subtitle: "Voir les matchs et événements"),
    MenuItem(
        icon: Icons.book_online,
        title: "Réservations",
        subtitle: "Mes réservations"),
    MenuItem(
        icon: Icons.confirmation_number,
        title: "Tickets",
        subtitle: "Mes tickets"),
    MenuItem(
        icon: Icons.star_rate,
        title: "Évaluations",
        subtitle: "Voir ou ajouter une évaluation"),
    MenuItem(
        icon: Icons.person,
        title: "Chauffeurs",
        subtitle: "Consulter les chauffeurs"),
    MenuItem(
        icon: Icons.car_crash_outlined,
        title: "Véhicules",
        subtitle: "Voir les véhicules"),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      
      appBar: AppBar(
        title: const Text(
          "Accueil Supporter",
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
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
              style: TextStyle(
                fontSize: 25,
                fontWeight: FontWeight.bold,
              ),
            ),

            const SizedBox(height: 15),

            // -----------------------------
            // Intro Info Card
            // -----------------------------
            _buildInfoCard(),

            const SizedBox(height: 20),

            const Text(
              "Menu Principal",
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w600,
              ),
            ),

            const SizedBox(height: 10),

            // -----------------------------
            // Menu List
            // -----------------------------
            Expanded(
              child: ListView.builder(
                itemCount: menuItems.length,
                itemBuilder: (context, index) {
                  final item = menuItems[index];
                  return SupporterMenuTile(
                    icon: item.icon,
                    title: item.title,
                    subtitle: item.subtitle,
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  /// -----------------------------
  /// Simple welcome card
  /// -----------------------------
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
}

/// ------------------------------------------------------------
///  MENU ITEM MODEL
///  Simple POO class to store menu information
/// ------------------------------------------------------------
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

/// ------------------------------------------------------------
///  MENU TILE WIDGET
///  Reusable for each menu entry
/// ------------------------------------------------------------
class SupporterMenuTile extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;

  const SupporterMenuTile({
    super.key,
    required this.icon,
    required this.title,
    required this.subtitle,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 1,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      margin: const EdgeInsets.symmetric(vertical: 6),

      child: ListTile(
        leading: Icon(icon, size: 32, color: Colors.blue),
        title: Text(
          title,
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        subtitle: Text(subtitle),

        // Navigate to a placeholder page for now
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => PlaceholderPage(title: title),
            ),
          );
        },
      ),
    );
  }
}

/// ------------------------------------------------------------
///  PLACEHOLDER PAGE
///  To be replaced by real pages in the future
/// ------------------------------------------------------------
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
          "Page '$title' sera créée par votre équipe.",
          style: const TextStyle(fontSize: 18),
          textAlign: TextAlign.center,
        ),
      ),
    );
  }
}
