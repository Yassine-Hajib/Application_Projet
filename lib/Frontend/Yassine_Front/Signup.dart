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
  final prenomCtrl = TextEditingController();
  final emailCtrl = TextEditingController();
  final passCtrl = TextEditingController();
  final phoneCtrl = TextEditingController();

  String selectedRole = "Supporteur";

  // chauffeur fields
  final carBrandCtrl = TextEditingController();
  final carModelCtrl = TextEditingController();
  final matriculeCtrl = TextEditingController();
  String carEtat = "En service";

  @override
  void dispose() {
    nameCtrl.dispose();
    prenomCtrl.dispose();
    emailCtrl.dispose();
    passCtrl.dispose();
    phoneCtrl.dispose();
    carBrandCtrl.dispose();
    carModelCtrl.dispose();
    matriculeCtrl.dispose();
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
                    decoration: const InputDecoration(labelText: 'Nom'),
                    validator: (v) => (v == null || v.isEmpty) ? 'Requis' : null,
                  ),

                  TextFormField(
                    controller: prenomCtrl,
                    decoration: const InputDecoration(labelText: 'Prénom'),
                    validator: (v) => (v == null || v.isEmpty) ? 'Requis' : null,
                  ),

                  const SizedBox(height: 8),

                  // Email
                  TextFormField(
                    controller: emailCtrl,
                    decoration: const InputDecoration(labelText: 'Email'),
                    validator: (v) =>
                        (v == null || !v.contains('@')) ? 'Email invalide' : null,
                  ),

                  // Téléphone
                  TextFormField(
                    controller: phoneCtrl,
                    decoration: const InputDecoration(labelText: 'Téléphone'),
                    keyboardType: TextInputType.phone,
                  ),

                  const SizedBox(height: 8),

                  // Password
                  TextFormField(
                    controller: passCtrl,
                    decoration: const InputDecoration(labelText: 'Mot de passe'),
                    obscureText: true,
                    validator: (v) =>
                        (v == null || v.length < 6) ? 'Min 6 caractères' : null,
                  ),

                  const SizedBox(height: 12),

                  // Role
                  DropdownButtonFormField<String>(
                    value: selectedRole,
                    decoration:
                        const InputDecoration(labelText: 'Type d\'utilisateur'),
                    items: const [
                      DropdownMenuItem(
                          value: "Supporteur", child: Text("Supporteur")),
                      DropdownMenuItem(
                          value: "Chauffeur", child: Text("Chauffeur")),
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
                        "Informations Chauffeur",
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                    ),
                    const SizedBox(height: 8),

                    DropdownButtonFormField<String>(
                      value: carEtat,
                      decoration:
                          const InputDecoration(labelText: 'État du véhicule'),
                      items: const [
                        DropdownMenuItem(
                            value: 'En service', child: Text('En service')),
                        DropdownMenuItem(
                            value: 'En Maintenance',
                            child: Text('En Maintenance')),
                        DropdownMenuItem(
                            value: 'Hors Service', child: Text('Hors Service')),
                      ],
                      onChanged: (v) =>
                          setState(() => carEtat = v ?? 'En service'),
                    ),

                    const SizedBox(height: 8),

                    TextFormField(
                      controller: matriculeCtrl,
                      decoration: const InputDecoration(labelText: 'Matricule'),
                    ),

                    const SizedBox(height: 8),
                  ],

                  SizedBox(
                    width: double.infinity,
                    height: 48,
                    child: ElevatedButton(
                      onPressed: _handleSignup,
                      child: const Text("Créer le compte"),
                    ),
                  ),

                  TextButton(
                    onPressed: () =>
                        Navigator.pushReplacementNamed(context, '/'),
                    child: const Text("Déjà un compte ? Se connecter"),
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
    if (!_formKey.currentState!.validate()) return;

    if (selectedRole == 'Admin') {
      Navigator.pushReplacementNamed(context, '/admin_home');
    } else if (selectedRole == 'Chauffeur') {
      Navigator.pushReplacementNamed(context, '/chauffeur_home');
    } else {
      Navigator.pushReplacementNamed(context, '/support_home');
    }
  }
}
