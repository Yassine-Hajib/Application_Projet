import 'package:flutter/material.dart';

class SignupPage extends StatefulWidget {
  const SignupPage({super.key});

  @override
  State<SignupPage> createState() => _SignupPageState();
}

class _SignupPageState extends State<SignupPage> {
  final _formKey = GlobalKey<FormState>();

  // common fields
  final nameCtrl = TextEditingController();
  final emailCtrl = TextEditingController();
  final passCtrl = TextEditingController();

  String selectedRole = "Supporteur";

  // chauffeur fields
  final carBrandCtrl = TextEditingController();
  final carModelCtrl = TextEditingController();
  String carEtat = "Bon";
  final permisTypeCtrl = TextEditingController();
  final permisYearCtrl = TextEditingController();
  final phoneCtrl = TextEditingController();
  final matriculeCtrl = TextEditingController();
  final cityCtrl = TextEditingController();

  @override
  void dispose() {
    nameCtrl.dispose();
    emailCtrl.dispose();
    passCtrl.dispose();
    carBrandCtrl.dispose();
    carModelCtrl.dispose();
    permisTypeCtrl.dispose();
    permisYearCtrl.dispose();
    phoneCtrl.dispose();
    matriculeCtrl.dispose();
    cityCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade200,
      body: Center(
        child: Container(
          width: 520,
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12),
            boxShadow: [BoxShadow(color: Colors.black12, blurRadius: 10)],
          ),
          child: SingleChildScrollView(
            child: Form(
              key: _formKey,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Text(
                    'Créer un compte',
                    style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 12),

                  // Name
                  TextFormField(
                    controller: nameCtrl,
                    decoration: const InputDecoration(labelText: 'Nom complet'),
                    validator: (v) =>
                        (v == null || v.isEmpty) ? 'Requis' : null,
                  ),

                  const SizedBox(height: 8),

                  // Email
                  TextFormField(
                    controller: emailCtrl,
                    decoration: const InputDecoration(labelText: 'Email'),
                    validator: (v) => (v == null || !v.contains('@'))
                        ? 'Email invalide'
                        : null,
                  ),

                  const SizedBox(height: 8),

                  // Password
                  TextFormField(
                    controller: passCtrl,
                    decoration: const InputDecoration(
                      labelText: 'Mot de passe',
                    ),
                    obscureText: true,
                    validator: (v) =>
                        (v == null || v.length < 6) ? 'Min 6 caractères' : null,
                  ),

                  const SizedBox(height: 12),

                  // Role
                  DropdownButtonFormField<String>(
                    value: selectedRole,
                    decoration: const InputDecoration(
                      labelText: 'Type d\'utilisateur',
                    ),
                    items: const [
                      DropdownMenuItem(
                        value: "Supporteur",
                        child: Text("Supporteur"),
                      ),
                      DropdownMenuItem(
                        value: "Chauffeur",
                        child: Text("Chauffeur"),
                      ),
                      DropdownMenuItem(value: "Admin", child: Text("Admin")),
                    ],
                    onChanged: (v) =>
                        setState(() => selectedRole = v ?? "Supporteur"),
                  ),

                  const SizedBox(height: 12),

                  // Chauffeur extra fields
                  if (selectedRole == 'Chauffeur') ...[
                    const Divider(),
                    const Align(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        'Informations Chauffeur',
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                    ),
                    const SizedBox(height: 8),

                    TextFormField(
                      controller: carBrandCtrl,
                      decoration: const InputDecoration(labelText: 'Marque'),
                    ),

                    const SizedBox(height: 8),

                    TextFormField(
                      controller: carModelCtrl,
                      decoration: const InputDecoration(labelText: 'Modèle'),
                    ),

                    const SizedBox(height: 8),

                    DropdownButtonFormField<String>(
                      value: carEtat,
                      decoration: const InputDecoration(
                        labelText: 'Etat du véhicule',
                      ),
                      items: const [
                        DropdownMenuItem(value: 'Neuf', child: Text('Neuf')),
                        DropdownMenuItem(value: 'Bon', child: Text('Bon')),
                        DropdownMenuItem(value: 'Moyen', child: Text('Moyen')),
                        DropdownMenuItem(
                          value: 'Mauvais',
                          child: Text('Mauvais'),
                        ),
                      ],
                      onChanged: (v) => setState(() => carEtat = v ?? 'Bon'),
                    ),

                    const SizedBox(height: 8),

                    TextFormField(
                      controller: permisTypeCtrl,
                      decoration: const InputDecoration(
                        labelText: 'Type de permis',
                      ),
                    ),

                    const SizedBox(height: 8),

                    TextFormField(
                      controller: permisYearCtrl,
                      decoration: const InputDecoration(
                        labelText: "Année d'obtention du permis",
                      ),
                      keyboardType: TextInputType.number,
                    ),

                    const SizedBox(height: 8),

                    TextFormField(
                      controller: phoneCtrl,
                      decoration: const InputDecoration(labelText: 'Téléphone'),
                      keyboardType: TextInputType.phone,
                    ),

                    const SizedBox(height: 8),

                    TextFormField(
                      controller: matriculeCtrl,
                      decoration: const InputDecoration(labelText: 'Matricule'),
                    ),

                    const SizedBox(height: 8),

                    TextFormField(
                      controller: cityCtrl,
                      decoration: const InputDecoration(labelText: 'Ville'),
                    ),

                    const SizedBox(height: 12),
                  ],

                  // Simple signup button
                  SizedBox(
                    width: double.infinity,
                    height: 48,
                    child: ElevatedButton(
                      onPressed: _handleSignup,
                      child: const Text('Créer le compte'),
                    ),
                  ),

                  const SizedBox(height: 8),

                  TextButton(
                    onPressed: () =>
                        Navigator.pushReplacementNamed(context, '/'),
                    child: const Text('Déjà un compte ? Se connecter'),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  void _handleSignup() {
    // keep button simple: validate basic fields only
    if (!_formKey.currentState!.validate()) return;

    // Here you would send data to backend and create user.
    // After success -> redirect according to role:
    if (selectedRole == 'Admin') {
      Navigator.pushReplacementNamed(context, '/admin_home');
    } else if (selectedRole == 'Chauffeur') {
      Navigator.pushReplacementNamed(context, '/chauffeur_home');
    } else {
      Navigator.pushReplacementNamed(context, '/support_home');
    }
  }
}
