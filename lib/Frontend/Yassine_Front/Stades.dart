import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class StadesPage extends StatefulWidget {
  const StadesPage({super.key});

  @override
  State<StadesPage> createState() => _StadesPageState();
}

class _StadesPageState extends State<StadesPage> {
  // Cities list
  final List<String> cities = [
    "Casablanca",
    "Marrakech",
    "Rabat",
    "Tanger",
    "Fes",
    "Agadir",
  ];

  String selectedCity = "Casablanca";
  
  // --------------------------------------------------------
  // IMAGES LIST
  // --------------------------------------------------------
  final List<StadeInfo> stades = [
    // CASABLANCA
    StadeInfo(
      name: "Stade Mohammed V",
      city: "Casablanca",
      image: "lib/Frontend/Images/StadeMohammedV.jpg", 
      mapUrl: "https://goo.gl/maps/example1",
    ),

    // MARRAKECH
    StadeInfo(
      name: "Grand Stade de Marrakech",
      city: "Marrakech",
      image: "lib/Frontend/Images/Marrakechstade.jpg", 
      mapUrl: "https://goo.gl/maps/example2",
    ),
    StadeInfo(
      name: "Stade Annexe Marrakech",
      city: "Marrakech",
      image: "lib/Frontend/Images/StdeMarrakech2.jpg", 
      mapUrl: "https://goo.gl/maps/example2b",
    ),

    // RABAT
    StadeInfo(
      name: "Complexe Moulay Abdellah",
      city: "Rabat",
      image: "lib/Frontend/Images/MoulayAbdellah.jpg", 
      mapUrl: "https://goo.gl/maps/example3",
    ),
    StadeInfo(
      name: "Stade Al Barid",
      city: "Rabat",
      image: "lib/Frontend/Images/StadeAlBarid.jpg", 
      mapUrl: "https://goo.gl/maps/example4",
    ),
    StadeInfo(
      name: "Stade Annexe Olympique",
      city: "Rabat",
      image: "lib/Frontend/Images/StadeAnnexeOlympique.jpg", 
      mapUrl: "https://goo.gl/maps/example5",
    ),
    StadeInfo(
      name: "Stade Prince Moulay El Hassan",
      city: "Rabat",
      image: "lib/Frontend/Images/StadePrinceMoulayElHassan.jpg", 
      mapUrl: "https://goo.gl/maps/example6",
    ),

    // TANGER
    StadeInfo(
      name: "Grand Stade de Tanger",
      city: "Tanger",
      image: "lib/Frontend/Images/TangerStade.jpg", 
      mapUrl: "https://goo.gl/maps/example8",
    ),

    // FES
    StadeInfo(
      name: "Stade de Fès",
      city: "Fes",
      image: "lib/Frontend/Images/FesStaduim.jpg", 
      mapUrl: "https://goo.gl/maps/example7",
    ),

    // AGADIR
    StadeInfo(
      name: "Grand Stade d'Agadir",
      city: "Agadir",
      image: "lib/Frontend/Images/StadeAgadir.jpg", 
      mapUrl: "https://goo.gl/maps/example9",
    ),
  ];

  @override
  Widget build(BuildContext context) {
    // Filter
    final cityStades = stades.where((s) => s.city == selectedCity).toList();

    // Theme Colors
    const moroccoRed = Color(0xFFC1272D);
    const darkRed = Color(0xFF8A1C21);

    return Scaffold(
      backgroundColor: Colors.grey.shade50,
      body: Column(
        children: [
          // ----------------- HEADER -----------------
          Stack(
            children: [
              // Red Background
              ClipPath(
                clipper: StadiumWaveClipper(),
                child: Container(
                  height: 190, // Increased height slightly
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

              // Content
              SafeArea(
                child: Padding(
                  // INCREASED TOP PADDING HERE (was 10, now 20)
                  padding: const EdgeInsets.only(left: 20, right: 20, top: 20),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      IconButton(
                        onPressed: () => Navigator.pop(context),
                        icon: const Icon(Icons.arrow_back_ios, color: Colors.white, size: 22),
                        padding: EdgeInsets.zero,
                        constraints: const BoxConstraints(),
                      ),

                      const Text(
                        "Stades du Maroc",
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),

                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.2),
                          borderRadius: BorderRadius.circular(20),
                          border: Border.all(color: Colors.white30),
                        ),
                        child: const Text(
                          "AFCON 2025 🇲🇦",
                          style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: 12,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),

          // ----------------- CITY SELECTOR -----------------
          // No Transform.translate. Just natural flow.
          const SizedBox(height: 5), // Small gap between wave and chips
          _buildCitySelector(),
          const SizedBox(height: 15),

          // ----------------- STADIUM LIST -----------------
          Expanded(
            child: cityStades.isEmpty
                ? Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: const [
                        Icon(Icons.stadium_outlined, size: 60, color: Colors.grey),
                        SizedBox(height: 10),
                        Text("Aucun stade trouvé.", style: TextStyle(color: Colors.grey)),
                      ],
                    ),
                  )
                : ListView.separated(
                    padding: const EdgeInsets.fromLTRB(20, 0, 20, 20),
                    itemCount: cityStades.length,
                    separatorBuilder: (_, __) => const SizedBox(height: 20),
                    itemBuilder: (_, i) => StadeCard(stade: cityStades[i]),
                  ),
          ),
        ],
      ),
    );
  }

  // ----------------- WIDGETS -----------------

  Widget _buildCitySelector() {
    return SizedBox(
      height: 45,
      child: ListView.separated(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        scrollDirection: Axis.horizontal,
        itemCount: cities.length,
        separatorBuilder: (_, __) => const SizedBox(width: 10),
        itemBuilder: (_, index) {
          final city = cities[index];
          final isSelected = city == selectedCity;
          return GestureDetector(
            onTap: () => setState(() => selectedCity = city),
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
              decoration: BoxDecoration(
                color: isSelected ? const Color(0xFFC1272D) : Colors.white,
                borderRadius: BorderRadius.circular(30),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.1),
                    blurRadius: 10,
                    offset: const Offset(0, 4),
                  )
                ],
                border: Border.all(
                  color: isSelected ? const Color(0xFFC1272D) : Colors.transparent, 
                  width: 1.5
                ),
              ),
              child: Center(
                child: Text(
                  city,
                  style: TextStyle(
                    color: isSelected ? Colors.white : Colors.black87,
                    fontWeight: isSelected ? FontWeight.bold : FontWeight.w600,
                    fontSize: 14,
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}

class StadeCard extends StatelessWidget {
  final StadeInfo stade;
  const StadeCard({super.key, required this.stade});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
              color: Colors.black.withOpacity(0.06),
              blurRadius: 15,
              offset: const Offset(0, 8))
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Image Area
          ClipRRect(
            borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
            child: AspectRatio(
              aspectRatio: 16 / 9,
              child: Image.asset(
                stade.image,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) {
                  return Container(
                    color: Colors.grey.shade100,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: const [
                        Icon(Icons.image_not_supported_outlined, size: 40, color: Colors.grey),
                        SizedBox(height: 5),
                        Text("Image introuvable", style: TextStyle(color: Colors.grey, fontSize: 12)),
                      ],
                    ),
                  );
                },
              ),
            ),
          ),

          // Content Area
          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: Text(
                        stade.name,
                        style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, height: 1.1),
                      ),
                    ),
                    const Icon(Icons.sports_soccer, color: Color(0xFFC1272D), size: 20),
                  ],
                ),
                const SizedBox(height: 6),
                Row(
                  children: [
                    Icon(Icons.location_on, size: 16, color: Colors.grey.shade500),
                    const SizedBox(width: 4),
                    Text(stade.city, style: TextStyle(color: Colors.grey.shade600, fontWeight: FontWeight.w500)),
                  ],
                ),
                const SizedBox(height: 15),
                
                // Map Button
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton.icon(
                    onPressed: () async {
                      final uri = Uri.parse(stade.mapUrl);
                      if (await canLaunchUrl(uri)) {
                        await launchUrl(uri, mode: LaunchMode.externalApplication);
                      }
                    },
                    icon: const Icon(Icons.map_outlined, size: 18, color: Colors.white),
                    label: const Text("Voir sur la carte", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF006233), // Morocco Green
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                      padding: const EdgeInsets.symmetric(vertical: 12),
                      elevation: 0,
                    ),
                  ),
                )
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// Reuse the clipper for consistency
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

class StadeInfo {
  final String name;
  final String city;
  final String image;
  final String mapUrl;

  StadeInfo({
    required this.name,
    required this.city,
    required this.image,
    required this.mapUrl,
  });
}