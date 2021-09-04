import 'dart:async';

import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:kanban/ui/my_app.dart';

import 'di/components/service_locator.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await setPreferredOrientations();
  await setupLocator();
  return runZonedGuarded(() async {
    await Firebase.initializeApp().whenComplete((){
  runApp(MyApp());
  });

  }, (error, stack) {
    print(stack);
    print(error);
  });
}

Future<void> setPreferredOrientations() {
  return SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
    DeviceOrientation.landscapeRight,
    DeviceOrientation.landscapeLeft,
  ]);
}
