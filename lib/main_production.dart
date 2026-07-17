import 'package:flutter/material.dart';
import 'app/app.dart';
import 'app/app_di/app_di.dart' as di;
import 'flavors/production.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  configureProduction();
  await di.init();
  runApp(const MyApp());
}
