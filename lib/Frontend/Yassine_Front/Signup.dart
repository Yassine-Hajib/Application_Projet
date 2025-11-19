import 'package:flutter/material.dart';
import 'acceuil.dart';

class SignupPage extends StatefulWidget {
  @override
  State<SignupPage> createState() => _SignupPageState();
}

class _SignupPageState extends State<SignupPage> {
  final Color red = Color.fromARGB(255, 242, 27, 3);
  final _formKey = GlobalKey<FormState>();

  final TextEditingController fullNameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController confirmPasswordController =
      TextEditingController();
  final TextEditingController birthDateController = TextEditingController();
  final TextEditingController permisController = TextEditingController();
  final TextEditingController experienceController = TextEditingController();
  final TextEditingController vehicleTypeController = TextEditingController();
  final TextEditingController matriculeController = TextEditingController();
  final TextEditingController marqueController = TextEditingController();
  final TextEditingController modelController = TextEditingController();
  final TextEditingController etatController = TextEditingController();

  String? selectedType;

  String? _validateEmail(String? value) {
    if (value == null || value.isEmpty) return "Email required";
    final emailRegex = RegExp(r'^[^@]+@[^@]+\.[^@]+');
    if (!emailRegex.hasMatch(value)) return "Invalid email format";
    return null;
  }

  String? _validatePassword(String? value) {
    if (value == null || value.isEmpty) return "Password required";
    if (value.length < 6) return "Password must be at least 6 characters";
    return null;
  }

  String? _validateConfirmPassword(String? value) {
    if (value != passwordController.text) return "Passwords do not match";
    return null;
  }

  void _signup() {
    if (_formKey.currentState!.validate()) {
      // TODO: Save user data to database including chauffeur fields
      Navigator.pushReplacementNamed(context, '/home');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              SizedBox(height: 60),
              Text(
                "Sign Up",
                style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 20),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 30),
                child: TextFormField(
                  controller: fullNameController,
                  validator: (v) => v!.isEmpty ? "Full Name required" : null,
                  decoration: InputDecoration(labelText: "Full Name"),
                ),
              ),
              SizedBox(height: 15),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 30),
                child: TextFormField(
                  controller: emailController,
                  validator: _validateEmail,
                  decoration: InputDecoration(labelText: "Email"),
                ),
              ),
              SizedBox(height: 15),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 30),
                child: TextFormField(
                  controller: passwordController,
                  obscureText: true,
                  validator: _validatePassword,
                  decoration: InputDecoration(labelText: "Password"),
                ),
              ),
              SizedBox(height: 15),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 30),
                child: TextFormField(
                  controller: confirmPasswordController,
                  obscureText: true,
                  validator: _validateConfirmPassword,
                  decoration: InputDecoration(labelText: "Confirm Password"),
                ),
              ),
              SizedBox(height: 15),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 30),
                child: DropdownButtonFormField<String>(
                  decoration: InputDecoration(labelText: "User Type"),
                  value: selectedType,
                  items: [
                    DropdownMenuItem(
                      child: Text("Supporteur"),
                      value: "Supporteur",
                    ),
                    DropdownMenuItem(
                      child: Text("Chauffeur"),
                      value: "Chauffeur",
                    ),
                    DropdownMenuItem(child: Text("Admin"), value: "Admin"),
                  ],
                  onChanged: (value) {
                    setState(() => selectedType = value);
                  },
                  validator: (v) => v == null ? "User type required" : null,
                ),
              ),
              SizedBox(height: 15),
              if (selectedType == "Chauffeur") ...[
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 30),
                  child: TextFormField(
                    controller: birthDateController,
                    decoration: InputDecoration(labelText: "Date de Naissance"),
                    validator: (v) => v!.isEmpty ? "Required" : null,
                  ),
                ),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 30),
                  child: TextFormField(
                    controller: permisController,
                    decoration: InputDecoration(labelText: "Permis"),
                    validator: (v) => v!.isEmpty ? "Required" : null,
                  ),
                ),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 30),
                  child: TextFormField(
                    controller: experienceController,
                    decoration: InputDecoration(labelText: "Expérience"),
                    validator: (v) => v!.isEmpty ? "Required" : null,
                  ),
                ),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 30),
                  child: TextFormField(
                    controller: vehicleTypeController,
                    decoration: InputDecoration(labelText: "Vehicle Type"),
                    validator: (v) => v!.isEmpty ? "Required" : null,
                  ),
                ),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 30),
                  child: TextFormField(
                    controller: matriculeController,
                    decoration: InputDecoration(labelText: "Matricule"),
                    validator: (v) => v!.isEmpty ? "Required" : null,
                  ),
                ),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 30),
                  child: TextFormField(
                    controller: marqueController,
                    decoration: InputDecoration(labelText: "Marque"),
                    validator: (v) => v!.isEmpty ? "Required" : null,
                  ),
                ),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 30),
                  child: TextFormField(
                    controller: modelController,
                    decoration: InputDecoration(labelText: "Model"),
                    validator: (v) => v!.isEmpty ? "Required" : null,
                  ),
                ),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 30),
                  child: TextFormField(
                    controller: etatController,
                    decoration: InputDecoration(labelText: "État"),
                    validator: (v) => v!.isEmpty ? "Required" : null,
                  ),
                ),
              ],
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: _signup,
                style: ElevatedButton.styleFrom(
                  backgroundColor: red,
                  padding: EdgeInsets.symmetric(horizontal: 90, vertical: 15),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30),
                  ),
                ),
                child: Text(
                  "Create Account",
                  style: TextStyle(color: Colors.white, fontSize: 16),
                ),
              ),
              SizedBox(height: 15),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text("Already have an account? "),
                  GestureDetector(
                    onTap: () => Navigator.pushNamed(context, '/login'),
                    child: Text(
                      "Login",
                      style: TextStyle(color: red, fontWeight: FontWeight.bold),
                    ),
                  ),
                ],
              ),
              SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }
}
