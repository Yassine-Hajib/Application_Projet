import 'package:flutter/material.dart';

class ChauffeurAcceuil extends StatelessWidget {
  const ChauffeurAcceuil({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Chauffeur Panel"),
        centerTitle: true,
        backgroundColor: Colors.green,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              "Bonjour Chauffeur 🚐",
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 20),
            _infoCard(),
            const SizedBox(height: 20),
            Expanded(
              child: ListView(
                children: const [
                  ChauffeurActionTile(
                    icon: Icons.play_circle_fill,
                    title: "Start Route",
                    subtitle: "Commencer votre tournée",
                  ),
                  ChauffeurActionTile(
                    icon: Icons.location_on,
                    title: "Current Position",
                    subtitle: "Afficher votre localisation",
                  ),
                  ChauffeurActionTile(
                    icon: Icons.timer,
                    title: "Working Hours",
                    subtitle: "Voir heures travaillées",
                  ),
                  ChauffeurActionTile(
                    icon: Icons.logout,
                    title: "Logout",
                    subtitle: "Déconnexion",
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _infoCard() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.green.withOpacity(0.12),
        borderRadius: BorderRadius.circular(18),
      ),
      child: const Row(
        children: [
          Icon(Icons.person, size: 40, color: Colors.green),
          SizedBox(width: 15),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "Today's Route: Line 12",
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
              ),
              Text("Next Stop: Station Centre", style: TextStyle(fontSize: 14)),
            ],
          ),
        ],
      ),
    );
  }
}

class ChauffeurActionTile extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;

  const ChauffeurActionTile({
    super.key,
    required this.icon,
    required this.title,
    required this.subtitle,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      child: ListTile(
        leading: Icon(icon, size: 32, color: Colors.green),
        title: Text(title, style: const TextStyle(fontWeight: FontWeight.bold)),
        subtitle: Text(subtitle),
        onTap: () {},
      ),
    );
  }
}
