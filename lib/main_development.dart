import 'package:ezycourse/app/app.dart';
import 'package:flutter/material.dart';
import 'app/app_di/app_di.dart' as di;
import 'flavors/development.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  configureDevelopment();
  await di.init();
  runApp(const MyApp());
}
