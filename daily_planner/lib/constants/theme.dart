import 'package:flutter/material.dart';

class AppTheme {
  const AppTheme();

  // @override
  static ThemeData getAppTheme() {
    return ThemeData(
      useMaterial3: true,

      // Define the default brightness and colors.
      colorScheme: ColorScheme.fromSeed(
        seedColor: const Color(0xFF0C7489),
        // ···
        // primary: const Color(0xFF0C7489),
        // primary: const Color(0xFFFCBF49),
        // colors: [
        //     Color(0xff4B39EF),
        //     Color(0xffFF5963),
        //     Color(0xffEE8B60),
        //   ],
        // secondary: const Color(0xFFDD614A),
        // tertiary: Color(0xFF003049),
        // tertiary: Color(0xFF01295F)
        // tertiary: const Color(0xFFA8DCD9),
        // background: Colors.white,
        brightness: Brightness.light,
      ),

      // Define the default `TextTheme`. Use this to specify the default
      // text styling for headlines, titles, bodies of text, and more.
      textTheme: const TextTheme(
        displaySmall: TextStyle(fontSize: 20.0, fontWeight: FontWeight.bold),
        displayMedium: TextStyle(fontSize: 48.0, fontWeight: FontWeight.bold),
        displayLarge: TextStyle(fontSize: 72.0, fontWeight: FontWeight.bold),
        // displayLarge: TextStyle(
        //   fontSize: 72,
        //   fontWeight: FontWeight.bold,
        // ),
        // ···
        // titleLarge: GoogleFonts.oswald(
        //   fontSize: 30,
        //   fontStyle: FontStyle.italic,
        // ),
        // bodyMedium: GoogleFonts.merriweather(),
        // displaySmall: GoogleFonts.pacifico(),
      ),

      // iconTheme: const IconThemeData(
      //   color: Colors.white,
      // ),

      // iconButtonTheme: IconButtonThemeData(
      //   style: ButtonStyle(iconColor: MaterialStateProperty.all(Colors.white)),
      // ),
    );
  }
}
