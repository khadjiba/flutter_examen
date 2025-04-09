import 'package:ba_khadjiratou_l3gl_examen/provider/auth_controller.dart';
import 'package:ba_khadjiratou_l3gl_examen/provider/project_controller.dart';
import 'package:ba_khadjiratou_l3gl_examen/provider/tache_provider.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'config/route.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(); // Initialisation Firebase

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => AuthController()),
        ChangeNotifierProvider(create: (_) => ProjectController()..fetchProjects()),
        ChangeNotifierProvider(create: (_) => TacheProvider()),

      ],

      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      initialRoute: '/',
      routes: appRoutes,

    );
  }
}