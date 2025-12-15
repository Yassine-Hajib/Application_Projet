import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

// Note: Removed main() because this is a page inside the app, not a standalone app.

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

  final List<String> _typesVehicules = [
    'Moto-Taxi', 'Taxi', 'Bus', 'Voiture', 'Voiture de luxe',
  ];

  // ---------------- API URL ----------------
  // Update port if needed (8888 for MAMP, 80 for XAMPP)
  final String apiUrl = "http://localhost:8888/Backend/api/reservation.php";

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
      // 1. Get User Email from Storage
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String? email = prefs.getString('email');

      if (email == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Erreur : Utilisateur non connecté"), backgroundColor: Colors.red),
        );
        setState(() => isLoading = false);
        return;
      }

      // 2. Send Data to Backend
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

      // 3. Handle Response
      if (response.statusCode == 200) {
        var jsonResponse = jsonDecode(response.body);
        if (jsonResponse['success'] == true) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text("Réservation confirmée avec succès !"), backgroundColor: Colors.green),
          );
          // Optional: Clear form or go back
          // Navigator.pop(context); 
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
      print(e);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Erreur de connexion"), backgroundColor: Colors.red),
      );
    } finally {
      setState(() => isLoading = false);
    }
  }

  // ---------------- COLORS ----------------
  static const Color moroccoRed = Color(0xFFC1272D);
  static const Color moroccoGreen = Color(0xFF006233);
  static const Color darkRed = Color(0xFF8A1C21);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade50,
      // Optional AppBar if you want a back button
      appBar: AppBar(
        title: const Text("Réserver un transport"),
        backgroundColor: moroccoRed,
        foregroundColor: Colors.white,
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            // ---------------- HEADER ----------------
            Stack(
              children: [
                ClipPath(
                  clipper: StadiumWaveClipper(),
                  child: Container(
                    height: 200,
                    width: double.infinity,
                    decoration: const BoxDecoration(
                      gradient: LinearGradient(
                        colors: [moroccoRed, darkRed],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                    ),
                  ),
                ),
                Positioned(
                  top: -30, right: -30,
                  child: CircleAvatar(radius: 80, backgroundColor: Colors.white.withOpacity(0.05)),
                ),
                const Positioned(
                  bottom: 50,
                  left: 20,
                  child: Icon(Icons.directions_car_filled, size: 60, color: Colors.white24),
                ),
                const Positioned(
                  bottom: 40,
                  left: 20,
                  child: Text(
                    "Planifiez votre trajet",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 26,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),

            const SizedBox(height: 20),

            // ---------------- TRAJET ----------------
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: TextField(
                controller: _trajetCtrl,
                decoration: InputDecoration(
                  labelText: "Trajet de réservation",
                  hintText: "Ex : Hôtel → Stade Mohammed V",
                  prefixIcon: const Icon(Icons.route, color: moroccoRed),
                  filled: true,
                  fillColor: Colors.white,
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: const BorderSide(color: moroccoGreen, width: 2),
                  ),
                ),
              ),
            ),

            const SizedBox(height: 16),

            // ---------------- TYPE DE RÉSERVATION ----------------
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 12),
                decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(12), border: Border.all(color: Colors.grey.shade400)),
                child: DropdownButtonHideUnderline(
                  child: DropdownButton<String>(
                    value: _selectedTypeReservation,
                    hint: const Row(children: [Icon(Icons.category, color: Colors.grey), SizedBox(width: 10), Text("Type de réservation")]),
                    isExpanded: true,
                    items: _typesReservationList.map((type) => DropdownMenuItem(value: type, child: Text(type))).toList(),
                    onChanged: (value) => setState(() => _selectedTypeReservation = value),
                  ),
                ),
              ),
            ),

            const SizedBox(height: 16),

            // ---------------- TYPE DE VÉHICULE ----------------
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 12),
                decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(12), border: Border.all(color: Colors.grey.shade400)),
                child: DropdownButtonHideUnderline(
                  child: DropdownButton<String>(
                    value: _selectedVehiculeType,
                    hint: const Row(children: [Icon(Icons.directions_car, color: Colors.grey), SizedBox(width: 10), Text("Type de véhicule")]),
                    isExpanded: true,
                    items: _typesVehicules.map((v) => DropdownMenuItem(value: v, child: Text(v))).toList(),
                    onChanged: (value) => setState(() => _selectedVehiculeType = value),
                  ),
                ),
              ),
            ),

            const SizedBox(height: 30),

            // ---------------- BOUTON ----------------
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: SizedBox(
                width: double.infinity,
                height: 55,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: moroccoGreen,
                    elevation: 5,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  ),
                  onPressed: isLoading ? null : _submitReservation,
                  child: isLoading 
                    ? const CircularProgressIndicator(color: Colors.white)
                    : const Text("CONFIRMER LA RÉSERVATION", style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white, letterSpacing: 1)),
                ),
              ),
            ),

            const SizedBox(height: 30),
          ],
        ),
      ),
    );
  }
}

// -------------------------------------------------------------
// --- CLIPPER DÉCORATIF ---
// -------------------------------------------------------------
class StadiumWaveClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    Path path = Path();
    path.lineTo(0, size.height - 40);
    path.quadraticBezierTo(size.width / 2, size.height, size.width, size.height - 40);
    path.lineTo(size.width, 0);
    path.close();
    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) => false;
}