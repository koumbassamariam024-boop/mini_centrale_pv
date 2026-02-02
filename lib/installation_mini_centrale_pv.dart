import 'dart:convert';
import 'dart:typed_data';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';

import 'global.dart';

// ---------------- PAGE AUTHENTIFICATION ----------------
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
        // Cast correct
        final Map<String, dynamic> data = Map<String, dynamic>.from(rawData);

        dataListeRegionAndCommune = data.map((key, value) {
          final List<Map<String, dynamic>> communes = List<Map<String, dynamic>>.from(
            (value as List).map((e) => Map<String, dynamic>.from(e)),
          );
          return MapEntry(key, communes);
        });
        dataListeRegion = dataListeRegionAndCommune.keys.toList();
        print('*****************les regions***************');
        print(dataListeRegion);

        Future.delayed(const Duration(seconds: 3), () {
    Navigator.pushReplacement(
    context,
    MaterialPageRoute(
    builder: (_) => const InstallationMiniCentralePvPage1(),
    ),
    );
    });


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

// ---------------- PAGE 1 ----------------
class InstallationMiniCentralePvPage1 extends StatefulWidget {
  const InstallationMiniCentralePvPage1({super.key});

  @override
  State<InstallationMiniCentralePvPage1> createState() =>
      _InstallationMiniCentralePvPage1State();
}


class _InstallationMiniCentralePvPage1State
    extends State<InstallationMiniCentralePvPage1> {
  final _formKey = GlobalKey<FormState>();

  final TextEditingController _nomProjetController = TextEditingController();
  final TextEditingController _localiteController = TextEditingController();
  final TextEditingController _regionController = TextEditingController();
  final TextEditingController _superficieController = TextEditingController();
  final TextEditingController _beneficiairesController =
  TextEditingController();

  String? typeSite;
  String? natureSol;
  String? topographie;
  String? exposition;
  String? orientation;
  String? typeConsommateur;
  String? selectedRegion;
  String? selectedCommune;

  void initState() {

    super.initState();


  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(title: const Text("Questionnaire IMC_PV")),
        body: SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                  const Text(
                  "A. IDENTIFICATION GÉNÉRALE",
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                TextFormField(
                  controller: _nomProjetController,
                  decoration: const InputDecoration(labelText: "Nom du projet"),
                  validator: (value) =>
                  value == null || value.isEmpty ? "Champ obligatoire" : null,
                ),
                TextFormField(
                  controller: _localiteController,
                  decoration: const InputDecoration(labelText: "Localité / Site"),
                  validator: (value) =>
                  value == null || value.isEmpty ? "Champ obligatoire" : null,
                ),

                    //region
                    DropdownButtonFormField<String>(
                      value: selectedRegion,
                      decoration: InputDecoration(
                        labelText: "Votre Region*",
                        hintText: "Sélectionnez",
                        floatingLabelBehavior: FloatingLabelBehavior.always,
                        hintStyle:
                        TextStyle(color: Colors.grey.shade500, fontSize: 14),
                        labelStyle: TextStyle(
                            color: Colors.black,
                            fontSize: 18,fontWeight: FontWeight.bold),
                        enabledBorder: OutlineInputBorder(
                          borderSide:
                          BorderSide(color: Colors.grey.shade400, width: 1),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderSide:
                          BorderSide(color: Colors.grey.shade600, width: 1.5),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        errorBorder: OutlineInputBorder(
                          borderSide:
                          BorderSide(color: Colors.red.shade300, width: 1),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        isDense: true,
                      ),
                      items: dataListeRegion.map<DropdownMenuItem<String>>((region) {
                        return DropdownMenuItem<String>(
                          value: region,

                          child: Text(region),
                        );
                      }).toList(),

                      onChanged: (value) {
                        setState(() {
                          selectedRegion = value;
                          print("*****la region selectionnée est ****");
                          print(selectedRegion);

                          // Appel ici pour mettre à jour la liste des communes
                          communes = getCommunesParRegion(value!);
                          print("******les communes ****");
                          print(communes);

                          // Réinitialise la commune sélectionnée si nécessaire
                          selectedCommune = null;
                        });
                      },
                      validator: (val) =>
                      val == null ? "Champ obligatoire" : null,
                    ),

                    SizedBox(height: 12),
                    //Commune
                    DropdownButtonFormField<String>(
                      value: selectedCommune,
                      decoration: InputDecoration(
                        labelText: "Votre Commune*",
                        hintText: "Sélectionnez",
                        floatingLabelBehavior: FloatingLabelBehavior.always,
                        hintStyle:
                        TextStyle(color: Colors.grey.shade500, fontSize: 14),
                        labelStyle: TextStyle(
                            color: Colors.black,
                            fontSize: 18,fontWeight: FontWeight.bold),
                        enabledBorder: OutlineInputBorder(
                          borderSide:
                          BorderSide(color: Colors.grey.shade400, width: 1),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderSide:
                          BorderSide(color: Colors.grey.shade600, width: 1.5),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        errorBorder: OutlineInputBorder(
                          borderSide:
                          BorderSide(color: Colors.red.shade300, width: 1),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        isDense: true,
                      ),
                      items: communes.map<DropdownMenuItem<String>>((commune) {
                        return DropdownMenuItem<String>(
                          value: commune['idCommune'],
                          child: Text(commune['commune']),
                        );
                      }).toList(),
                      onChanged: (value) {
                        setState(() {
                          selectedCommune = value;
                          print("****id de la commune selectionné***");
                          print(selectedCommune);
                        });
                      },
                      validator: (val) =>
                      val == null ? "Champ obligatoire" : null,
                    ),


                TextFormField(
                  controller: _regionController,
                  decoration: const InputDecoration(labelText: "Région"),
                  validator: (value) =>
                  value == null || value.isEmpty ? "Champ obligatoire" : null,
                ),

                const SizedBox(height: 20),
                const Text(
                  "B. DESCRIPTION DU SITE",
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                DropdownButtonFormField<String>(
                  decoration: const InputDecoration(labelText: "Type de site"),
                  items: ["Terrain nu", "Toiture", "Bâtiment public", "Autre"]
                      .map((e) => DropdownMenuItem(value: e, child: Text(e)))
                      .toList(),
                  onChanged: (val) => setState(() => typeSite = val),
                  validator: (value) =>
                  value == null ? "Champ obligatoire" : null,
                ),
                TextFormField(
                  controller: _superficieController,
                  decoration: const InputDecoration(
                    labelText: "Superficie disponible (m²)",
                  ),
                  keyboardType: TextInputType.number,
                  validator: (value) =>
                  value == null || value.isEmpty ? "Champ obligatoire" : null,
                ),
                DropdownButtonFormField<String>(
                  decoration: const InputDecoration(labelText: "Nature du sol"),
                  items: [
                    "Latéritique",
                    "Sableux",
                    "Rocheux",
                    "Argileux",
                    "Autre"
                  ]
                      .map((e) => DropdownMenuItem(value: e, child: Text(e)))
                      .toList(),
                  onChanged: (val) => setState(() => natureSol = val),
                  validator: (value) =>
                  value == null ? "Champ obligatoire" : null,
                ),
                DropdownButtonFormField<String>(
                  decoration: const InputDecoration(labelText: "Topographie"),
                  items: ["Plat", "Légèrement incliné", "Fortement incliné"]
                      .map((e) => DropdownMenuItem(value: e, child: Text(e)))
                      .toList(),
                  onChanged: (val) => setState(() => topographie = val),
                  validator: (value) =>
                  value == null ? "Champ obligatoire" : null,
                ),

                const SizedBox(height: 20),
                const Text(
                  "C. DONNÉES SOLAIRES",
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                DropdownButtonFormField<String>(
                  decoration:
                  const InputDecoration(labelText: "Exposition du site"),
                  items: ["Bonne", "Moyenne", "Mauvaise"]
                      .map((e) => DropdownMenuItem(value: e, child: Text(e)))
                      .toList(),
                  onChanged: (val) => setState(() => exposition = val),
                  validator: (value) =>
                  value == null ? "Champ obligatoire" : null,
                ),
                DropdownButtonFormField<String>(
                  decoration: const InputDecoration(
                    labelText: "Orientation principale",
                  ),
                  items: ["Nord", "Sud", "Est", "Ouest"]
                      .map((e) => DropdownMenuItem(value: e, child: Text(e)))
                      .toList(),
                  onChanged: (val) => setState(() => orientation = val),
                  validator: (value) =>
                  value == null ? "Champ obligatoire" : null,
                ),

                const SizedBox(height: 20),
                const Text(
                  "D. BESOINS ÉNERGÉTIQUES",
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                DropdownButtonFormField<String>(
                  decoration: const InputDecoration(
                    labelText: "Type de consommateurs",
                  ),
                  items: [
                    "Ménages",
                    "Administration",
                    "Centre de santé",
                    "École",
                    "Unité industrielle",
                    "Mixte"
                  ]
                      .map((e) => DropdownMenuItem(value: e, child: Text(e)))
                      .toList(),
                  onChanged: (val) => setState(() => typeConsommateur = val),
                  validator: (value) =>
                  value == null ? "Champ obligatoire" : null,
                ),
                TextFormField(
                  controller: _beneficiairesController,
                  decoration: const InputDecoration(
                    labelText: "Nombre total de bénéficiaires",
                  ),
                  keyboardType: TextInputType.number,
                  validator: (value) =>
                  value == null || value.isEmpty ? "Champ obligatoire" : null,
                ),

                const SizedBox(height: 30),
                Center(
                    child: ElevatedButton(
                        child: const Text("Suivant ➡️"),
                        onPressed: () {
                          if (_formKey.currentState!.validate()) {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (_) => InstallationMiniCentralePvPage2(
                                        nomProjet: _nomProjetController.text,
                                        localite: _localiteController.text,
                                        region: _regionController.text,
                                      superficie: _superficieController.text,
                                      beneficiaires: _beneficiairesController.text,
                                    ),
                                ),
                            );
                          }
                        },
                    ),
                ),
                  ],
                ),
            ),
        ),
    );
  }




  List<Map<String, dynamic>> getCommunesParRegion(String region) {
    return dataListeRegionAndCommune[region] ?? [];
  }
}

// ---------------- PAGE 2 ----------------
class InstallationMiniCentralePvPage2 extends StatefulWidget {
  final String nomProjet;
  final String localite;
  final String region;
  final String superficie;
  final String beneficiaires;

  const InstallationMiniCentralePvPage2({
    super.key,
    required this.nomProjet,
    required this.localite,
    required this.region,
    required this.superficie,
    required this.beneficiaires,
  });

  @override
  State<InstallationMiniCentralePvPage2> createState() =>
      _InstallationMiniCentralePvPage2State();
}

class _InstallationMiniCentralePvPage2State
    extends State<InstallationMiniCentralePvPage2> {
  final _formKey = GlobalKey<FormState>();

  String? reseauElectrique;
  final TextEditingController _observationsController =
  TextEditingController();

  Future<Uint8List> _generatePdf() async {
    final pdf = pw.Document();

    pdf.addPage(
      pw.Page(
        build: (context) {
          return pw.Column(
            crossAxisAlignment: pw.CrossAxisAlignment.start,
            children: [
              pw.Text(
                "Questionnaire Mini-centrale PV",
                style: pw.TextStyle(
                  fontSize: 22,
                  fontWeight: pw.FontWeight.bold,
                ),
              ),
              pw.SizedBox(height: 20),
              pw.Text("Nom du projet : ${widget.nomProjet}"),
              pw.Text("Localité : ${widget.localite}"),
              pw.Text("Région : ${widget.region}"),
              pw.Text("Superficie : ${widget.superficie} m²"),
              pw.Text("Bénéficiaires : ${widget.beneficiaires}"),
              pw.SizedBox(height: 20),
              pw.Text("Observations :"),
              pw.Text(_observationsController.text),
            ],
          );
        },
      ),
    );

    return pdf.save();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Questionnaire PV - Page 2")),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                "E. INFRASTRUCTURES ÉLECTRIQUES",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              DropdownButtonFormField<String>(
                decoration: const InputDecoration(
                  labelText: "Existence d’un réseau électrique",
                ),
                items: ["Oui", "Non"]
                    .map((e) => DropdownMenuItem(value: e, child: Text(e)))
                    .toList(),
                onChanged: (val) => setState(() => reseauElectrique = val),
                validator: (value) =>
                value == null ? "Champ obligatoire" : null,
              ),
              TextFormField(
                controller: _observationsController,
                decoration: const InputDecoration(labelText: "Observations"),
                maxLines: 4,
              ),
              const SizedBox(height: 30),
              Center(
                child: ElevatedButton(
                  child: const Text("Générer PDF"),
                  onPressed: () async {
                    if (_formKey.currentState!.validate()) {
                      await Printing.layoutPdf(
                        onLayout: (format) => _generatePdf(),
                      );
                    }
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
