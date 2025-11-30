import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

/// ------------------------------------------------------------
/// ADMIN DASHBOARD
/// Allows the admin to:
/// 1. View Users, Chauffeurs
/// 2. Add Stadia, Hotels, Airports, Events
/// ------------------------------------------------------------

void main() {
  runApp(const MaterialApp(
    home: AdminHomePage(),
    debugShowCheckedModeBanner: false,
  ));
}

/// ------------------------------------------------------------
/// MODELS
/// ------------------------------------------------------------

// Stade model
class Stade {
  String nom;
  String adresse;
  int capacite;
  String city;
  List<String> images; // URLs of images
  String locationUrl;

  Stade({
    required this.nom,
    required this.adresse,
    required this.capacite,
    required this.city,
    required this.images,
    required this.locationUrl,
  });
}

// Event model
class Event {
  String nom;
  String date;
  String lieu;
  String description;

  Event({
    required this.nom,
    required this.date,
    required this.lieu,
    required this.description,
  });
}

// Hotel model
class Hotel {
  String nom;
  String adresse;
  int etoiles;

  Hotel({required this.nom, required this.adresse, required this.etoiles});
}

// Airport model
class Airport {
  String nom;
  String localisation;

  Airport({required this.nom, required this.localisation});
}

// User model
class User {
  String nom;
  String email;

  User({required this.nom, required this.email});
}

// Chauffeur model
class Chauffeur {
  String nom;
  String email;

  Chauffeur({required this.nom, required this.email});
}

/// ------------------------------------------------------------
/// ADMIN HOME PAGE
/// ------------------------------------------------------------

class AdminHomePage extends StatefulWidget {
  const AdminHomePage({super.key});

  @override
  _AdminHomePageState createState() => _AdminHomePageState();
}

class _AdminHomePageState extends State<AdminHomePage> {
  // Data lists
  List<User> users = [];
  List<Chauffeur> chauffeurs = [];
  List<Stade> stades = [];
  List<Event> events = [];
  List<Hotel> hotels = [];
  List<Airport> airports = [];

  int _selectedTab = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Admin Dashboard"),
        backgroundColor: Colors.green,
      ),
      body: Row(
        children: [
          // -----------------------------
          // Sidebar menu
          // -----------------------------
          NavigationRail(
            selectedIndex: _selectedTab,
            onDestinationSelected: (int index) {
              setState(() {
                _selectedTab = index;
              });
            },
            labelType: NavigationRailLabelType.selected,
            destinations: const [
              NavigationRailDestination(
                  icon: Icon(Icons.person), label: Text('Users')),
              NavigationRailDestination(
                  icon: Icon(Icons.drive_eta), label: Text('Chauffeurs')),
              NavigationRailDestination(
                  icon: Icon(Icons.stadium), label: Text('Stades')),
              NavigationRailDestination(
                  icon: Icon(Icons.event), label: Text('Events')),
              NavigationRailDestination(
                  icon: Icon(Icons.hotel), label: Text('Hotels')),
              NavigationRailDestination(
                  icon: Icon(Icons.airplanemode_active), label: Text('Airports')),
            ],
          ),

          const VerticalDivider(thickness: 1, width: 1),

          // -----------------------------
          // Content
          // -----------------------------
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: _buildTabContent(),
            ),
          ),
        ],
      ),
    );
  }

  /// ------------------------------------------------------------
  /// Build content depending on selected tab
  /// ------------------------------------------------------------
  Widget _buildTabContent() {
    switch (_selectedTab) {
      case 0:
        return _buildUsersTab();
      case 1:
        return _buildChauffeursTab();
      case 2:
        return _buildStadesTab();
      case 3:
        return _buildEventsTab();
      case 4:
        return _buildHotelsTab();
      case 5:
        return _buildAirportsTab();
      default:
        return const Center(child: Text("Unknown tab"));
    }
  }

  /// ------------------------------------------------------------
  /// USERS TAB
  /// ------------------------------------------------------------
  Widget _buildUsersTab() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text("Users", style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
        const SizedBox(height: 10),
        Expanded(
          child: ListView.builder(
            itemCount: users.length,
            itemBuilder: (context, index) {
              final user = users[index];
              return ListTile(
                leading: const Icon(Icons.person),
                title: Text(user.nom),
                subtitle: Text(user.email),
              );
            },
          ),
        ),
        ElevatedButton(
            onPressed: () {
              // Add mock user for simplicity
              setState(() {
                users.add(User(nom: "User ${users.length + 1}", email: "user${users.length + 1}@mail.com"));
              });
            },
            child: const Text("Add User")),
      ],
    );
  }

  /// ------------------------------------------------------------
  /// CHAUFFEURS TAB
  /// ------------------------------------------------------------
  Widget _buildChauffeursTab() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text("Chauffeurs", style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
        const SizedBox(height: 10),
        Expanded(
          child: ListView.builder(
            itemCount: chauffeurs.length,
            itemBuilder: (context, index) {
              final chauffeur = chauffeurs[index];
              return ListTile(
                leading: const Icon(Icons.drive_eta),
                title: Text(chauffeur.nom),
                subtitle: Text(chauffeur.email),
              );
            },
          ),
        ),
        ElevatedButton(
            onPressed: () {
              setState(() {
                chauffeurs.add(Chauffeur(nom: "Chauffeur ${chauffeurs.length + 1}", email: "chauffeur${chauffeurs.length + 1}@mail.com"));
              });
            },
            child: const Text("Add Chauffeur")),
      ],
    );
  }

  /// ------------------------------------------------------------
  /// STADES TAB
  /// ------------------------------------------------------------
  Widget _buildStadesTab() {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text("Add Stade", style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
          AddStadeForm(onAdd: (stade) {
            setState(() {
              stades.add(stade);
            });
          }),
          const SizedBox(height: 20),
          const Text("All Stadia", style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
          ListView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: stades.length,
            itemBuilder: (context, index) {
              final stade = stades[index];
              return Card(
                margin: const EdgeInsets.symmetric(vertical: 6),
                child: ListTile(
                  title: Text(stade.nom),
                  subtitle: Text("${stade.city} - ${stade.adresse}"),
                  trailing: IconButton(
                    icon: const Icon(Icons.map),
                    onPressed: () async {
                      final url = stade.locationUrl;
                      final uri = Uri.parse(url);
                      if (await canLaunchUrl(uri)) {
                        await launchUrl(uri, mode: LaunchMode.externalApplication);
                      } else {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text("Impossible d'ouvrir Google Maps")),
                        );
                      }
                    },
                  ),
                ),
              );
            },
          ),
        ],
      ),
    );
  }

  /// ------------------------------------------------------------
  /// EVENTS TAB
  /// ------------------------------------------------------------
  Widget _buildEventsTab() {
    return SingleChildScrollView(
      child: Column(
        children: [
          const Text("Events", style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
          AddEventForm(onAdd: (event) {
            setState(() {
              events.add(event);
            });
          }),
          const SizedBox(height: 10),
          ListView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: events.length,
            itemBuilder: (context, index) {
              final event = events[index];
              return ListTile(
                title: Text(event.nom),
                subtitle: Text("${event.date} - ${event.lieu}"),
              );
            },
          ),
        ],
      ),
    );
  }

  /// ------------------------------------------------------------
  /// HOTELS TAB
  /// ------------------------------------------------------------
  Widget _buildHotelsTab() {
    return SingleChildScrollView(
      child: Column(
        children: [
          const Text("Hotels", style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
          AddHotelForm(onAdd: (hotel) {
            setState(() {
              hotels.add(hotel);
            });
          }),
          ListView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: hotels.length,
            itemBuilder: (context, index) {
              final hotel = hotels[index];
              return ListTile(
                title: Text(hotel.nom),
                subtitle: Text("${hotel.adresse} - ${hotel.etoiles} étoiles"),
              );
            },
          ),
        ],
      ),
    );
  }

  /// ------------------------------------------------------------
  /// AIRPORTS TAB
  /// ------------------------------------------------------------
  Widget _buildAirportsTab() {
    return SingleChildScrollView(
      child: Column(
        children: [
          const Text("Airports", style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
          AddAirportForm(onAdd: (airport) {
            setState(() {
              airports.add(airport);
            });
          }),
          ListView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: airports.length,
            itemBuilder: (context, index) {
              final airport = airports[index];
              return ListTile(
                title: Text(airport.nom),
                subtitle: Text(airport.localisation),
              );
            },
          ),
        ],
      ),
    );
  }
}

/// ------------------------------------------------------------
/// ADD STADE FORM
/// ------------------------------------------------------------
class AddStadeForm extends StatefulWidget {
  final Function(Stade) onAdd;
  const AddStadeForm({super.key, required this.onAdd});

  @override
  _AddStadeFormState createState() => _AddStadeFormState();
}

class _AddStadeFormState extends State<AddStadeForm> {
  final _formKey = GlobalKey<FormState>();
  final nomController = TextEditingController();
  final adresseController = TextEditingController();
  final capaciteController = TextEditingController();
  final cityController = TextEditingController();
  final imagesController = TextEditingController();
  final locationController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Column(children: [
        TextFormField(
          controller: nomController,
          decoration: const InputDecoration(labelText: "Nom"),
          validator: (v) => v!.isEmpty ? "Champ requis" : null,
        ),
        TextFormField(
          controller: adresseController,
          decoration: const InputDecoration(labelText: "Adresse"),
          validator: (v) => v!.isEmpty ? "Champ requis" : null,
        ),
        TextFormField(
          controller: capaciteController,
          decoration: const InputDecoration(labelText: "Capacité"),
          keyboardType: TextInputType.number,
          validator: (v) => v!.isEmpty ? "Champ requis" : null,
        ),
        TextFormField(
          controller: cityController,
          decoration: const InputDecoration(labelText: "Ville"),
          validator: (v) => v!.isEmpty ? "Champ requis" : null,
        ),
        TextFormField(
          controller: imagesController,
          decoration: const InputDecoration(
              labelText: "Images URL (séparées par une virgule)"),
          validator: (v) => v!.isEmpty ? "Champ requis" : null,
        ),
        TextFormField(
          controller: locationController,
          decoration: const InputDecoration(labelText: "Google Maps URL"),
          validator: (v) => v!.isEmpty ? "Champ requis" : null,
        ),
        const SizedBox(height: 10),
        ElevatedButton(
          onPressed: () {
            if (_formKey.currentState!.validate()) {
              final imagesList = imagesController.text.split(',').map((e) => e.trim()).toList();
              widget.onAdd(Stade(
                nom: nomController.text,
                adresse: adresseController.text,
                capacite: int.parse(capaciteController.text),
                city: cityController.text,
                images: imagesList,
                locationUrl: locationController.text,
              ));
              nomController.clear();
              adresseController.clear();
              capaciteController.clear();
              cityController.clear();
              imagesController.clear();
              locationController.clear();
            }
          },
          child: const Text("Ajouter Stade"),
        )
      ]),
    );
  }
}

/// ------------------------------------------------------------
/// ADD EVENT FORM
/// ------------------------------------------------------------
class AddEventForm extends StatefulWidget {
  final Function(Event) onAdd;
  const AddEventForm({super.key, required this.onAdd});

  @override
  _AddEventFormState createState() => _AddEventFormState();
}

class _AddEventFormState extends State<AddEventForm> {
  final _formKey = GlobalKey<FormState>();
  final nomController = TextEditingController();
  final dateController = TextEditingController();
  final lieuController = TextEditingController();
  final descriptionController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Column(children: [
        TextFormField(controller: nomController, decoration: const InputDecoration(labelText: "Nom"), validator: (v) => v!.isEmpty ? "Champ requis" : null),
        TextFormField(controller: dateController, decoration: const InputDecoration(labelText: "Date"), validator: (v) => v!.isEmpty ? "Champ requis" : null),
        TextFormField(controller: lieuController, decoration: const InputDecoration(labelText: "Lieu"), validator: (v) => v!.isEmpty ? "Champ requis" : null),
        TextFormField(controller: descriptionController, decoration: const InputDecoration(labelText: "Description"), validator: (v) => v!.isEmpty ? "Champ requis" : null),
        const SizedBox(height: 10),
        ElevatedButton(
          onPressed: () {
            if (_formKey.currentState!.validate()) {
              widget.onAdd(Event(
                nom: nomController.text,
                date: dateController.text,
                lieu: lieuController.text,
                description: descriptionController.text,
              ));
              nomController.clear();
              dateController.clear();
              lieuController.clear();
              descriptionController.clear();
            }
          },
          child: const Text("Ajouter Event"),
        )
      ]),
    );
  }
}

/// ------------------------------------------------------------
/// ADD HOTEL FORM
/// ------------------------------------------------------------
class AddHotelForm extends StatefulWidget {
  final Function(Hotel) onAdd;
  const AddHotelForm({super.key, required this.onAdd});

  @override
  _AddHotelFormState createState() => _AddHotelFormState();
}

class _AddHotelFormState extends State<AddHotelForm> {
  final _formKey = GlobalKey<FormState>();
  final nomController = TextEditingController();
  final adresseController = TextEditingController();
  final etoilesController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Column(children: [
        TextFormField(controller: nomController, decoration: const InputDecoration(labelText: "Nom"), validator: (v) => v!.isEmpty ? "Champ requis" : null),
        TextFormField(controller: adresseController, decoration: const InputDecoration(labelText: "Adresse"), validator: (v) => v!.isEmpty ? "Champ requis" : null),
        TextFormField(controller: etoilesController, decoration: const InputDecoration(labelText: "Nombre d'étoiles"), keyboardType: TextInputType.number, validator: (v) => v!.isEmpty ? "Champ requis" : null),
        const SizedBox(height: 10),
        ElevatedButton(
          onPressed: () {
            if (_formKey.currentState!.validate()) {
              widget.onAdd(Hotel(
                nom: nomController.text,
                adresse: adresseController.text,
                etoiles: int.parse(etoilesController.text),
              ));
              nomController.clear();
              adresseController.clear();
              etoilesController.clear();
            }
          },
          child: const Text("Ajouter Hotel"),
        )
      ]),
    );
  }
}

/// ------------------------------------------------------------
/// ADD AIRPORT FORM
/// ------------------------------------------------------------
class AddAirportForm extends StatefulWidget {
  final Function(Airport) onAdd;
  const AddAirportForm({super.key, required this.onAdd});

  @override
  _AddAirportFormState createState() => _AddAirportFormState();
}

class _AddAirportFormState extends State<AddAirportForm> {
  final _formKey = GlobalKey<FormState>();
  final nomController = TextEditingController();
  final localisationController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Column(children: [
        TextFormField(controller: nomController, decoration: const InputDecoration(labelText: "Nom"), validator: (v) => v!.isEmpty ? "Champ requis" : null),
        TextFormField(controller: localisationController, decoration: const InputDecoration(labelText: "Localisation"), validator: (v) => v!.isEmpty ? "Champ requis" : null),
        const SizedBox(height: 10),
        ElevatedButton(
          onPressed: () {
            if (_formKey.currentState!.validate()) {
              widget.onAdd(Airport(
                nom: nomController.text,
                localisation: localisationController.text,
              ));
              nomController.clear();
              localisationController.clear();
            }
          },
          child: const Text("Ajouter Airport"),
        )
      ]),
    );
  }
}
