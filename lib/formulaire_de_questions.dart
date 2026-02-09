import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';

import 'global.dart';

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

  List<Map<String, dynamic>> communes = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,

      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [
              Colors.white,
              Colors.white,
            ],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          child: Center(
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 700),
              child: Card(
                color: const Color(0xFF0C2535),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20),
                  side: BorderSide(
                    color: Colors.white.withOpacity(0.06),
                  ),
                ),
                elevation: 14,
                shadowColor: Colors.black.withOpacity(0.5),
                child: Padding(
                  padding:
                  const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
                  child: Form(
                    key: _formKey,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          "Questionnaire IMC_PV",
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.w800,
                            color: Colors.white,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          "Veuillez renseigner les informations principales du projet.",
                          style: TextStyle(
                            fontSize: 12,
                            color: Colors.white.withOpacity(0.7),
                          ),
                        ),
                        const SizedBox(height: 18),

                        // Nom du projet
                        _label("Nom du projet"),
                        _textField(
                          controller: _nomProjetController,
                          hint: "Ex : Mini-centrale solaire de Kankan",
                        ),
                        const SizedBox(height: 14),

                        // Localité
                        _label("Localité"),
                        _textField(
                          controller: _localiteController,
                          hint: "Village / quartier / lieu-dit",
                        ),
                        const SizedBox(height: 14),

                        // Région (via dataListeRegion)
                        _label("Région"),
                        DropdownButtonFormField<String>(
                          value: selectedRegion,
                          iconEnabledColor: Colors.white70,
                          dropdownColor: const Color(0xFF0C2535),
                          decoration: _fieldDecoration(),
                          style: const TextStyle(color: Colors.white),
                          items: dataListeRegion
                              .map<DropdownMenuItem<String>>(
                                (region) => DropdownMenuItem<String>(
                              value: region,
                              child: Text(region),
                            ),
                          )
                              .toList(),
                          onChanged: (value) {
                            setState(() {
                              selectedRegion = value;
                              communes = getCommunesParRegion(value!);
                              selectedCommune = null;
                              _regionController.text = value;
                            });
                          },
                          validator: (value) =>
                          value == null ? "Champ obligatoire" : null,
                        ),
                        const SizedBox(height: 14),

                        // Commune
                        _label("Commune"),
                        DropdownButtonFormField<String>(
                          value: selectedCommune,
                          iconEnabledColor: Colors.white70,
                          dropdownColor: const Color(0xFF0C2535),
                          decoration: _fieldDecoration(),
                          style: const TextStyle(color: Colors.white),
                          items: communes
                              .map<DropdownMenuItem<String>>(
                                (commune) => DropdownMenuItem<String>(
                              value: commune["commune"],
                              child: Text(commune["commune"]),
                            ),
                          )
                              .toList(),
                          onChanged: (value) {
                            setState(() {
                              selectedCommune = value;
                              _localiteController.text = value ?? "";
                            });
                          },
                          validator: (value) =>
                          value == null ? "Champ obligatoire" : null,
                        ),
                        const SizedBox(height: 14),

                        // Superficie
                        _label("Superficie du site (m²)"),
                        _textField(
                          controller: _superficieController,
                          hint: "Ex : 1 500",
                          keyboardType: TextInputType.number,
                        ),
                        const SizedBox(height: 14),

                        // Bénéficiaires
                        _label("Nombre de bénéficiaires"),
                        _textField(
                          controller: _beneficiairesController,
                          hint: "Ex : 250",
                          keyboardType: TextInputType.number,
                        ),

                        const SizedBox(height: 24),
                        const Divider(color: Colors.white24, height: 1),
                        const SizedBox(height: 16),

                        // Exemple de section radio (type de site)
                        _label("Type de site"),
                        Wrap(
                          spacing: 10,
                          runSpacing: 6,
                          children: ["Urbain", "Rural", "Périurbain"].map((label) {
                            final selected = typeSite == label;
                            return ChoiceChip(
                              label: Text(
                                label,
                                style: TextStyle(
                                  fontSize: 11.5,
                                  color: selected ? Colors.black : Colors.white70,
                                ),
                              ),
                              selected: selected,
                              selectedColor: const Color(0xFF65C441),
                              backgroundColor: const Color(0xFF10293A),
                              onSelected: (_) {
                                setState(() {
                                  typeSite = label;
                                });
                              },
                            );
                          }).toList(),
                        ),


                        const SizedBox(height: 30),
                        Center(
                          child: SizedBox(
                            width: 220,
                            height: 46,
                            child: ElevatedButton.icon(
                              icon: const Icon(Icons.arrow_forward_rounded),
                              label: const Text(
                                "Suivant",
                                style: TextStyle(
                                  fontWeight: FontWeight.w700,
                                  fontSize: 14,
                                ),
                              ),
                              onPressed: () {
                                if (_formKey.currentState!.validate()) {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (_) =>
                                          InstallationMiniCentralePvPage2(
                                            nomProjet: _nomProjetController.text,
                                            localite: _localiteController.text,
                                            region: _regionController.text,
                                            superficie: _superficieController.text,
                                            beneficiaires:
                                            _beneficiairesController.text,
                                          ),
                                    ),
                                  );
                                }
                              },
                              style: ElevatedButton.styleFrom(
                                backgroundColor: const Color(0xFF65C441),
                                foregroundColor: Colors.black,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(30),
                                ),
                                elevation: 6,
                                shadowColor: const Color(0xFF65C441)
                                    .withOpacity(0.6),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  List<Map<String, dynamic>> getCommunesParRegion(String region) {
    return dataListeRegionAndCommune[region] ?? [];
  }

  // Helpers UI
  Widget _label(String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 4),
      child: Text(
        text,
        style: const TextStyle(
          color: Colors.white70,
          fontSize: 12,
          fontWeight: FontWeight.w500,
        ),
      ),
    );
  }

  InputDecoration _fieldDecoration() {
    return InputDecoration(
      filled: true,
      fillColor: Colors.white.withOpacity(0.04),
      contentPadding:
      const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(14),
        borderSide: BorderSide(
          color: Colors.white.withOpacity(0.12),
        ),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(14),
        borderSide: BorderSide(
          color: Colors.white.withOpacity(0.12),
        ),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(14),
        borderSide: const BorderSide(
          color: Color(0xFF65C441),
          width: 1.5,
        ),
      ),
      hintStyle: TextStyle(
        color: Colors.white.withOpacity(0.45),
        fontSize: 12,
      ),
    );
  }

  Widget _textField({
    required TextEditingController controller,
    required String hint,
    TextInputType? keyboardType,
  }) {
    return TextFormField(
      controller: controller,
      style: const TextStyle(color: Colors.white),
      keyboardType: keyboardType,
      decoration: _fieldDecoration().copyWith(hintText: hint),
      validator: (value) =>
      value == null || value.isEmpty ? "Champ obligatoire" : null,
    );
  }
}

class _ChipOption {
  final String label;
  _ChipOption(this.label);
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
      backgroundColor: Colors.white,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.white,
        centerTitle: true,
        title: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Image.asset(
              "assets/images/img2.png",
              height: 28,
              fit: BoxFit.cover,
            ),
            const SizedBox(width: 8),
            const Text(
              "Guinea Energy",
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w700,
              ),
            ),
          ],
        ),
      ),
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [
              Colors.white,
              Colors.white,
            ],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          child: Center(
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 700),
              child: Card(
                color: const Color(0xFF0C2535),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20),
                  side: BorderSide(
                    color: Colors.white.withOpacity(0.06),
                  ),
                ),
                elevation: 14,
                shadowColor: Colors.black.withOpacity(0.5),
                child: Padding(
                  padding:
                  const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
                  child: Form(
                    key: _formKey,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          "E. INFRASTRUCTURES ÉLECTRIQUES",
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.w800,
                            color: Colors.white,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          "Précisez la présence d’un réseau électrique et vos observations.",
                          style: TextStyle(
                            fontSize: 12,
                            color: Colors.white.withOpacity(0.7),
                          ),
                        ),
                        const SizedBox(height: 18),

                        Text(
                          "Existence d’un réseau électrique",
                          style: const TextStyle(
                            color: Colors.white70,
                            fontSize: 12,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        const SizedBox(height: 6),
                        DropdownButtonFormField<String>(
                          decoration: _fieldDecorationPage2(),
                          dropdownColor: const Color(0xFF0C2535),
                          iconEnabledColor: Colors.white70,
                          style: const TextStyle(color: Colors.white),
                          items: ["Oui", "Non"]
                              .map(
                                (e) => DropdownMenuItem(
                              value: e,
                              child: Text(e),
                            ),
                          )
                              .toList(),
                          onChanged: (val) =>
                              setState(() => reseauElectrique = val),
                          validator: (value) =>
                          value == null ? "Champ obligatoire" : null,
                        ),
                        const SizedBox(height: 16),

                        Text(
                          "Observations",
                          style: const TextStyle(
                            color: Colors.white70,
                            fontSize: 12,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        const SizedBox(height: 6),
                        TextFormField(
                          controller: _observationsController,
                          maxLines: 4,
                          style: const TextStyle(color: Colors.white),
                          decoration: _fieldDecorationPage2().copyWith(
                            hintText: "Ajoutez des détails complémentaires…",
                          ),
                        ),
                        const SizedBox(height: 26),

                        Center(
                          child: SizedBox(
                            width: 220,
                            height: 46,
                            child: ElevatedButton.icon(
                              icon: const Icon(Icons.picture_as_pdf_outlined),
                              label: const Text(
                                "Générer PDF",
                                style: TextStyle(
                                  fontWeight: FontWeight.w700,
                                  fontSize: 14,
                                ),
                              ),
                              onPressed: () async {
                                if (_formKey.currentState!.validate()) {
                                  await Printing.layoutPdf(
                                    onLayout: (format) => _generatePdf(),
                                  );
                                }
                              },
                              style: ElevatedButton.styleFrom(
                                backgroundColor: const Color(0xFF65C441),
                                foregroundColor: Colors.black,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(30),
                                ),
                                elevation: 6,
                                shadowColor: const Color(0xFF65C441)
                                    .withOpacity(0.6),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  InputDecoration _fieldDecorationPage2() {
    return InputDecoration(
      filled: true,
      fillColor: Colors.white.withOpacity(0.04),
      contentPadding:
      const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(14),
        borderSide: BorderSide(
          color: Colors.white.withOpacity(0.12),
        ),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(14),
        borderSide: BorderSide(
          color: Colors.white.withOpacity(0.12),
        ),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(14),
        borderSide: const BorderSide(
          color: Color(0xFF65C441),
          width: 1.5,
        ),
      ),
      hintStyle: TextStyle(
        color: Colors.white.withOpacity(0.45),
        fontSize: 12,
      ),
    );
  }
}
