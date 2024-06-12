import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

///Light theme data for the application.
final ThemeData lightTheme = ThemeData(
  primaryColor: Color.fromRGBO(234, 128, 35, 1),
  hintColor: Color.fromRGBO(5, 173, 154, 1),
  primaryColorLight: Color.fromRGBO(27, 27, 27, 1),
  primaryColorDark: Color.fromARGB(255, 232, 232, 232),
  focusColor: const Color.fromRGBO(245, 245, 245, 1),
  brightness: Brightness.light,
  textTheme: GoogleFonts.robotoTextTheme(),
);

///Dark theme dats for the application.
final ThemeData darkTheme = ThemeData(
  primaryColor: const Color.fromRGBO(234, 115, 23, 1),
  hintColor: Color.fromRGBO(0, 187, 168, 1),
  primaryColorLight: Colors.white,
  primaryColorDark: Color.fromRGBO(39, 39, 39, 1),
  focusColor: const Color.fromARGB(255, 117, 117, 117),
  brightness: Brightness.dark,
  textTheme: GoogleFonts.robotoTextTheme(),
);
