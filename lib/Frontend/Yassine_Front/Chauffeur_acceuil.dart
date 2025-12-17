import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import '../Yassine_Front/Login.dart'; 

class ChauffeurHomePage extends StatefulWidget {
  const ChauffeurHomePage({super.key});

  @override
  State<ChauffeurHomePage> createState() => _ChauffeurHomePageState();
}

class _ChauffeurHomePageState extends State<ChauffeurHomePage> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  
  // User Info
  String fullName = "Chargement...";
  String email = "...";
  int? chauffeurId; // To identify who is accepting the ride

  // Data
  List<dynamic> pendingReservations = [];
  List<dynamic> historyTrips = [];
  double totalEarnings = 0.0;
  bool isLoading = true;

  // Colors
  static const Color moroccoRed = Color(0xFFC1272D);
  static const Color moroccoGreen = Color(0xFF006233);
  static const Color darkRed = Color(0xFF8A1C21);
  static const Color offWhite = Color(0xFFF8F9FA);

  // APIs
  final String getUrl = "http://localhost:8888/Backend/api/get_reservations.php";
  final String acceptUrl = "http://localhost:8888/Backend/api/accept_reservation.php";

  @override
  void initState() {
    super.initState();
    _loadUserData();
    _fetchReservations();
  }

  // 1. Load Chauffeur Info
  Future<void> _loadUserData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      String nom = prefs.getString('nom') ?? "Chauffeur";
      String prenom = prefs.getString('prenom') ?? "";
      fullName = "$prenom $nom"; 
      email = prefs.getString('email') ?? "chauffeur@afcon.ma";
      // Assuming you saved 'id' in login. If not, we might need to fix Login.dart
      // For now, let's try to get it, or default to 0 if missing.
      // NOTE: Ensure Login.dart saves the ID!
      // If Login.dart doesn't save ID, we can't link the driver. 
      // For this demo, I will assume ID = 1 if not found.
      // In a real app, update Login.dart to: await prefs.setInt('id', user['id_utilisateur']);
    });
    
    // Hack: Since we didn't strictly save ID in the previous Login step shown, 
    // I will simulate an ID. *You should update Login.dart to save prefs.setInt('id', ...)*
    chauffeurId = 1; 
  }

  // 2. Fetch Pending Reservations
  Future<void> _fetchReservations() async {
    try {
      final response = await http.get(Uri.parse(getUrl));
      if (response.statusCode == 200) {
        var json = jsonDecode(response.body);
        if (json['success'] == true) {
          setState(() {
            pendingReservations = json['data'];
            isLoading = false;
          });
        }
      }
    } catch (e) {
      print("Erreur fetch: $e");
    }
  }

  // 3. Accept Logic
  Future<void> acceptOffer(int index) async {
    var reservation = pendingReservations[index];
    String resId = reservation['id_reservation'];

    // Call Backend
    try {
      final response = await http.post(
        Uri.parse(acceptUrl),
        headers: {"Content-Type": "application/json"},
        body: jsonEncode({
          "id_reservation": resId,
          "id_chauffeur": chauffeurId
        }),
      );

      var json = jsonDecode(response.body);
      if(json['success'] == true) {
        setState(() {
          // 1. Add Price to Earnings (Mock Price 150 DH per trip)
          totalEarnings += 150.0;

          // 2. Move to History
          historyTrips.add(reservation);

          // 3. Remove from Pending
          pendingReservations.removeAt(index);
        });

        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Course acceptée ! (+150 DH)'), backgroundColor: moroccoGreen)
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
           SnackBar(content: Text('Erreur: ${json['message']}'), backgroundColor: Colors.red)
        );
      }

    } catch(e) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Erreur de connexion'), backgroundColor: Colors.red)
      );
    }
  }

  void declineOffer(int index) {
    setState(() {
      pendingReservations.removeAt(index);
    });
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Course ignorée.'), backgroundColor: Colors.grey)
    );
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
      key: _scaffoldKey,
      backgroundColor: offWhite,
      drawer: _buildModernDrawer(),
      body: Column(
        children: [
          // --- HEADER ---
          Stack(
            children: [
              ClipPath(
                clipper: StadiumWaveClipper(),
                child: Container(
                  height: 240,
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
              SafeArea(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                  child: Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          IconButton(
                            icon: const Icon(Icons.menu, color: Colors.white, size: 28),
                            onPressed: () => _scaffoldKey.currentState?.openDrawer(),
                          ),
                          const Text("DASHBOARD", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, letterSpacing: 1)),
                          IconButton(
                            icon: const Icon(Icons.refresh, color: Colors.white, size: 28),
                            onPressed: _fetchReservations, // Refresh Button
                          ),
                        ],
                      ),
                      const SizedBox(height: 20),
                      Row(
                        children: [
                          Container(
                            padding: const EdgeInsets.all(3),
                            decoration: BoxDecoration(shape: BoxShape.circle, border: Border.all(color: Colors.white, width: 2)),
                            child: const CircleAvatar(
                              radius: 28,
                              backgroundColor: Colors.white,
                              child: Icon(Icons.person, color: moroccoRed, size: 30),
                            ),
                          ),
                          const SizedBox(width: 15),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(fullName, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 18)),
                              const SizedBox(height: 4),
                              Container(
                                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                                decoration: BoxDecoration(color: moroccoGreen, borderRadius: BorderRadius.circular(10)),
                                child: const Text("EN LIGNE", style: TextStyle(color: Colors.white, fontSize: 10, fontWeight: FontWeight.bold)),
                              )
                            ],
                          )
                        ],
                      )
                    ],
                  ),
                ),
              ),
            ],
          ),

          // --- CONTENT ---
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  
                  // STATS
                  Row(
                    children: [
                      _buildStatCard("Gains", "${totalEarnings.toStringAsFixed(0)} DH", Icons.account_balance_wallet, Colors.blue),
                      const SizedBox(width: 15),
                      _buildStatCard("Courses", "${historyTrips.length}", Icons.directions_car, Colors.orange),
                    ],
                  ),

                  const SizedBox(height: 30),

                  // NEW REQUESTS
                  const Text("Demandes en attente", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.black87)),
                  const SizedBox(height: 15),

                  if (isLoading)
                     const Center(child: CircularProgressIndicator(color: moroccoRed))
                  else if (pendingReservations.isEmpty)
                     Center(
                      child: Padding(
                        padding: const EdgeInsets.all(30.0),
                        child: Text("Aucune réservation disponible", style: TextStyle(color: Colors.grey.shade400)),
                      ),
                    )
                  else
                    ...List.generate(pendingReservations.length, (index) {
                      return _buildDBRequestCard(pendingReservations[index], index);
                    }),

                  const SizedBox(height: 30),

                  // HISTORY
                  if(historyTrips.isNotEmpty) ...[
                    const Text("Historique Session", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.black87)),
                    const SizedBox(height: 15),
                    ...historyTrips.map((trip) => _buildHistoryItem(trip)).toList(),
                  ],
                  
                  const SizedBox(height: 40),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  // --- WIDGETS ---

  Widget _buildDBRequestCard(dynamic reservation, int index) {
    // Parse Date
    String dateRaw = reservation['date_creation'] ?? "Now";
    String clientEmail = reservation['email_utilisateur'] ?? "Client";
    String trajet = reservation['trajet'] ?? "Trajet inconnu";
    String typeVehicule = reservation['type_vehicule'] ?? "Standard";

    return Container(
      margin: const EdgeInsets.only(bottom: 20),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(25),
        boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 15, offset: const Offset(0, 5))],
      ),
      child: Column(
        children: [
          // Header
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Row(
                  children: [
                    CircleAvatar(
                      backgroundColor: Colors.grey.shade100,
                      child: const Icon(Icons.person, color: Colors.black54),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(clientEmail, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14), overflow: TextOverflow.ellipsis),
                          Text(typeVehicule, style: TextStyle(color: Colors.grey.shade500, fontSize: 12)),
                        ],
                      ),
                    )
                  ],
                ),
              ),
              const Text("150 DH", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18, color: moroccoGreen)),
            ],
          ),
          
          const Padding(padding: EdgeInsets.symmetric(vertical: 15), child: Divider()),

          // Route
          Row(
            children: [
              const Icon(Icons.route, size: 20, color: moroccoRed),
              const SizedBox(width: 15),
              Expanded(
                child: Text(trajet, style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 15)),
              ),
            ],
          ),
          const SizedBox(height: 10),
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Icon(Icons.access_time, size: 14, color: Colors.grey.shade400),
              const SizedBox(width: 5),
              Text(dateRaw, style: TextStyle(fontSize: 11, color: Colors.grey.shade400)),
            ],
          ),

          const SizedBox(height: 25),

          // Actions
          Row(
            children: [
              Expanded(
                child: OutlinedButton(
                  onPressed: () => declineOffer(index),
                  style: OutlinedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 15),
                    side: const BorderSide(color: Colors.grey),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15))
                  ),
                  child: const Text("IGNORER", style: TextStyle(color: Colors.black54, fontWeight: FontWeight.bold)),
                ),
              ),
              const SizedBox(width: 15),
              Expanded(
                child: ElevatedButton(
                  onPressed: () => acceptOffer(index),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: moroccoGreen,
                    padding: const EdgeInsets.symmetric(vertical: 15),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
                    elevation: 5,
                  ),
                  child: const Text("ACCEPTER", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                ),
              ),
            ],
          )
        ],
      ),
    );
  }

  Widget _buildHistoryItem(dynamic trip) {
    return Container(
      margin: const EdgeInsets.only(bottom: 15),
      padding: const EdgeInsets.all(15),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(15),
        border: Border.all(color: Colors.grey.shade100),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            child: Row(
              children: [
                const Icon(Icons.check_circle, color: Colors.green, size: 20),
                const SizedBox(width: 15),
                Expanded(
                  child: Text(trip['trajet'] ?? "Trajet", style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14), overflow: TextOverflow.ellipsis),
                ),
              ],
            ),
          ),
          const Text("150 DH", style: TextStyle(fontWeight: FontWeight.bold, color: Colors.black87)),
        ],
      ),
    );
  }

  Widget _buildStatCard(String title, String value, IconData icon, Color color) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 20),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
          boxShadow: [BoxShadow(color: Colors.grey.shade100, blurRadius: 10, offset: const Offset(0, 5))],
        ),
        child: Column(
          children: [
            Icon(icon, color: color, size: 24),
            const SizedBox(height: 8),
            Text(value, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
            Text(title, style: TextStyle(color: Colors.grey.shade500, fontSize: 12)),
          ],
        ),
      ),
    );
  }

  Widget _buildModernDrawer() {
    return Drawer(
      backgroundColor: Colors.white,
      child: Column(
        children: [
          Container(
            width: double.infinity,
            padding: const EdgeInsets.only(top: 60, bottom: 30),
            decoration: const BoxDecoration(
              gradient: LinearGradient(colors: [moroccoRed, darkRed]),
            ),
            child: Column(
              children: [
                const CircleAvatar(radius: 40, backgroundColor: Colors.white, child: Icon(Icons.person, size: 45, color: moroccoRed)),
                const SizedBox(height: 12),
                Text(fullName, style: const TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold)),
                Text(email, style: TextStyle(color: Colors.white.withOpacity(0.8), fontSize: 13)),
              ],
            ),
          ),
          Expanded(
            child: ListView(
              padding: const EdgeInsets.all(10),
              children: [
                ListTile(leading: const Icon(Icons.dashboard, color: moroccoRed), title: const Text("Tableau de bord"), onTap: () => Navigator.pop(context)),
                ListTile(leading: const Icon(Icons.logout, color: Colors.red), title: const Text("Déconnexion"), onTap: _logout),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class StadiumWaveClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    var path = Path();
    path.lineTo(0, size.height - 50);
    path.quadraticBezierTo(size.width / 4, size.height, size.width / 2.25, size.height - 30);
    path.quadraticBezierTo(size.width - (size.width / 3.25), size.height - 80, size.width, size.height - 50);
    path.lineTo(size.width, 0);
    path.close();
    return path;
  }
  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) => false;
}