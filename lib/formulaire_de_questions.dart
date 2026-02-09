import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';

import 'global.dart'; // ⚠️ nécessaire pour accéder à dataListeRegion etc.

class FormulaireQuestionsPage extends StatefulWidget {
  const FormulaireQuestionsPage({super.key});

  @override
  State<FormulaireQuestionsPage> createState() =>
      _FormulaireQuestionsPageState();
}

class _FormulaireQuestionsPageState extends State<FormulaireQuestionsPage> {
  final _formKey = GlobalKey<FormState>();

  final TextEditingController _nomProjetController = TextEditingController();
  final TextEditingController _localiteController = TextEditingController();
  final TextEditingController _regionController = TextEditingController();
  final TextEditingController _superficieController = TextEditingController();
  final TextEditingController _beneficiairesController = TextEditingController();

  String? typeSite;
  String? natureSol;
  String? topographie;
  String? exposition;
  String? orientation;
  String? typeConsommateur;
  String? selectedRegion;
  String? selectedCommune;

  List<Map<String, dynamic>> communes = [];

  @override
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
              // ... ton formulaire inchangé ...

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
              pw.Text("Questionnaire Mini-centrale PV",
                  style: pw.TextStyle(fontSize: 22, fontWeight: pw.FontWeight.bold)),
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
              const Text("E. INFRASTRUCTURES ÉLECTRIQUES",
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
              DropdownButtonFormField<String>(
                decoration: const InputDecoration(
                  labelText: "Existence d’un réseau électrique",
                ),
                items: ["Oui", "Non"]
                    .map((e) => DropdownMenuItem(value: e, child: Text(e)))
                    .toList(),
                onChanged: (val) => setState(() => reseauElectrique = val),
                validator: (value) => value == null ? "Champ obligatoire" : null,
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
