import 'package:flutter/material.dart';

/// -----------------------------------------------
/// CLASS HomePage
/// -----------------------------------------------
class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: const [
              HeaderSection(),
              SizedBox(height: 25),

              // Title & Description
              Text(
                "Bienvenue sur\nTransport CAN 2025",
                style: TextStyle(fontSize: 26, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 10),
              Text(
                "Votre guide intelligent pour les déplacements pendant la compétition.",
                style: TextStyle(fontSize: 14, color: Colors.black54),
              ),
              SizedBox(height: 30),

              // Menu buttons section
              MenuButton(icon: Icons.map, text: "Carte interactive"),
              MenuButton(icon: Icons.access_time, text: "Horaires"),
              MenuButton(icon: Icons.stadium, text: "Stades"),
              MenuButton(icon: Icons.alt_route, text: "Itinéraires"),
              MenuButton(icon: Icons.notifications, text: "Notifications"),

              SizedBox(height: 30),

              LanguageSwitcher(),
            ],
          ),
        ),
      ),
    );
  }
}

/// -----------------------------------------------
/// CLASS HeaderSection
/// -----------------------------------------------
class HeaderSection extends StatelessWidget {
  const HeaderSection({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        // LOGO + TEXT
        Row(
          children: [
            Icon(Icons.sports_soccer, size: 45, color: Colors.green),
            const SizedBox(width: 10),

            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: const [
                Text(
                  "CAN 2025",
                  style: TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                    color: Colors.green,
                  ),
                ),
                Text(
                  "MAROC",
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.red,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ],
        ),

        // FLAG
        Container(
          width: 40,
          height: 25,
          decoration: BoxDecoration(
            color: Colors.red,
            borderRadius: BorderRadius.circular(4),
          ),
          child: const Icon(Icons.star, size: 18, color: Colors.green),
        ),
      ],
    );
  }
}

/// -----------------------------------------------
/// CLASS MenuButton
/// -----------------------------------------------
class MenuButton extends StatelessWidget {
  final IconData icon;
  final String text;

  const MenuButton({super.key, required this.icon, required this.text});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 15),
      padding: const EdgeInsets.symmetric(vertical: 18, horizontal: 15),
      decoration: BoxDecoration(
        color: Colors.green.shade50,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.green.shade200),
      ),
      child: Row(
        children: [
          Icon(icon, color: Colors.green, size: 28),
          const SizedBox(width: 15),
          Text(
            text,
            style: const TextStyle(
              fontSize: 16,
              color: Colors.green,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }
}

/// -----------------------------------------------
/// CLASS LanguageSwitcher
/// -----------------------------------------------
class LanguageSwitcher extends StatelessWidget {
  const LanguageSwitcher({super.key});

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text("FR", style: TextStyle(fontWeight: FontWeight.bold)),
          SizedBox(width: 30),
          Text("AR", style: TextStyle(color: Colors.black45)),
          SizedBox(width: 30),
          Text("EN", style: TextStyle(color: Colors.black45)),
        ],
      ),
    );
  }
}
