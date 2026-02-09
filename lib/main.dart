/*import 'dart:io';

import 'package:flutter/material.dart';
import 'Service/http_overrides.dart';
import 'installation_mini_centrale_pv.dart';
import 'connexion.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  WidgetsFlutterBinding.ensureInitialized();
  HttpOverrides.global = MyHttpOverrides();
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const MaterialApp(
    debugShowCheckedModeBanner: false,
    home: AuthPage(),
  ));
}*/
import 'package:flutter/material.dart';
import 'connexion.dart';

void main() {
  runApp(MyApp()); // sans const
}

class MyApp extends StatelessWidget {
  MyApp({super.key}); // tu peux garder const si tu veux, mais pas obligatoire

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: AuthPage(),
    );
  }
}


