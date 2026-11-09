import 'package:flutter/material.dart';

import '../Models/datos_ejemplo.dart';
import '../widgets/componentes.dart';
import 'registro_pantalla.dart';

class InicioSesionPantalla extends StatefulWidget {
  const InicioSesionPantalla({super.key, required this.datos});
  final DatosEjemplo datos;
  @override
  State<InicioSesionPantalla> createState() => _InicioSesionPantallaState();
}

class _InicioSesionPantallaState extends State<InicioSesionPantalla> {
  final formulario = GlobalKey<FormState>();
  final correo = TextEditingController();
  final contrasena = TextEditingController();
  @override
  void dispose() {
    correo.dispose();
    contrasena.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => Scaffold(
    body: SafeArea(
      child: ContenidoPagina(
        width: 550,
        child: Tarjeta(
          child: Form(
            key: formulario,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Image.asset(
                  'assets/logo.jpeg',
                  height: 100,
                  fit: BoxFit.contain,
                ),
                const SizedBox(height: 24),
                const TituloSeccion('Iniciar sesión'),
                CampoTexto('Correo electrónico', correo, correo: true),
                CampoTexto('Contraseña', contrasena, oculto: true),
                FilledButton(
                  onPressed: () {
                    if (!formulario.currentState!.validate()) return;
                    // Solo navegación de las vistas, sin validar credenciales contra un servidor.
                    widget.datos.entrarVista(
                      correo.text.trim().toLowerCase() == 'admin@gmail.com',
                    );
                  },
                  child: const Text('Entrar'),
                ),
                TextButton(
                  onPressed: () => showDialog<void>(
                    context: context,
                    builder: (context) => AlertDialog(
                      title: const Text('Recuperar contraseña'),
                      content: const Text(
                        'pues aun no la hice',
                      ),
                      actions: [
                        TextButton(
                          onPressed: () => Navigator.pop(context),
                          child: const Text('Cerrar'),
                        ),
                      ],
                    ),
                  ),
                  child: const Text('¿Olvidaste tu contraseña?'),
                ),
                TextButton(
                  onPressed: () => Navigator.push(
                    context,
                    MaterialPageRoute<void>(
                      builder: (_) => RegistroPantalla(datos: widget.datos),
                    ),
                  ),
                  child: const Text('¿No tienes cuenta? Regístrate'),
                ),
              ],
            ),
          ),
        ),
      ),
    ),
  );
}
