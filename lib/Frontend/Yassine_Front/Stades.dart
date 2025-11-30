import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart'; // For Google Maps link

/// ------------------------------------------------------------
/// STADES PAGE
/// Shows stadia divided by city with images and location link
/// ------------------------------------------------------------

class StadesPage extends StatefulWidget {
  const StadesPage({super.key});

  @override
  _StadesPageState createState() => _StadesPageState();
}

class _StadesPageState extends State<StadesPage> {
  // List of cities
  final List<String> cities = [
    "Marrakech",
    "Casablanca",
    "Rabat",
    "Tanger",
    "Fes",
    "Agadir"
  ];

  // Selected city
  String selectedCity = "Marrakech";

  // Mock list of stades
  List<StadeInfo> stades = [
    StadeInfo(
      name: "Stade de Marrakech",
      city: "Marrakech",
      images: [
        "https://upload.wikimedia.org/wikipedia/commons/thumb/3/3c/Stade_Marrakech.jpg/320px-Stade_Marrakech.jpg"
      ],
      locationUrl: "https://www.google.com/maps/place/Stade+de+Marrakech/",
    ),
    StadeInfo(
      name: "Stade Mohammed V",
      city: "Casablanca",
      images: [
        "https://upload.wikimedia.org/wikipedia/commons/thumb/8/8d/Stade_Mohammed_V_Casablanca.jpg/320px-Stade_Mohammed_V_Casablanca.jpg"
      ],
      locationUrl: "https://www.google.com/maps/place/Stade+Mohammed+V/",
    ),
    StadeInfo(
      name: "Stade de Rabat",
      city: "Rabat",
      images: [
        "https://upload.wikimedia.org/wikipedia/commons/thumb/0/09/Stade_de_Rabat.jpg/320px-Stade_de_Rabat.jpg"
      ],
      locationUrl: "https://www.google.com/maps/place/Stade+de+Rabat/",
    ),
    // Add more stades here
  ];

  @override
  Widget build(BuildContext context) {
    // Filter stades by selected city
    final cityStades = stades.where((s) => s.city == selectedCity).toList();

    return Scaffold(
      appBar: AppBar(
        title: const Text("Stades"),
        backgroundColor: Colors.green,
      ),
      body: Column(
        children: [
          // -----------------------------
          // City buttons
          // -----------------------------
          SizedBox(
            height: 50,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: cities.length,
              itemBuilder: (context, index) {
                final city = cities[index];
                return Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 6.0),
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: city == selectedCity ? Colors.green : Colors.grey,
                    ),
                    onPressed: () {
                      setState(() {
                        selectedCity = city;
                      });
                    },
                    child: Text(city),
                  ),
                );
              },
            ),
          ),

          const SizedBox(height: 10),

          // -----------------------------
          // List of stadia in the selected city
          // -----------------------------
          Expanded(
            child: cityStades.isEmpty
                ? const Center(child: Text("Aucun stade pour cette ville."))
                : ListView.builder(
                    itemCount: cityStades.length,
                    itemBuilder: (context, index) {
                      final stade = cityStades[index];
                      return Card(
                        margin: const EdgeInsets.all(10),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        elevation: 3,
                        child: Padding(
                          padding: const EdgeInsets.all(16),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                stade.name,
                                style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                              ),
                              const SizedBox(height: 10),

                              // Images (carousel)
                              SizedBox(
                                height: 180,
                                child: ListView.builder(
                                  scrollDirection: Axis.horizontal,
                                  itemCount: stade.images.length,
                                  itemBuilder: (context, imgIndex) {
                                    final imgUrl = stade.images[imgIndex];
                                    return Padding(
                                      padding: const EdgeInsets.symmetric(horizontal: 5),
                                      child: ClipRRect(
                                        borderRadius: BorderRadius.circular(12),
                                        child: Image.network(
                                          imgUrl,
                                          width: 250,
                                          fit: BoxFit.cover,
                                        ),
                                      ),
                                    );
                                  },
                                ),
                              ),
                              const SizedBox(height: 10),

                              // Location button
                              ElevatedButton.icon(
                                onPressed: () async {
                                  final url = stade.locationUrl;
                                  if (await canLaunchUrl(Uri.parse(url))) {
                                    await launchUrl(Uri.parse(url));
                                  } else {
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      const SnackBar(content: Text("Impossible d'ouvrir Google Maps")),
                                    );
                                  }
                                },
                                icon: const Icon(Icons.map),
                                label: const Text("Voir sur Google Maps"),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
          ),
        ],
      ),
    );
  }
}

/// ------------------------------------------------------------
/// Stade Info Model (POO)
/// ------------------------------------------------------------
class StadeInfo {
  String name;
  String city;
  List<String> images;
  String locationUrl;

  StadeInfo({
    required this.name,
    required this.city,
    required this.images,
    required this.locationUrl,
  });
}
