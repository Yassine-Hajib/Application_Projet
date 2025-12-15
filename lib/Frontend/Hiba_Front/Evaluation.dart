import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class EvaluationPage extends StatefulWidget {
  const EvaluationPage({super.key});

  @override
  State<EvaluationPage> createState() => _EvaluationPageState();
}

class _EvaluationPageState extends State<EvaluationPage> {
  // ---------------- STATE ----------------
  int? _note;
  String? _commentaire;
  String? _idReservation;
  String? _idChauffeur;
  bool isLoading = false;

  final List<int> _notesList = [1, 2, 3, 4, 5];

  final TextEditingController _commentaireController = TextEditingController();
  final TextEditingController _idReservationController = TextEditingController();
  final TextEditingController _idChauffeurController = TextEditingController();

  // ---------------- API URL ----------------
  // Update port if needed (8888 for MAMP, 80 for XAMPP)
  final String apiUrl = "http://localhost:8888/Backend/api/evaluation.php";

  // ---------------- COLORS ----------------
  static const Color moroccoRed = Color(0xFFC1272D);
  static const Color moroccoGreen = Color(0xFF006233);
  static const Color darkRed = Color(0xFF8A1C21);

  // ---------------- LOGIC ----------------
  Future<void> submitEvaluation() async {
    if (_note == null || _commentaireController.text.isEmpty || _idReservationController.text.isEmpty || _idChauffeurController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Veuillez remplir tous les champs."), backgroundColor: Colors.orange),
      );
      return;
    }

    setState(() => isLoading = true);

    try {
      final response = await http.post(
        Uri.parse(apiUrl),
        headers: {"Content-Type": "application/json"},
        body: jsonEncode({
          "id_reservation": _idReservationController.text,
          "id_chauffeur": _idChauffeurController.text,
          "note": _note,
          "commentaire": _commentaireController.text,
        }),
      );

      if (response.statusCode == 200) {
        var jsonResponse = jsonDecode(response.body);
        if (jsonResponse['success'] == true) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text("Évaluation envoyée avec succès !"), backgroundColor: Colors.green),
          );

          // Reset fields
          _commentaireController.clear();
          _idReservationController.clear();
          _idChauffeurController.clear();
          setState(() {
            _note = null;
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade50,
      appBar: AppBar(
        title: const Text("Laisser un avis"),
        backgroundColor: moroccoRed,
        foregroundColor: Colors.white,
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            // HEADER
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
                  child: Icon(Icons.star_rate_rounded, size: 60, color: Colors.white24),
                ),
                const Positioned(
                  bottom: 40,
                  left: 20,
                  child: Text(
                    "Évaluation Chauffeur",
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

            // NOTE
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 12),
                decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(12), border: Border.all(color: Colors.grey.shade400)),
                child: DropdownButtonHideUnderline(
                  child: DropdownButton<int>(
                    value: _note,
                    hint: const Row(children: [Icon(Icons.star_border, color: Colors.grey), SizedBox(width: 10), Text("Note (1 à 5)")]),
                    isExpanded: true,
                    items: _notesList.map((n) => DropdownMenuItem(value: n, child: Text("$n ★"))).toList(),
                    onChanged: (value) => setState(() => _note = value),
                  ),
                ),
              ),
            ),

            const SizedBox(height: 16),

            // COMMENTAIRE
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: TextField(
                controller: _commentaireController,
                maxLines: 3,
                decoration: InputDecoration(
                  labelText: "Commentaire",
                  hintText: "Racontez votre expérience...",
                  prefixIcon: const Icon(Icons.comment, color: moroccoRed),
                  filled: true,
                  fillColor: Colors.white,
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                  focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: const BorderSide(color: moroccoGreen, width: 2)),
                ),
              ),
            ),

            const SizedBox(height: 16),

            // ID RESERVATION
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: TextField(
                controller: _idReservationController,
                keyboardType: TextInputType.number,
                decoration: InputDecoration(
                  labelText: "ID Réservation",
                  prefixIcon: const Icon(Icons.confirmation_number, color: Colors.grey),
                  filled: true,
                  fillColor: Colors.white,
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                ),
              ),
            ),

            const SizedBox(height: 16),

            // ID CHAUFFEUR
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: TextField(
                controller: _idChauffeurController,
                keyboardType: TextInputType.number,
                decoration: InputDecoration(
                  labelText: "ID Chauffeur",
                  prefixIcon: const Icon(Icons.person, color: Colors.grey),
                  filled: true,
                  fillColor: Colors.white,
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                ),
              ),
            ),

            const SizedBox(height: 24),

            // BOUTON
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: SizedBox(
                width: double.infinity,
                height: 50,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: moroccoGreen,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                    elevation: 5,
                  ),
                  onPressed: isLoading ? null : submitEvaluation,
                  child: isLoading 
                    ? const CircularProgressIndicator(color: Colors.white)
                    : const Text("ENVOYER L'ÉVALUATION", style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white, letterSpacing: 1)),
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

// CLIPPER DÉCORATIF
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