import 'package:flutter/material.dart';

class ThemeProvider extends ChangeNotifier {
  var themeMode = ThemeMode.dark;

  static final ThemeData darkTheme = ThemeData(
    scaffoldBackgroundColor: Colors.black,
    textTheme: TextTheme(
        titleLarge: const TextStyle(
          fontSize: 64,
          color: Colors.white,
        ),
        titleSmall:
            TextStyle(fontSize: 40, color: Colors.white.withOpacity(0.4)),
        bodyLarge: const TextStyle(
          fontSize: 32,
          color: Colors.white,
        )),
    colorScheme: const ColorScheme.dark(
        primary: Color(0xff4B5EFC),
        secondary: Color(0xff2E2F38),
        surface: Color(0xff4E505F)),
  );

  static final ThemeData lightTheme = ThemeData(
    scaffoldBackgroundColor: const Color(0xffF1F2F3),
    textTheme: TextTheme(
        titleLarge: const TextStyle(
          fontSize: 64,
          color: Colors.black,
        ),
        titleSmall:
            TextStyle(fontSize: 40, color: Colors.black.withOpacity(0.4)),
        bodyLarge: const TextStyle(
          fontSize: 32,
          color: Colors.black,
        )),
    colorScheme: const ColorScheme.light(
        primary: Color(0xff4B5EFC),
        secondary: Color(0xffFFFFFF),
        surface: Color(0xffdddee5)),
  );

  void changeTheme() {
    themeMode = themeMode == ThemeMode.dark ? ThemeMode.light : ThemeMode.dark;
    notifyListeners();
  }
}
