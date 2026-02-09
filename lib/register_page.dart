import 'package:flutter/material.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final TextEditingController _nomController = TextEditingController();
  final TextEditingController _prenomController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController = TextEditingController();

  void _register() {
    final nom = _nomController.text.trim();
    final prenom = _prenomController.text.trim();
    final password = _passwordController.text.trim();
    final confirmPassword = _confirmPasswordController.text.trim();

    if (nom.isEmpty || prenom.isEmpty || password.isEmpty || confirmPassword.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Tous les champs sont obligatoires"), backgroundColor: Colors.red),
      );
      return;
    }

    if (password != confirmPassword) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Les mots de passe ne correspondent pas"), backgroundColor: Colors.red),
      );
      return;
    }

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text("Inscription réussie !"), backgroundColor: Colors.green),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0C2535),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            children: [
              const Text("Inscription", style: TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold)),
              const SizedBox(height: 20),
              TextField(controller: _nomController, decoration: const InputDecoration(labelText: "Nom")),
              TextField(controller: _passwordController, decoration: const InputDecoration(labelText: "Mot de passe"), obscureText: true),
              TextField(controller: _confirmPasswordController, decoration: const InputDecoration(labelText: "Confirmer le mot de passe"), obscureText: true),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: _register,
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF65C441),
                  foregroundColor: Colors.black,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
                ),
                child: const Text("S'inscrire"),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
