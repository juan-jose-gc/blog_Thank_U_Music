import 'package:flutter/material.dart';

import '../Models/datos_ejemplo.dart';
import '../widgets/componentes.dart';

class RegistroPantalla extends StatefulWidget {
  const RegistroPantalla({
    super.key,
    required this.datos,
    this.registrarAdministrador = false,
  });
  final DatosEjemplo datos;
  final bool registrarAdministrador;
  @override
  State<RegistroPantalla> createState() => _RegistroPantallaState();
}

class _RegistroPantallaState extends State<RegistroPantalla> {
  final formulario = GlobalKey<FormState>();
  final nombre = TextEditingController(),
      correo = TextEditingController(),
      direccion = TextEditingController(),
      contrasena = TextEditingController(),
      confirmacion = TextEditingController();
  @override
  void dispose() {
    for (final controlador in [
      nombre,
      correo,
      direccion,
      contrasena,
      confirmacion,
    ]) {
      controlador.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => Scaffold(
    appBar: AppBar(title: const Text('Thank U Music')),
    body: ContenidoPagina(
      width: 550,
      child: Tarjeta(
        child: Form(
          key: formulario,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Image.asset('assets/logo.jpeg', height: 100, fit: BoxFit.contain),
              const SizedBox(height: 24),
              TituloSeccion(
                widget.registrarAdministrador
                    ? 'Registrar administrador'
                    : 'Registro',
              ),
              CampoTexto('Nombre', nombre),
              CampoTexto('Correo electrónico', correo, correo: true),
              CampoTexto('Dirección', direccion),
              CampoTexto('Contraseña', contrasena, oculto: true),
              CampoTexto(
                'Confirmar contraseña',
                confirmacion,
                oculto: true,
                validator: (valor) =>
                    valor != contrasena.text || (valor?.isEmpty ?? true)
                    ? 'Las contraseñas deben coincidir'
                    : null,
              ),
              FilledButton(
                onPressed: () {
                  if (!formulario.currentState!.validate()) return;
                  mostrarAviso(
                    context,
                    'Formulario completado. El registro aún no está conectado.',
                  );
                },
                child: Text(
                  widget.registrarAdministrador
                      ? 'Crear administrador'
                      : 'Crear cuenta',
                ),
              ),
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text('Volver'),
              ),
            ],
          ),
        ),
      ),
    ),
  );
}
