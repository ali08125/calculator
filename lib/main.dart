import 'package:calculator/config/theme.dart';
import 'package:calculator/features//calculate/calculate_screen.dart';
import 'package:calculator/features/calculate/provider/operation_provider.dart';
import 'package:calculator/features/calculate/provider/result_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (BuildContext context) => ThemeProvider(),
        ),
        ChangeNotifierProvider(
          create: (BuildContext context) => OperationProvider(),
        ),
        ChangeNotifierProvider(
          create: (BuildContext context) => ResultProvider(),
        ),
      ],
      child: Consumer<ThemeProvider>(
        builder: (context, value, child) => MaterialApp(
            debugShowCheckedModeBanner: false,
            title: 'Calculator',
            themeMode: value.themeMode,
            theme: ThemeProvider.lightTheme,
            darkTheme: ThemeProvider.darkTheme,
            home: const CalculateScreen()),
      ),
    );
  }
}
