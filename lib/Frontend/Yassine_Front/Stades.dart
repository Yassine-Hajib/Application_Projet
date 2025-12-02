import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

/// ------------------------------------------------------------
/// STADES PAGE (CLEAN UI + SIMPLE POO CODE)
/// ------------------------------------------------------------
class StadesPage extends StatefulWidget {
  const StadesPage({super.key});

  @override
  State<StadesPage> createState() => _StadesPageState();
}

class _StadesPageState extends State<StadesPage> {
  final List<String> cities = [
    "Marrakech",
    "Casablanca",
    "Rabat",
    "Tanger",
    "Fes",
    "Agadir",
  ];

  String selectedCity = "Marrakech";

  // DATA
  final List<StadeInfo> stades = [
    StadeInfo(
      name: "Stade de Marrakech",
      city: "Marrakech",
      images: ["lib/Frontend/Images/Marrakech_stade.png"],
      locationUrl:
          "https://www.google.com/maps/place/Gran+Estadio+de+Marrakech/",
    ),
    StadeInfo(
      name: "Stade Mohammed V",
      city: "Casablanca",
      images: ["lib/Frontend/Images/Stade Mohammed V.jpg"],
      locationUrl:
          "https://www.google.com/maps/place/Mohammed+V+Stadium/@33.5825272,-7.7912121,12z/data=!4m10!1m2!2m1!1sstade+CAsablanca!3m6!1s0xda7d2e77f3d8aaf:0x9169b10a83e53ab!8m2!3d33.5825272!4d-7.6470165!15sChBzdGFkZSBDQXNhYmxhbmNhWhIiEHN0YWRlIGNhc2FibGFuY2GSAQdzdGFkaXVtmgEkQ2hkRFNVaE5NRzluUzBWSlEwRm5TVVJQYlMwdFZEZEJSUkFC4AEA-gEECAAQQQ!16zL20vMDZmNzgy?entry=ttu&g_ep=EgoyMDI1MTEyMy4xIKXMDSoASAFQAw%3D%3D",
    ),
    StadeInfo(
      name: "Moulay Abdellah",
      city: "Rabat",
      images: ["lib/Frontend/Images/Moulay_Abdellah_Rabat.jpg"],
      locationUrl:
          "https://www.google.com/maps/place/Prince+Moulay+Abdellah+Stadium/@33.9599233,-6.8915937,17z/data=!3m1!4b1!4m6!3m5!1s0xda76d33381e1715:0xa48e7a4d205b07f1!8m2!3d33.9599189!4d-6.8890188!16zL20vMDlzNnF2?entry=ttu&g_ep=EgoyMDI1MTEyMy4xIKXMDSoASAFQAw%3D%3D",
    ),
    StadeInfo(
      name: "Stade Al Barid",
      city: "Rabat",
      images: ["lib/Frontend/Images/Stade Al Barid.jpg"],
      locationUrl:
          "https://www.google.com/maps/place/Al-Barid+Stadium/@34.0051408,-6.8476115,17z/data=!3m1!4b1!4m6!3m5!1s0xda76d0029824363:0x76ed59271f7615ad!8m2!3d34.0051364!4d-6.8450366!16s%2Fg%2F11vz9rjtjz?entry=ttu&g_ep=EgoyMDI1MTEyMy4xIKXMDSoASAFQAw%3D%3D",
    ),
    StadeInfo(
        name: "Stade Annex Olympique",
        city: "Rabat",
        images: ["lib/Frontend/Images/Stade Annexe Olympique.jpg"],
        locationUrl:
            "https://www.google.com/maps/place/Estadio+Ol%C3%ADmpico+de+Rabat/@33.957021,-6.8935301,17z/data=!3m1!4b1!4m6!3m5!1s0xda713005acf67b7:0xc473b5f571c346e5!8m2!3d33.9570166!4d-6.8909552!16s%2Fg%2F11y5y5_qjc?entry=ttu&g_ep=EgoyMDI1MTEyMy4xIKXMDSoASAFQAw%3D%3D"),
    StadeInfo(
        name: "Stade Moulay El Hassan",
        city: "Rabat",
        images: ["lib/Frontend/Images/Stade Prince Moulay El Hassan.jpeg"],
        locationUrl:
            "google.com/maps?sca_esv=020ed6a1352e1b09&rlz=1C1GCEA_enMA1183MA1184&output=search&q=stade+moulay+el+hassan+rabat&source=lnms&fbs=AIIjpHxU7SXXniUZfeShr2fp4giZ1Y6MJ25_tmWITc7uy4KIeuyr9ljWioGWIw0oasFed3q5v-jrTO4UFmLjWc-eQrSDCiV_LIDQpShf7p3VG7tCVuPQM4dIB8KRrSi9KCHzJ95fLpckuyKwN_unqCG91HxBlT5bmFphgnKgNMIRtTL_gY0ZmHE0GlH0z4n5jiNOpdDE1pN5htGJJmWTLmjNM1pgXJrMLA&entry=mc&ved=1t:200715&ictx=111"),
    StadeInfo(
        name: "Stade de Fes ",
        city: "Fes",
        images: ["lib/Frontend/Images/Fes_Staduim.jpeg"],
        locationUrl:
            "https://www.google.com/maps/place/Stade+Foot+F%C3%A8s/@34.0027925,-4.9714878,17z/data=!3m1!4b1!4m6!3m5!1s0xd9f8c7938d7c9e3:0xd46509e0397b750d!8m2!3d34.0027881!4d-4.9689129!16zL20vMDlzYm1x?entry=ttu&g_ep=EgoyMDI1MTEyMy4xIKXMDSoASAFQAw%3D%3D"),
    StadeInfo(
        name: "Tanger Staduim",
        city: "Tanger",
        images: ["lib/Frontend/Images/Tanger_Stade.jpeg"],
        locationUrl:
            " https://www.google.com/maps/search/Tanger+Staduim/@33.6610456,-9.1464073,7z/data=!3m1!4b1?entry=ttu&g_ep=EgoyMDI1MTEyMy4xIKXMDSoASAFQAw%3D%3D "),
    StadeInfo(
        name: "Agadir Staduim",
        city: "Agadir",
        images: ["lib/Frontend/Images/Stade Agadir.jpg"],
        locationUrl:
            "https://www.google.com/maps/place/Estadio+de+Agadir/@30.4245147,-9.5467893,14.48z/data=!4m6!3m5!1s0xdb3c9de97587637:0x9668ab97f677bc8e!8m2!3d30.4274819!4d-9.5402594!16zL20vMGQwY2Rm?entry=ttu&g_ep=EgoyMDI1MTEyMy4xIKXMDSoASAFQAw%3D%3D")
  ];

  @override
  Widget build(BuildContext context) {
    final cityStades = stades.where((s) => s.city == selectedCity).toList();

    return Scaffold(
      appBar: AppBar(
        title: const Text("Stades"),
        backgroundColor: const Color(0xFF2ECC71),
        elevation: 0,
      ),

      /// BODY
      body: Column(
        children: [
          const SizedBox(height: 12),

          /// -------- CITY SELECTOR (CHIPS) ----------
          SizedBox(
            height: 45,
            child: ListView.separated(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: 12),
              itemCount: cities.length,
              separatorBuilder: (context, _) => const SizedBox(width: 10),
              itemBuilder: (context, index) {
                final city = cities[index];
                final isSelected = city == selectedCity;

                return GestureDetector(
                  onTap: () => setState(() => selectedCity = city),
                  child: Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 18, vertical: 8),
                    decoration: BoxDecoration(
                      color:
                          isSelected ? const Color(0xFF2ECC71) : Colors.white,
                      borderRadius: BorderRadius.circular(25),
                      border: Border.all(
                          color: isSelected
                              ? const Color(0xFF27AE60)
                              : Colors.grey.shade400),
                      boxShadow: [
                        if (isSelected)
                          BoxShadow(
                            color: Colors.green.withOpacity(0.3),
                            blurRadius: 8,
                          )
                      ],
                    ),
                    child: Center(
                      child: Text(
                        city,
                        style: TextStyle(
                          color: isSelected ? Colors.white : Colors.black87,
                          fontWeight:
                              isSelected ? FontWeight.bold : FontWeight.w500,
                        ),
                      ),
                    ),
                  ),
                );
              },
            ),
          ),

          const SizedBox(height: 18),

          /// -------- STADES LIST ----------
          Expanded(
            child: cityStades.isEmpty
                ? const Center(
                    child: Text("Aucun stade pour cette ville.",
                        style: TextStyle(fontSize: 16)))
                : ListView.builder(
                    padding: const EdgeInsets.symmetric(horizontal: 12),
                    itemCount: cityStades.length,
                    itemBuilder: (context, index) {
                      final stade = cityStades[index];

                      return Container(
                        margin: const EdgeInsets.only(bottom: 18),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(18),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.08),
                              blurRadius: 10,
                              offset: const Offset(0, 4),
                            ),
                          ],
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(14),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                stade.name,
                                style: const TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.w700,
                                ),
                              ),

                              const SizedBox(height: 12),

                              /// --- IMAGES ---
                              SizedBox(
                                height: 190,
                                child: ClipRRect(
                                  borderRadius: BorderRadius.circular(14),
                                  child: buildImage(stade.images.first),
                                ),
                              ),

                              const SizedBox(height: 14),

                              /// --- GOOGLE MAPS BUTTON ---
                              SizedBox(
                                width: double.infinity,
                                child: ElevatedButton.icon(
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: const Color(0xFF2ECC71),
                                    padding: const EdgeInsets.symmetric(
                                        vertical: 12),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(12),
                                    ),
                                  ),
                                  icon: const Icon(Icons.map, size: 22),
                                  label: const Text(
                                    "Voir sur Google Maps",
                                    style: TextStyle(fontSize: 15),
                                  ),
                                  onPressed: () async {
                                    final uri = Uri.parse(stade.locationUrl);
                                    if (await canLaunchUrl(uri)) {
                                      await launchUrl(uri,
                                          mode: LaunchMode.externalApplication);
                                    }
                                  },
                                ),
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
/// MODEL (POO)
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

/// ------------------------------------------------------------
/// IMAGE BUILDER (Asset + Network)
/// ------------------------------------------------------------
Widget buildImage(String path) {
  return path.startsWith("http")
      ? Image.network(path, fit: BoxFit.cover)
      : Image.asset(path, fit: BoxFit.cover);
}
