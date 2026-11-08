import 'package:flutter/material.dart';

import 'data/blog_store.dart';
import 'screens/auth.dart';
import 'screens/home.dart';

void main() => runApp(ThankUMusicApp());
const brand = Color(0xFFB50020);

class ThankUMusicApp extends StatelessWidget {
  ThankUMusicApp({super.key, BlogStore? store}) : store = store ?? BlogStore();
  final BlogStore store;
  @override
  Widget build(BuildContext context) => MaterialApp(
    title: 'Thank U Music',
    debugShowCheckedModeBanner: false,
    theme: ThemeData(
      useMaterial3: true,
      colorScheme: ColorScheme.fromSeed(
        seedColor: brand,
        primary: brand,
        surface: Colors.white,
      ),
      scaffoldBackgroundColor: const Color(0xFFFFF7F8),
      appBarTheme: const AppBarTheme(
        backgroundColor: brand,
        foregroundColor: Colors.white,
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: Colors.white,
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
        contentPadding: const EdgeInsets.all(16),
      ),
      filledButtonTheme: FilledButtonThemeData(
        style: FilledButton.styleFrom(
          minimumSize: const Size(0, 48),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
      ),
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(minimumSize: const Size(0, 48)),
      ),
    ),
    home: ListenableBuilder(
      listenable: store,
      builder: (_, _) => store.current == null
          ? AuthScreen(store: store)
          : HomeScreen(store: store),
    ),
  );
}
