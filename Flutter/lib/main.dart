import 'package:evaluaciones_web/ui/layout/main_layout_page.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

import 'package:evaluaciones_web/locator.dart';
import 'package:evaluaciones_web/router/router.dart';
import 'package:evaluaciones_web/services/navigation_service.dart';

Future<void> main() async {
  
  setupLocator();
  Flurorouter.configureRoutes();

  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: const FirebaseOptions(
      apiKey: "AIzaSyDEyco-5MWYGiznV8JcFkBVmY_ZXh4VA0k",
      authDomain: "evaluaciones-web-iisch.firebaseapp.com",
      projectId: "evaluaciones-web-iisch",
      storageBucket: "evaluaciones-web-iisch.appspot.com",
      messagingSenderId: "526496109970",
      appId: "1:526496109970:web:fbc13e6290bb2c8e3edd4b",
      measurementId: "G-QVY9S07GRC"
    )
  );

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {

  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Evaluaciones Web',
      initialRoute: '/inicio',
      debugShowCheckedModeBanner: false,
      onGenerateRoute: Flurorouter.router.generator,
      navigatorKey: locator<NavigationService>().navigatorKey,
      builder: ( _, child ) {
        return MainLayoutPage(
          child: child ?? Container(),
        );
      },
      theme: ThemeData.light().copyWith(
        scaffoldBackgroundColor: Colors.white
      ),
    );
  }
}