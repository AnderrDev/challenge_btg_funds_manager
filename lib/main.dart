import 'dart:async';
import 'package:flutter/material.dart';
import 'core/di/injection_container.dart';
import 'app.dart';

void main() {
  runZonedGuarded(() async {
    WidgetsFlutterBinding.ensureInitialized();
    await initDependencies();
    runApp(const App());
  }, (error, stack) {
    debugPrint('GLOBAL ERROR: $error');
    debugPrint('STACK TRACE: $stack');
  });
}
