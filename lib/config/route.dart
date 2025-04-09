import 'package:ba_khadjiratou_l3gl_examen/screens/auth/register_screen.dart';
import 'package:ba_khadjiratou_l3gl_examen/screens/projet/home_screen.dart';
import 'package:ba_khadjiratou_l3gl_examen/screens/projet/create_projet_screen.dart';
import 'package:flutter/cupertino.dart';

import '../screens/auth/login_screen.dart';

final Map<String, WidgetBuilder> appRoutes = {
  '/': (context) => LoginScreen(),
  '/home' : (context) => HomeScreen(),
    '/addProjet': (context) => CreateProjectScreen(),
  '/register':(context) => RegisterScreen(),
};