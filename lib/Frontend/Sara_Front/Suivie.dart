import 'dart:async';
import 'package:flutter/material.dart';

class SuiviPage extends StatefulWidget {
  const SuiviPage({super.key});

  @override
  State<SuiviPage> createState() => _SuiviPageState();
}

class _SuiviPageState extends State<SuiviPage> {
  // Theme Colors
  final Color moroccoRed = const Color(0xFFC1272D);
  final Color darkRed = const Color(0xFF8A1C21);
  final Color moroccoGreen = const Color(0xFF006233);

  // Data
  List<Stade> stades = [
    Stade(nomStade: "Stade Mohamed V", villeStade: "Casablanca", adresseStade: "Maarif, Casablanca"),
    Stade(nomStade: "Complexe Moulay Abdellah", villeStade: "Rabat", adresseStade: "Avenue Hassan II"),
    Stade(nomStade: "Grand Stade de Tanger", villeStade: "Tanger", adresseStade: "Quartier Malabata"),
    Stade(nomStade: "Grand Stade de Marrakech", villeStade: "Marrakech", adresseStade: "Route de Casa"),
    Stade(nomStade: "Stade Adrar", villeStade: "Agadir", adresseStade: "Route de l'Aéroport"),
    Stade(nomStade: "Stade de Fès", villeStade: "Fès", adresseStade: "Route de Sefrou"),
  ];

  List<Match> matchs = [];
  Timer? timer;

  @override
  void initState() {
    super.initState();

    // ---------------------------------------------------------
    // POPULATE ALL GROUPS (A - F)
    // ---------------------------------------------------------
    matchs = [
      // --- GROUPE A ---
      Match(
        stade: stades[0], // Casablanca
        equipe1: "Maroc", code1: "ma",
        equipe2: "Zambie", code2: "zm",
        groupe: "Groupe A",
        horaire: DateTime.now().subtract(const Duration(hours: 2)), // En cours / Fini
      ),
      Match(
        stade: stades[0],
        equipe1: "RD Congo", code1: "cd",
        equipe2: "Tanzanie", code2: "tz",
        groupe: "Groupe A",
        horaire: DateTime.now().add(const Duration(hours: 2)),
      ),

      // --- GROUPE B ---
      Match(
        stade: stades[1], // Rabat
        equipe1: "Égypte", code1: "eg",
        equipe2: "Ghana", code2: "gh",
        groupe: "Groupe B",
        horaire: DateTime.now().add(const Duration(days: 1, hours: 14)),
      ),
      Match(
        stade: stades[1],
        equipe1: "Cap-Vert", code1: "cv",
        equipe2: "Mozambique", code2: "mz",
        groupe: "Groupe B",
        horaire: DateTime.now().add(const Duration(days: 1, hours: 17)),
      ),

      // --- GROUPE C ---
      Match(
        stade: stades[2], // Tanger
        equipe1: "Sénégal", code1: "sn",
        equipe2: "Cameroun", code2: "cm",
        groupe: "Groupe C",
        horaire: DateTime.now().add(const Duration(days: 2, hours: 14)),
      ),
      Match(
        stade: stades[2],
        equipe1: "Guinée", code1: "gn",
        equipe2: "Gambie", code2: "gm",
        groupe: "Groupe C",
        horaire: DateTime.now().add(const Duration(days: 2, hours: 17)),
      ),

      // --- GROUPE D ---
      Match(
        stade: stades[3], // Marrakech
        equipe1: "Algérie", code1: "dz",
        equipe2: "Burkina Faso", code2: "bf",
        groupe: "Groupe D",
        horaire: DateTime.now().add(const Duration(days: 3, hours: 14)),
      ),
      Match(
        stade: stades[3],
        equipe1: "Mauritanie", code1: "mr",
        equipe2: "Angola", code2: "ao",
        groupe: "Groupe D",
        horaire: DateTime.now().add(const Duration(days: 3, hours: 17)),
      ),

       // --- GROUPE E ---
      Match(
        stade: stades[4], // Agadir
        equipe1: "Tunisie", code1: "tn",
        equipe2: "Mali", code2: "ml",
        groupe: "Groupe E",
        horaire: DateTime.now().add(const Duration(days: 4, hours: 14)),
      ),
      Match(
        stade: stades[4],
        equipe1: "Afrique du Sud", code1: "za",
        equipe2: "Namibie", code2: "na",
        groupe: "Groupe E",
        horaire: DateTime.now().add(const Duration(days: 4, hours: 17)),
      ),

       // --- GROUPE F ---
      Match(
        stade: stades[5], // Fès
        equipe1: "Côte d'Ivoire", code1: "ci",
        equipe2: "Nigéria", code2: "ng",
        groupe: "Groupe F",
        horaire: DateTime.now().add(const Duration(days: 5, hours: 14)),
      ),
      Match(
        stade: stades[5],
        equipe1: "Guinée équat.", code1: "gq",
        equipe2: "Guinée-Bissau", code2: "gw",
        groupe: "Groupe F",
        horaire: DateTime.now().add(const Duration(days: 5, hours: 17)),
      ),
    ];

    // Optional: Refresh logic if needed
    // timer = Timer.periodic(const Duration(minutes: 1), (_) => setState(() {}));
  }

  @override
  void dispose() {
    timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // Dynamic Theme Colors
    bool isDark = Theme.of(context).brightness == Brightness.dark;
    Color bgColor = isDark ? const Color(0xFF121212) : Colors.grey.shade50;
    Color textColor = isDark ? Colors.white : Colors.black;

    return Scaffold(
      backgroundColor: bgColor,
      body: Column(
        children: [
          // ----------------- HEADER -----------------
          Stack(
            children: [
              ClipPath(
                clipper: StadiumWaveClipper(),
                child: Container(
                  height: 180,
                  width: double.infinity,
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                      colors: [moroccoRed, darkRed],
                    ),
                  ),
                ),
              ),
              SafeArea(
                child: Padding(
                  padding: const EdgeInsets.only(top: 20, left: 20, right: 20),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      IconButton(
                        icon: const Icon(Icons.arrow_back_ios, color: Colors.white),
                        onPressed: () => Navigator.pop(context),
                      ),
                      const Text(
                        "Matchs de Groupes",
                        style: TextStyle(color: Colors.white, fontSize: 22, fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(width: 40), // Balance
                    ],
                  ),
                ),
              ),
            ],
          ),

          // ----------------- MATCH LIST -----------------
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.fromLTRB(20, 0, 20, 20),
              itemCount: matchs.length,
              itemBuilder: (context, index) {
                final match = matchs[index];
                return _matchCard(match, isDark, textColor);
              },
            ),
          ),
        ],
      ),
    );
  }

  // ----------------- REDESIGNED MATCH CARD WITH FLAGS -----------------
  Widget _matchCard(Match match, bool isDark, Color textColor) {
    return Container(
      margin: const EdgeInsets.only(bottom: 20),
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF1E1E1E) : Colors.white,
        borderRadius: BorderRadius.circular(25),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(isDark ? 0.3 : 0.08),
            blurRadius: 15,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Column(
        children: [
          // 1. TOP BAR (Date & Venue)
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
            decoration: BoxDecoration(
              color: isDark ? Colors.grey.shade900 : Colors.grey.shade50,
              borderRadius: const BorderRadius.vertical(top: Radius.circular(25)),
            ),
            child: Row(
              children: [
                Icon(Icons.calendar_today, size: 14, color: moroccoRed),
                const SizedBox(width: 6),
                Text(
                  "${match.horaire.day}/${match.horaire.month} • ${match.horaire.hour}:${match.horaire.minute.toString().padLeft(2, '0')}",
                  style: TextStyle(fontWeight: FontWeight.bold, color: Colors.grey.shade600, fontSize: 12),
                ),
                const Spacer(),
                Icon(Icons.location_on, size: 14, color: moroccoGreen),
                const SizedBox(width: 4),
                Expanded(
                  child: Text(
                    match.stade.villeStade,
                    style: TextStyle(fontWeight: FontWeight.bold, color: Colors.grey.shade600, fontSize: 12),
                    overflow: TextOverflow.ellipsis,
                    textAlign: TextAlign.right,
                  ),
                ),
              ],
            ),
          ),

          // 2. TEAMS DISPLAY (Scoreboard Style)
          Padding(
            padding: const EdgeInsets.all(20),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                // Team 1
                _teamAvatar(match.equipe1, match.code1, textColor),
                
                // VS / Group Badge
                Column(
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
                      decoration: BoxDecoration(
                        gradient: LinearGradient(colors: [moroccoRed, darkRed]),
                        borderRadius: BorderRadius.circular(20),
                        boxShadow: [BoxShadow(color: moroccoRed.withOpacity(0.3), blurRadius: 8, offset: const Offset(0, 3))]
                      ),
                      child: const Text(
                        "VS", 
                        style: TextStyle(color: Colors.white, fontWeight: FontWeight.w900, fontSize: 14),
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      match.groupe, // Shows "Groupe A", "Groupe B", etc.
                      style: TextStyle(fontSize: 10, color: Colors.grey.shade500, fontWeight: FontWeight.w500),
                    )
                  ],
                ),

                // Team 2
                _teamAvatar(match.equipe2, match.code2, textColor),
              ],
            ),
          ),

          // 3. FOOTER (Stadium Details Button)
          Padding(
            padding: const EdgeInsets.fromLTRB(20, 0, 20, 20),
            child: SizedBox(
              width: double.infinity,
              child: OutlinedButton.icon(
                onPressed: () {},
                icon: Icon(Icons.stadium_outlined, size: 18, color: moroccoGreen),
                label: Text(match.stade.nomStade, style: TextStyle(color: textColor, fontSize: 12)),
                style: OutlinedButton.styleFrom(
                  side: BorderSide(color: Colors.grey.shade300),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
                  padding: const EdgeInsets.symmetric(vertical: 12),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  // Helper for Team Flag + Name
  Widget _teamAvatar(String teamName, String isoCode, Color textColor) {
    // Construct flag URL from isoCode (e.g. 'ma' -> Morocco flag)
    String flagUrl = "https://flagcdn.com/w160/$isoCode.png";

    return Expanded(
      child: Column(
        children: [
          Container(
            height: 60,
            width: 60,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: Colors.grey.shade100,
              boxShadow: [BoxShadow(color: Colors.black12, blurRadius: 5)],
              border: Border.all(color: Colors.grey.shade200, width: 2),
            ),
            child: ClipOval(
              child: Image.network(
                flagUrl,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) {
                  return const Icon(Icons.flag, color: Colors.grey);
                },
              ),
            ),
          ),
          const SizedBox(height: 10),
          Text(
            teamName,
            textAlign: TextAlign.center,
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14, color: textColor),
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
    );
  }
}

// ----------------- DATA CLASSES -----------------
class Stade {
  final String nomStade;
  final String villeStade;
  final String adresseStade;

  Stade({required this.nomStade, required this.villeStade, required this.adresseStade});
}

class Match {
  final Stade stade;
  final String equipe1;
  final String code1; // ISO Code for flag (e.g. 'ma')
  final String equipe2;
  final String code2; // ISO Code for flag (e.g. 'zm')
  final String groupe;
  final DateTime horaire;

  Match({
    required this.stade, 
    required this.equipe1, 
    required this.code1, 
    required this.equipe2, 
    required this.code2,
    required this.groupe, 
    required this.horaire
  });
}

// ----------------- CLIPPER -----------------
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