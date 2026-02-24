import 'package:flutter/material.dart';
import 'package:flutter_assignment/routes/app_routes.dart';
import 'package:flutter_assignment/routes/page_routes.dart';
import 'package:google_fonts/google_fonts.dart';

void main() {
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(textTheme: GoogleFonts.spaceGroteskTextTheme()),
      debugShowCheckedModeBanner: false,
      initialRoute: AppRoutes.splash,
      onGenerateRoute: PageRoutes.onGenerateRoute,
    );
  }
}
