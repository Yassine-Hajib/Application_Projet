import 'package:flutter/material.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _formKey = GlobalKey<FormState>();
  final emailCtrl = TextEditingController();
  final passCtrl = TextEditingController();

  String selectedRole = "Supporteur"; // default

  @override
  void dispose() {
    emailCtrl.dispose();
    passCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade200,
      body: Center(
        child: Container(
          width: 420,
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12),
            boxShadow: [BoxShadow(color: Colors.black12, blurRadius: 10)],
          ),
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Text('Se connecter',
                    style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
                const SizedBox(height: 12),

                TextFormField(
                  controller: emailCtrl,
                  decoration: const InputDecoration(labelText: 'Email'),
                  validator: (v) =>
                      (v == null || !v.contains('@')) ? 'Email invalide' : null,
                ),

                const SizedBox(height: 10),

                TextFormField(
                  controller: passCtrl,
                  decoration: const InputDecoration(labelText: 'Mot de passe'),
                  obscureText: true,
                  validator: (v) =>
                      (v == null || v.length < 6) ? 'Min 6 caractères' : null,
                ),

                const SizedBox(height: 12),

                DropdownButtonFormField<String>(
                  value: selectedRole,
                  decoration: const InputDecoration(labelText: 'Type d\'utilisateur'),
                  items: const [
                    DropdownMenuItem(value: "Admin", child: Text("Admin")),
                    DropdownMenuItem(value: "Chauffeur", child: Text("Chauffeur")),
                    DropdownMenuItem(value: "Supporteur", child: Text("Supporteur")),
                  ],
                  onChanged: (v) => setState(() => selectedRole = v ?? "Supporteur"),
                ),

                const SizedBox(height: 16),

                // Login button (simple)
                SizedBox(
                  width: double.infinity,
                  height: 48,
                  child: ElevatedButton(
                    onPressed: _handleLogin,
                    child: const Text('Se connecter'),
                  ),
                ),

                const SizedBox(height: 8),

                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text("Pas de compte ?"),
                    TextButton(
                      onPressed: () => Navigator.pushNamed(context, '/signup'),
                      child: const Text('S\'inscrire'),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _handleLogin() {
    if (!_formKey.currentState!.validate()) return;

    // Here you would check credentials / backend.
    // For now: redirect based on selectedRole:
    if (selectedRole == 'Admin') {
      Navigator.pushReplacementNamed(context, '/admin_home');
    } else if (selectedRole == 'Chauffeur') {
      Navigator.pushReplacementNamed(context, '/chauffeur_home');
    } else {
      Navigator.pushReplacementNamed(context, '/support_home');
    }
  }
}
