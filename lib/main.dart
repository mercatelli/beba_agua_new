
import 'package:beba_agua_new/service/auth.dart';
import 'package:flutter/material.dart';

import 'app/landing_page.dart';


void main() {
  runApp(MyApp());
}

class MyColors {

  static const MaterialColor navy = MaterialColor(
    0xFF274C77,
    <int, Color>{
      50: Color(0xFF274C77),
      100: Color(0xFF274C77),
      200: Color(0xFF274C77),
      300: Color(0xFF274C77),
      400: Color(0xFF274C77),
      500: Color(0xFF274C77),
      600: Color(0xFF274C77),
      700: Color(0xFF274C77),
      800: Color(0xFF274C77),
      900: Color(0xFF274C77),
    },
  );
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Drink Water',
      theme: ThemeData(
        primarySwatch: MyColors.navy,
      ),
      home: LandingPage(
        auth: Auth(),
      ),
    );
  }
}
