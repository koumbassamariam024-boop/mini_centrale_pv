import 'dart:io';

import 'package:flutter/material.dart';
import 'Service/http_overrides.dart';
import 'installation_mini_centrale_pv.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  WidgetsFlutterBinding.ensureInitialized();
  HttpOverrides.global = MyHttpOverrides();
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const MaterialApp(
    debugShowCheckedModeBanner: false,
    home: AuthPage(),
  ));
}
