import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class ReservationPage extends StatefulWidget {
  const ReservationPage({super.key});

  @override
  State<ReservationPage> createState() => _ReservationPageState();
}

class _ReservationPageState extends State<ReservationPage> {
  // ---------------- STATE ----------------
  String? _selectedTypeReservation;
  String? _selectedVehiculeType;
  final TextEditingController _trajetCtrl = TextEditingController();
  bool isLoading = false;

  final List<String> _typesReservationList = [
    'Economique', 'Familial', 'Handicapé', 'Express', 'Navette', 'Business', 'Luxury'
  ];

  final List<Map<String, dynamic>> _typesVehicules = [
    {'name': 'Moto-Taxi', 'icon': Icons.two_wheeler},
    {'name': 'Taxi', 'icon': Icons.local_taxi},
    {'name': 'Bus', 'icon': Icons.directions_bus},
    {'name': 'Voiture', 'icon': Icons.directions_car},
    {'name': 'Voiture de luxe', 'icon': Icons.diamond},
  ];

  // ---------------- API URL ----------------
  final String apiUrl = "http://localhost:8888/Backend/api/reservation.php";

  // ---------------- COLORS ----------------
  static const Color moroccoRed = Color(0xFFC1272D);
  static const Color moroccoGreen = Color(0xFF006233);
  static const Color darkRed = Color(0xFF8A1C21);
  static const Color offWhite = Color(0xFFF8F9FA);

  // ---------------- LOGIC ----------------
  Future<void> _submitReservation() async {
    if (_trajetCtrl.text.isEmpty || _selectedTypeReservation == null || _selectedVehiculeType == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Veuillez remplir tous les champs"), backgroundColor: Colors.orange),
      );
      return;
    }

    setState(() => isLoading = true);

    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String? email = prefs.getString('email');

      if (email == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Erreur : Utilisateur non connecté"), backgroundColor: Colors.red),
        );
        setState(() => isLoading = false);
        return;
      }

      final response = await http.post(
        Uri.parse(apiUrl),
        headers: {"Content-Type": "application/json"},
        body: jsonEncode({
          "email": email,
          "trajet": _trajetCtrl.text,
          "type_reservation": _selectedTypeReservation,
          "type_vehicule": _selectedVehiculeType,
        }),
      );

      if (response.statusCode == 200) {
        var jsonResponse = jsonDecode(response.body);
        if (jsonResponse['success'] == true) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text("Réservation confirmée avec succès !"), backgroundColor: moroccoGreen),
          );
          _trajetCtrl.clear();
          setState(() {
            _selectedTypeReservation = null;
            _selectedVehiculeType = null;
          });
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text("Erreur: ${jsonResponse['message']}"), backgroundColor: Colors.red),
          );
        }
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Erreur serveur"), backgroundColor: Colors.red),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Erreur de connexion"), backgroundColor: Colors.red),
      );
    } finally {
      setState(() => isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: offWhite,
      body: SingleChildScrollView(
        child: Column(
          children: [
            // ---------------------------------------------
            // --- HEADER (EXACTLY LIKE PROFILE PAGE) ---
            // ---------------------------------------------
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
                        
                        Row(
                          children: [
                            // ---------------------------------------------
                            // --- AVATAR SECTION (PROFILE STYLE) ---
                            // ---------------------------------------------
                            Container(
                              padding: const EdgeInsets.all(4),
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                border: Border.all(color: moroccoGreen, width: 3),
                                color: Colors.white,
                              ),
                              child: CircleAvatar(
                                radius: 32,
                                backgroundColor: moroccoGreen.withOpacity(0.1), 
                                // Changed Icon to Car to match Reservation context
                                child: const Icon(
                                  Icons.directions_car_filled, 
                                  size: 35, 
                                  color: moroccoGreen
                                ),
                              ),
                            ),
                            // ---------------------------------------------

                            const SizedBox(width: 20),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Text(
                                  "Réservation", 
                                  style: TextStyle(fontSize: 22, fontWeight: FontWeight.w900, color: Colors.white, letterSpacing: 0.5)
                                ),
                                const SizedBox(height: 4),
                                Container(
                                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                                  decoration: BoxDecoration(color: moroccoGreen, borderRadius: BorderRadius.circular(4)),
                                  child: const Text(
                                    "TRANSPORT", 
                                    style: TextStyle(fontSize: 10, fontWeight: FontWeight.bold, color: Colors.white)
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

            // ---------------- CONTENT ----------------
            Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  
                  // 1. INPUT TRAJET
                  _sectionTitle("Où voulez-vous aller ?"),
                  Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(15),
                      boxShadow: [BoxShadow(color: Colors.grey.shade200, blurRadius: 10, offset: const Offset(0, 5))],
                    ),
                    child: TextField(
                      controller: _trajetCtrl,
                      decoration: const InputDecoration(
                        hintText: "Ex: Aéroport → Stade",
                        prefixIcon: Icon(Icons.location_on, color: moroccoRed),
                        border: InputBorder.none,
                        contentPadding: EdgeInsets.symmetric(horizontal: 20, vertical: 15),
                      ),
                    ),
                  ),

                  const SizedBox(height: 25),

                  // 2. VEHICLE SELECTION (Horizontal Scroll)
                  _sectionTitle("Choisissez votre véhicule"),
                  SizedBox(
                    height: 110,
                    child: ListView.separated(
                      scrollDirection: Axis.horizontal,
                      itemCount: _typesVehicules.length,
                      separatorBuilder: (c, i) => const SizedBox(width: 15),
                      itemBuilder: (context, index) {
                        final item = _typesVehicules[index];
                        final isSelected = _selectedVehiculeType == item['name'];
                        return _buildVehicleCard(item['name'], item['icon'], isSelected);
                      },
                    ),
                  ),

                  const SizedBox(height: 25),

                  // 3. SERVICE TYPE (Chips / Grid)
                  _sectionTitle("Type de service"),
                  Wrap(
                    spacing: 10,
                    runSpacing: 10,
                    children: _typesReservationList.map((type) {
                      final isSelected = _selectedTypeReservation == type;
                      return _buildServiceChip(type, isSelected);
                    }).toList(),
                  ),

                  const SizedBox(height: 40),

                  // 4. CONFIRM BUTTON
                  SizedBox(
                    width: double.infinity,
                    height: 55,
                    child: ElevatedButton(
                      onPressed: isLoading ? null : _submitReservation,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: moroccoGreen,
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
                        elevation: 5,
                        shadowColor: moroccoGreen.withOpacity(0.4),
                      ),
                      child: isLoading 
                        ? const CircularProgressIndicator(color: Colors.white)
                        : const Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text("CONFIRMER", style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white, letterSpacing: 1)),
                              SizedBox(width: 10),
                              Icon(Icons.check_circle, color: Colors.white)
                            ],
                          ),
                    ),
                  ),
                  const SizedBox(height: 30),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ---------------- UI HELPERS ----------------

  Widget _sectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 15),
      child: Text(
        title,
        style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.black87),
      ),
    );
  }

  Widget _buildVehicleCard(String name, IconData icon, bool isSelected) {
    return GestureDetector(
      onTap: () => setState(() => _selectedVehiculeType = name),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        width: 100,
        decoration: BoxDecoration(
          color: isSelected ? moroccoRed : Colors.white,
          borderRadius: BorderRadius.circular(15),
          border: Border.all(color: isSelected ? moroccoRed : Colors.grey.shade200, width: 2),
          boxShadow: [
             if(!isSelected) BoxShadow(color: Colors.grey.shade200, blurRadius: 5, offset: const Offset(0, 3))
          ]
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, color: isSelected ? Colors.white : Colors.grey, size: 30),
            const SizedBox(height: 8),
            Text(
              name,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 12, 
                fontWeight: FontWeight.bold,
                color: isSelected ? Colors.white : Colors.black54
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildServiceChip(String label, bool isSelected) {
    return GestureDetector(
      onTap: () => setState(() => _selectedTypeReservation = label),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
        decoration: BoxDecoration(
          color: isSelected ? moroccoRed.withOpacity(0.1) : Colors.white,
          borderRadius: BorderRadius.circular(30),
          border: Border.all(color: isSelected ? moroccoRed : Colors.grey.shade300),
        ),
        child: Text(
          label,
          style: TextStyle(
            color: isSelected ? moroccoRed : Colors.black54,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }
}

// ----------------- CLIPPER (COPIED FROM PROFILE PAGE) -----------------
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