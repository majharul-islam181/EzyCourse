import 'package:flutter/material.dart';
import 'app/app.dart';
import 'app/app_di/app_di.dart' as app_di;
import 'flavors/production.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  configureProduction();
  await app_di.init();
  runApp(const MyApp());
}
