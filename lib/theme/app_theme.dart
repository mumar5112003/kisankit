import 'package:flutter/material.dart';

class AppTheme {
  // Primary and scaffold colors
  static const Color primaryColor = Color(0xFFef8535);
  static const Color secondaryColor = Color(0xFF763c00);
  static const Color scaffoldBackgroundColor = Color(0xFFf9f7dc);
  static const Color buttonTextColor =
      Colors.black; // Define the button text color

  // Function to get the theme based on locale
  static ThemeData getTheme(Locale locale) {
    return ThemeData(
      primaryColor: primaryColor,
      scaffoldBackgroundColor: scaffoldBackgroundColor,
      appBarTheme: AppBarTheme(
        color: primaryColor,
        titleTextStyle: TextStyle(
          fontFamily:
              locale.languageCode == 'ur' ? 'Jameel Noori Nastaleeq' : 'Inter',
          fontSize: 20,
          color: Colors.black,
        ),
      ),
      textTheme: TextTheme(
        bodyLarge: TextStyle(
          fontFamily:
              locale.languageCode == 'ur' ? 'Jameel Noori Nastaleeq' : 'Inter',
          color: Colors.black,
        ),
        bodyMedium: TextStyle(
          fontFamily:
              locale.languageCode == 'ur' ? 'Jameel Noori Nastaleeq' : 'Inter',
          color: secondaryColor,
        ),
        bodySmall: TextStyle(
          fontFamily:
              locale.languageCode == 'ur' ? 'Jameel Noori Nastaleeq' : 'Inter',
          color: Colors.black,
        ),
      ),
      buttonTheme: ButtonThemeData(
        textTheme: ButtonTextTheme
            .primary, // Ensure the button text color uses the primary color
        buttonColor: primaryColor, // Set button background color if needed
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: primaryColor, // Set button background color
          foregroundColor: buttonTextColor, // Set button text color
        ),
      ),
      fontFamily:
          locale.languageCode == 'ur' ? 'Jameel Noori Nastaleeq' : 'Inter',
    );
  }
}
