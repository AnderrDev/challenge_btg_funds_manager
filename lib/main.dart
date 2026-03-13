import 'package:flutter/material.dart';
import 'core/di/injection_container.dart';
import 'app.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  initDependencies();
  runApp(const App());
}
