import 'package:flutter/material.dart';

const Color primaryColor = Color.fromARGB(255, 249, 204, 25);
const Color secondaryColor = Color.fromARGB(255, 225, 103, 21);
const Color accentColor = Color.fromARGB(255, 255, 87, 34);

/// Text style for headings in the application.
const TextStyle headingStyle = TextStyle(
  fontFamily: 'Roboto',
  fontWeight: FontWeight.bold,
  color: primaryColor,
  fontSize: 28,
);

/// Text style for titles in the application.
const TextStyle titleStyle = TextStyle(
  fontSize: 22,
  fontWeight: FontWeight.bold,
  color: secondaryColor,
);

/// Text style for body text in the application.
const TextStyle bodyText = TextStyle(
  fontSize: 16,
  color: Color.fromARGB(230, 30, 30, 30),
);

/// Button style for raised buttons in the application.
ButtonStyle raisedButtonStyle = ElevatedButton.styleFrom(
  backgroundColor: secondaryColor,
  foregroundColor: Colors.white,
  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
  padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 24),
  textStyle: const TextStyle(
    fontSize: 16,
    fontWeight: FontWeight.bold,
  ),
);

/// BoxDecoration for containers in the application with gradient colors.
BoxDecoration containerDecoration(List<Color> colors) => BoxDecoration(
      borderRadius: BorderRadius.circular(20),
      gradient: const LinearGradient(
        colors: [primaryColor, secondaryColor],
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
      ),
    );

/// InputDecorationTheme for consistent input decoration styling in the application.
InputDecorationTheme inputDecorationTheme() {
  return InputDecorationTheme(
    fillColor: Colors.white,
    filled: true,
    border: OutlineInputBorder(
      borderRadius: BorderRadius.circular(15),
      borderSide: const BorderSide(color: secondaryColor, width: 2),
    ),
    enabledBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(15),
      borderSide: const BorderSide(color: secondaryColor, width: 1.5),
    ),
    focusedBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(15),
      borderSide: const BorderSide(color: accentColor, width: 2),
    ),
    hintStyle: bodyText,
  );
}
