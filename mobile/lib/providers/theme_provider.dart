import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:studyo/styles/themes.dart';

/// A provider class for managing the theme mode (light or dark) of the application.
///
/// This class uses the `ChangeNotifier` mixin to provide notification capabilities
/// to listeners when the theme mode or accessibility settings change.
class ThemeProvider extends ChangeNotifier {
  /// Constructs a new instance of the `ThemeProvider` class and loads the theme
  /// settings from shared preferences.
  ThemeProvider() {
    _loadFromPrefs();
  }

  bool _darkMode = false;
  bool _isDyslexicFont = false;
  bool _isDarkMode = false;
  bool _isSpecialNeeds = false;

  /// Retrieves whether the dyslexic font is enabled.
  bool get isDyslexicFont => _isDyslexicFont;

  /// Retrieves whether the dark mode is enabled.
  bool get darkMode => _darkMode;

  /// Retrieves whether the special needs mode is enabled.
  bool get isSpecialNeeds => _isSpecialNeeds;

  /// Sets the dark mode and notifies listeners.
  ///
  /// This method updates the internal dark mode setting, saves the setting to
  /// shared preferences, and notifies all registered listeners about the change.
  ///
  /// - Parameters:
  ///   - value: A boolean value indicating whether dark mode should be enabled.
  set darkMode(bool value) {
    _darkMode = value;
    _saveToPrefs();
    notifyListeners();
  }

  /// Toggles the dark mode between light and dark and notifies listeners.
  ///
  /// This method toggles the internal dark mode setting and calls the `darkMode`
  /// setter to handle the state update and notification.
  void toggleDarkMode() {
    darkMode = !darkMode;
  }

  /// Toggles the dyslexic font setting and notifies listeners.
  ///
  /// This method toggles the internal dyslexic font setting, saves the setting
  /// to shared preferences, and notifies all registered listeners about the change.
  void toggleFont() {
    _isDyslexicFont = !_isDyslexicFont;
    _saveToPrefs();
    notifyListeners();
  }

  /// Toggles the special needs setting and notifies listeners.
  ///
  /// This method toggles the internal special needs setting, disables the dyslexic
  /// font if special needs is turned off, saves the settings to shared preferences,
  /// and notifies all registered listeners about the change.
  void toggleSpecialNeeds() {
    _isSpecialNeeds = !_isSpecialNeeds;
    if (_isSpecialNeeds == false) {
      _isDyslexicFont = false;
    }
    _saveToPrefs();
    notifyListeners();
  }

  /// Retrieves the current theme based on the dark mode and dyslexic font settings.
  ///
  /// This method returns a `ThemeData` object that is configured with the appropriate
  /// text theme based on whether the dyslexic font is enabled and whether dark mode
  /// is enabled.
  ///
  /// - Returns: A `ThemeData` object configured for the current theme settings.
  ThemeData get currentTheme {
    ThemeData baseTheme = _darkMode ? darkTheme : lightTheme;
    return baseTheme.copyWith(
      textTheme: _isDyslexicFont
          ? dyslexicTextTheme(baseTheme.textTheme)
          : defaultTextTheme(baseTheme.textTheme),
    );
  }

  /// Configures the default text theme.
  ///
  /// This method returns a `TextTheme` object with the default font family and
  /// sizes for various text styles.
  ///
  /// - Parameters:
  ///   - base: The base `TextTheme` to copy and configure.
  /// - Returns: A `TextTheme` object with the default font family and sizes.
  TextTheme defaultTextTheme(TextTheme base) {
    return base.copyWith(
      bodyMedium: const TextStyle(fontFamily: 'Roboto', fontSize: 16),
      bodyLarge: const TextStyle(fontFamily: 'Roboto', fontSize: 20),
      bodySmall: const TextStyle(fontFamily: 'Roboto'),
      titleMedium: const TextStyle(fontFamily: 'Roboto'),
      titleLarge: const TextStyle(fontFamily: 'Roboto'),
      titleSmall: const TextStyle(fontFamily: 'Roboto'),
      labelMedium: const TextStyle(fontFamily: 'Roboto'),
      labelSmall: const TextStyle(fontFamily: 'Roboto', fontSize: 20),
    );
  }

  /// Configures the dyslexic text theme.
  ///
  /// This method returns a `TextTheme` object with the dyslexic font family and
  /// sizes for various text styles.
  ///
  /// - Parameters:
  ///   - base: The base `TextTheme` to copy and configure.
  /// - Returns: A `TextTheme` object with the dyslexic font family and sizes.
  TextTheme dyslexicTextTheme(TextTheme base) {
    return base.copyWith(
      bodyMedium: const TextStyle(fontFamily: 'OpenDyslexic', fontSize: 16),
      bodyLarge: const TextStyle(fontFamily: 'OpenDyslexic', fontSize: 20),
      bodySmall: const TextStyle(fontFamily: 'OpenDyslexic'),
      titleMedium: const TextStyle(fontFamily: 'OpenDyslexic'),
      titleLarge: const TextStyle(fontFamily: 'OpenDyslexic'),
      titleSmall: const TextStyle(fontFamily: 'OpenDyslexic'),
      labelMedium: const TextStyle(fontFamily: 'OpenDyslexic'),
    );
  }

  /// Loads theme settings from shared preferences.
  ///
  /// This method retrieves the dark mode and dyslexic font settings from shared
  /// preferences and updates the internal state accordingly. It then notifies all
  /// registered listeners about the changes.
  _loadFromPrefs() async {
    final prefs = await SharedPreferences.getInstance();
    _isDyslexicFont = prefs.getBool('isDyslexicFont') ?? false;
    _isDarkMode = prefs.getBool('isDarkMode') ?? false;
    notifyListeners();
  }

  /// Saves theme settings to shared preferences.
  ///
  /// This method saves the current dark mode and dyslexic font settings to shared
  /// preferences.
  _saveToPrefs() async {
    final prefs = await SharedPreferences.getInstance();
    prefs.setBool('isDyslexicFont', _isDyslexicFont);
    prefs.setBool('isDarkMode', _isDarkMode);
  }
}
