import 'package:flutter/material.dart';

class AppTheme {
  const AppTheme();

  // @override
  static ThemeData getAppTheme() {
    return ThemeData(
      useMaterial3: true,

      // Define the default brightness and colors.
      colorScheme: ColorScheme.fromSeed(
        seedColor: Colors.yellow.shade600,
        // ···
        primary: Color(0xFFFCBF49),
        secondary: Color(0xFFDD614A),
        // tertiary: Color(0xFF003049),
        tertiary: Color(0xFFA8DCD9),
        brightness: Brightness.dark,
      ),

      // Define the default `TextTheme`. Use this to specify the default
      // text styling for headlines, titles, bodies of text, and more.
      textTheme: const TextTheme(
        displayLarge: TextStyle(
          fontSize: 72,
          fontWeight: FontWeight.bold,
        ),
        // ···
        // titleLarge: GoogleFonts.oswald(
        //   fontSize: 30,
        //   fontStyle: FontStyle.italic,
        // ),
        // bodyMedium: GoogleFonts.merriweather(),
        // displaySmall: GoogleFonts.pacifico(),
      ),
    );
  }
}
