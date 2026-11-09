import 'package:flutter/material.dart';

import 'Models/datos_ejemplo.dart';
import 'screens/inicio_sesion_pantalla.dart';
import 'screens/inicio_pantalla.dart';

void main() => runApp(AplicacionThankUMusic());
const colorPrincipal = Color(0xFFB50020);

class AplicacionThankUMusic extends StatelessWidget {
  AplicacionThankUMusic({super.key, DatosEjemplo? datos})
    : datos = datos ?? DatosEjemplo();
  final DatosEjemplo datos;
  @override
  Widget build(BuildContext context) => MaterialApp(
    title: 'Thank U Music',
    debugShowCheckedModeBanner: false,
    theme: ThemeData(
      useMaterial3: true,
      colorScheme: ColorScheme.fromSeed(
        seedColor: colorPrincipal,
        primary: colorPrincipal,
        surface: Colors.white,
      ),
      scaffoldBackgroundColor: const Color(0xFFFFF7F8),
      appBarTheme: const AppBarTheme(
        backgroundColor: colorPrincipal,
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
      listenable: datos,
      builder: (_, _) => datos.usuarioActual == null
          ? InicioSesionPantalla(datos: datos)
          : InicioPantalla(datos: datos),
    ),
  );
}
