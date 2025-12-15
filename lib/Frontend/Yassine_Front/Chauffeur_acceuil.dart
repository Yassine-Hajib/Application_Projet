import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../Yassine_Front/Login.dart'; // To handle logout

class ChauffeurHomePage extends StatefulWidget {
  const ChauffeurHomePage({super.key});

  @override
  State<ChauffeurHomePage> createState() => _ChauffeurHomePageState();
}

class _ChauffeurHomePageState extends State<ChauffeurHomePage> {
  // ---------------- COLORS ----------------
  final Color moroccoRed = const Color(0xFFC1272D);
  final Color moroccoGreen = const Color(0xFF006233);

  // ---------------- MOCK DATA ----------------
  List<Map<String, dynamic>> tripOffers = [
    {
      'id': 1,
      'clientName': 'Yassine Bounou',
      'tripDetails': 'Hôtel -> Stade de Marrakech (Match 20:00)',
      'date': '2025-01-15',
      'status': 'pending', 
    },
    {
      'id': 2,
      'clientName': 'Achraf Hakimi',
      'tripDetails': 'Aéroport MV -> Centre Ville Casablanca',
      'date': '2025-01-16',
      'status': 'pending',
    },
  ];

  List<Map<String, dynamic>> acceptedTrips = [
    {
      'id': 3,
      'clientName': 'Walid Regragui',
      'tripDetails': 'Stade -> Aéroport',
      'date': '2025-01-14',
      'status': 'completed',
    },
  ];

  double totalEarnings = 1250.0; 

  // ---------------- LOGIC ----------------
  void acceptOffer(int offerId) {
    setState(() {
      var offer = tripOffers.firstWhere((o) => o['id'] == offerId);
      offer['status'] = 'accepted';
      // Move to accepted list logic here in real app
    });
    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Course acceptée !'), backgroundColor: Colors.green));
  }

  void declineOffer(int offerId) {
    setState(() {
      var offer = tripOffers.firstWhere((o) => o['id'] == offerId);
      offer['status'] = 'declined';
    });
    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Course refusée.'), backgroundColor: Colors.red));
  }

  Future<void> _logout() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.clear();
    if(mounted) {
      Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (_) => const LoginPage()), (route) => false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade50,
      appBar: AppBar(
        title: const Text('Espace Chauffeur', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20)),
        backgroundColor: moroccoRed,
        foregroundColor: Colors.white,
        elevation: 0,
        actions: [
          IconButton(
            icon: const Icon(Icons.notifications_outlined),
            onPressed: () {},
          ),
        ],
      ),
      drawer: _buildDrawer(),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // EARNINGS CARD
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                gradient: LinearGradient(colors: [moroccoGreen, const Color(0xFF004D25)]),
                borderRadius: BorderRadius.circular(15),
                boxShadow: [BoxShadow(color: moroccoGreen.withOpacity(0.3), blurRadius: 10, offset: const Offset(0, 5))],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text("Gains du mois", style: TextStyle(color: Colors.white70, fontSize: 14)),
                  const SizedBox(height: 5),
                  Text("${totalEarnings.toStringAsFixed(2)} MAD", style: const TextStyle(color: Colors.white, fontSize: 28, fontWeight: FontWeight.bold)),
                ],
              ),
            ),
            
            const SizedBox(height: 25),
            
            // OFFERS SECTION
            const Text('Nouvelles Offres', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.black87)),
            const SizedBox(height: 10),
            
            ...tripOffers.where((o) => o['status'] == 'pending').map((offer) {
              return _buildOfferCard(offer);
            }).toList(),

            if(tripOffers.where((o) => o['status'] == 'pending').isEmpty)
              const Padding(
                padding: EdgeInsets.all(20),
                child: Center(child: Text("Aucune offre pour le moment.", style: TextStyle(color: Colors.grey))),
              ),

            const SizedBox(height: 25),

            // HISTORY SECTION
            const Text('Historique Récent', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.black87)),
            const SizedBox(height: 10),
            ...acceptedTrips.map((trip) => _buildHistoryCard(trip)).toList(),
          ],
        ),
      ),
    );
  }

  // ---------------- WIDGETS ----------------

  Widget _buildDrawer() {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: <Widget>[
          UserAccountsDrawerHeader(
            decoration: BoxDecoration(color: moroccoRed),
            accountName: const Text("Chauffeur AFCON", style: TextStyle(fontWeight: FontWeight.bold)),
            accountEmail: const Text("chauffeur@afcon2025.ma"),
            currentAccountPicture: const CircleAvatar(
              backgroundColor: Colors.white,
              child: Icon(Icons.person, color: Color(0xFFC1272D)),
            ),
          ),
          ListTile(leading: const Icon(Icons.dashboard), title: const Text('Tableau de bord'), onTap: () => Navigator.pop(context)),
          ListTile(leading: const Icon(Icons.directions_car), title: const Text('Mes Véhicules'), onTap: () {}),
          ListTile(leading: const Icon(Icons.history), title: const Text('Historique'), onTap: () {}),
          const Divider(),
          ListTile(
            leading: const Icon(Icons.logout, color: Colors.red), 
            title: const Text('Déconnexion', style: TextStyle(color: Colors.red)), 
            onTap: _logout
          ),
        ],
      ),
    );
  }

  Widget _buildOfferCard(Map<String, dynamic> offer) {
    return Card(
      elevation: 3,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      margin: const EdgeInsets.only(bottom: 15),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(offer['clientName'], style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(color: Colors.orange.withOpacity(0.1), borderRadius: BorderRadius.circular(8)),
                  child: const Text("En attente", style: TextStyle(color: Colors.orange, fontSize: 12, fontWeight: FontWeight.bold)),
                )
              ],
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                const Icon(Icons.location_on, size: 16, color: Colors.grey),
                const SizedBox(width: 5),
                Expanded(child: Text(offer['tripDetails'], style: const TextStyle(color: Colors.grey))),
              ],
            ),
            const SizedBox(height: 5),
            Row(
              children: [
                const Icon(Icons.calendar_today, size: 16, color: Colors.grey),
                const SizedBox(width: 5),
                Text(offer['date'], style: const TextStyle(color: Colors.grey)),
              ],
            ),
            const SizedBox(height: 15),
            Row(
              children: [
                Expanded(
                  child: OutlinedButton(
                    onPressed: () => declineOffer(offer['id']),
                    style: OutlinedButton.styleFrom(foregroundColor: Colors.red, side: const BorderSide(color: Colors.red)),
                    child: const Text("REFUSER"),
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: ElevatedButton(
                    onPressed: () => acceptOffer(offer['id']),
                    style: ElevatedButton.styleFrom(backgroundColor: moroccoGreen, foregroundColor: Colors.white),
                    child: const Text("ACCEPTER"),
                  ),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }

  Widget _buildHistoryCard(Map<String, dynamic> trip) {
    return Card(
      elevation: 0,
      color: Colors.grey.shade100,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      margin: const EdgeInsets.only(bottom: 10),
      child: ListTile(
        leading: CircleAvatar(backgroundColor: Colors.grey.shade300, child: const Icon(Icons.check, color: Colors.black54)),
        title: Text(trip['clientName'], style: const TextStyle(fontWeight: FontWeight.bold)),
        subtitle: Text(trip['date']),
        trailing: const Text("Complété", style: TextStyle(color: Colors.green, fontWeight: FontWeight.bold, fontSize: 12)),
      ),
    );
  }
}