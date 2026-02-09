import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

import 'global.dart'; // ⚠️ adapte le chemin selon ton organisation
import 'formulaire_de_questions.dart'; // ⚠️ idem

class AuthPage extends StatefulWidget {
  const AuthPage({super.key});

  @override
  State<AuthPage> createState() => _AuthPageState();
}

class _AuthPageState extends State<AuthPage> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _adminController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  bool _obscurePassword = true;

  Future<void> getListeRegionAndCommune() async {
    try {
      final response = await http.get(Uri.parse("$baseUrl&task=getListeCommuneByRegion"));
      if (response.statusCode == 200) {
        final jsonResponse = json.decode(response.body);
        final rawData = jsonResponse['result']['data'];
        final Map<String, dynamic> data = Map<String, dynamic>.from(rawData);

        dataListeRegionAndCommune = data.map((key, value) {
          final List<Map<String, dynamic>> communes = List<Map<String, dynamic>>.from(
            (value as List).map((e) => Map<String, dynamic>.from(e)),
          );
          return MapEntry(key, communes);
        });
        dataListeRegion = dataListeRegionAndCommune.keys.toList();

        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (_) => FormulaireQuestionsPage(),
          ),
        );
      } else {
        print("Erreur du serveur");
      }
    } catch (e) {
      print("Erreur: $e");
    }
  }

  void _login() {
    if (_formKey.currentState!.validate()) {
      String username = _adminController.text.trim();
      String password = _passwordController.text.trim();

      if (username == "marie" && password == "marie224") {
        getListeRegionAndCommune();
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text("Nom d'utilisateur ou mot de passe incorrect"),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Authentification Admin")),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                controller: _adminController,
                decoration: const InputDecoration(labelText: "Nom de l'admin"),
                validator: (value) =>
                value == null || value.isEmpty ? "Champ obligatoire" : null,
              ),
              TextFormField(
                controller: _passwordController,
                obscureText: _obscurePassword,
                decoration: InputDecoration(
                  labelText: "Mot de passe",
                  suffixIcon: IconButton(
                    icon: Icon(
                      _obscurePassword ? Icons.visibility : Icons.visibility_off,
                    ),
                    onPressed: () {
                      setState(() {
                        _obscurePassword = !_obscurePassword;
                      });
                    },
                  ),
                ),
                validator: (value) =>
                value == null || value.isEmpty ? "Champ obligatoire" : null,
              ),
              const SizedBox(height: 30),
              ElevatedButton(
                child: const Text("Connexion"),
                onPressed: _login,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
