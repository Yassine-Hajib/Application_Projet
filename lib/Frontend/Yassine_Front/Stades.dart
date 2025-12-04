import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class StadesPage extends StatefulWidget {
  const StadesPage({super.key});

  @override
  State<StadesPage> createState() => _StadesPageState();
}

class _StadesPageState extends State<StadesPage> {
  final List<String> cities = [
    "Casablanca",
    "Marrakech",
    "Rabat",
    "Tanger",
    "Fes",
    "Agadir",
  ];

  String selectedCity = "Casablanca";
  final List<StadeInfo> stades = [
    StadeInfo(
      name: "Stade Mohammed V",
      city: "Casablanca",
      image: "lib/Frontend/Images/StadeMohammedV.jpg",
      mapUrl: "https://www.google.com/maps/place/Mohammed+V+Stadium/",
    ),
    StadeInfo(
      name: "Stade de Marrakech",
      city: "Marrakech",
      image: "lib/Frontend/Images/StdeMarrakech2.jpeg",
      mapUrl: "https://www.google.com/maps/place/Gran+Estadio+de+Marrakech/",
    ),
    StadeInfo(
      name: "Moulay Abdellah",
      city: "Rabat",
      image: "lib/Frontend/Images/MoulayAbdellah.jpg",
      mapUrl:
          "https://www.google.com/maps/place/Prince+Moulay+Abdellah+Stadium/",
    ),
    StadeInfo(
      name: "Stade Al Barid",
      city: "Rabat",
      image: "lib/Frontend/Images/StadeAlBarid.jpg",
      mapUrl: "https://www.google.com/maps/place/Al-Barid+Stadium/",
    ),
    StadeInfo(
      name: "Stade Annexe Olympique",
      city: "Rabat",
      image: "lib/Frontend/Images/StadeAnnexeOlympique.jpg",
      mapUrl:
          "https://www.google.com/maps/place/Estadio+Ol%C3%ADmpico+de+Rabat/",
    ),
    StadeInfo(
      name: "Stade Moulay El Hassan",
      city: "Rabat",
      image: "lib/Frontend/Images/StadePrinceMoulayElHassan.jpeg",
      mapUrl: "https://www.google.com/maps/search/stade+moulay+el+hassan+rabat",
    ),
    StadeInfo(
      name: "Stade de Fes",
      city: "Fes",
      image: "lib/Frontend/Images/FesStaduim.jpeg",
      mapUrl: "https://www.google.com/maps/place/Stade+Foot+Fès/",
    ),
    StadeInfo(
      name: "Tanger Stadium",
      city: "Tanger",
      image: "lib/Frontend/Images/TangerStade.jpeg",
      mapUrl: "https://www.google.com/maps/search/Tanger+Stadium/",
    ),
    StadeInfo(
      name: "Agadir Stadium",
      city: "Agadir",
      image: "lib/Frontend/Images/StadeAgadir.jpg",
      mapUrl: "https://www.google.com/maps/place/Estadio+de+Agadir/",
    ),
  ];

  @override
  Widget build(BuildContext context) {
    // Filter stadiums by selected city
    final cityStades = stades.where((s) => s.city == selectedCity).toList();

    return Scaffold(
      backgroundColor: const Color(0xFFF7F7F7),
      appBar: AppBar(
        backgroundColor: const Color(0xFFC1272D), // Morocco red
        elevation: 0,
        title: const Text("🇲🇦 Stades du Maroc"),
        centerTitle: true,
      ),
      body: Column(
        children: [
          const SizedBox(height: 12),

          // City selector
          _buildCitySelector(),

          const SizedBox(height: 16),

          // Stadium list
          Expanded(
            child: cityStades.isEmpty
                ? const Center(child: Text("Aucun stade pour cette ville."))
                : ListView.separated(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 9, vertical: 6),
                    itemCount: cityStades.length,
                    separatorBuilder: (_, __) => const SizedBox(height: 6),
                    itemBuilder: (_, i) => StadeCard(stade: cityStades[i]),
                  ),
          ),
        ],
      ),
    );
  }

  /// City chips
  Widget _buildCitySelector() {
    return SizedBox(
      height: 50,
      child: ListView.separated(
        padding: const EdgeInsets.symmetric(horizontal: 12),
        scrollDirection: Axis.horizontal,
        itemCount: cities.length,
        separatorBuilder: (_, __) => const SizedBox(width: 10),
        itemBuilder: (_, index) {
          final city = cities[index];
          final isSelected = city == selectedCity;
          return GestureDetector(
            onTap: () => setState(() => selectedCity = city),
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 220),
              padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 10),
              decoration: BoxDecoration(
                color: isSelected ? const Color(0xFFC1272D) : Colors.white,
                borderRadius: BorderRadius.circular(25),
                border: Border.all(
                    color: isSelected
                        ? const Color(0xFFC1272D)
                        : Colors.grey.shade300),
                boxShadow: isSelected
                    ? [
                        BoxShadow(
                          color: const Color(0xFFC1272D).withOpacity(0.18),
                          blurRadius: 10,
                          offset: const Offset(0, 4),
                        )
                      ]
                    : null,
              ),
              child: Center(
                child: Text(
                  city,
                  style: TextStyle(
                    color: isSelected ? Colors.white : Colors.black87,
                    fontWeight: isSelected ? FontWeight.w700 : FontWeight.w600,
                    fontSize: 14.5,
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

/// ---------- StadeCard widget with robust image handling ----------
class StadeCard extends StatelessWidget {
  final StadeInfo stade;
  const StadeCard({super.key, required this.stade});

  @override
  Widget build(BuildContext context) {
    // Colors
    const moroccoGreen = Color(0xFF1A8F3D);

    return Container(
      margin: const EdgeInsets.only(bottom: 14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        boxShadow: [
          BoxShadow(
              color: Colors.black.withOpacity(0.06),
              blurRadius: 10,
              offset: const Offset(0, 4))
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Title with emoji
          Padding(
            padding: const EdgeInsets.fromLTRB(14, 14, 14, 6),
            child: Text(
              "🏟 ${stade.name}",
              style:
                  const TextStyle(fontSize: 18.5, fontWeight: FontWeight.w700),
            ),
          ),

          // Image area: use AspectRatio for consistent look on different devices
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 14),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: AspectRatio(
                // 16:9 gives a natural stadium photo ratio; adjust if you want taller shots
                aspectRatio: 16 / 9,
                child: Image.asset(
                  stade.image,
                  fit: BoxFit.cover,
                  // If image asset missing or fails to load, show a friendly fallback
                  errorBuilder: (context, error, stackTrace) {
                    return Container(
                      color: Colors.grey.shade200,
                      child: Center(
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: const [
                            Icon(Icons.broken_image,
                                size: 42, color: Colors.grey),
                            SizedBox(height: 6),
                            Text("Image non disponible",
                                style: TextStyle(color: Colors.grey)),
                          ],
                        ),
                      ),
                    );
                  },
                ),
              ),
            ),
          ),

          const SizedBox(height: 12),

          // Buttons row (maps)
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
            child: Row(
              children: [
                Expanded(
                  child: ElevatedButton.icon(
                    onPressed: () async {
                      final uri = Uri.parse(stade.mapUrl);
                      if (await canLaunchUrl(uri)) {
                        await launchUrl(uri,
                            mode: LaunchMode.externalApplication);
                      } else {
                        // simple feedback when url cannot open
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                              content: Text("Impossible d'ouvrir la carte")),
                        );
                      }
                    },
                    icon: const Icon(Icons.location_on_outlined),
                    label: const Text("Voir sur Google Maps 🌍"),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color.fromARGB(255, 143, 28, 26),
                      padding: const EdgeInsets.symmetric(vertical: 12),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10)),
                      textStyle: const TextStyle(
                          fontSize: 14.5, fontWeight: FontWeight.w600),
                    ),
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 8),
        ],
      ),
    );
  }
}

/// ---------- Data model ----------
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
