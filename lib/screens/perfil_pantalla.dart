import 'package:flutter/material.dart';

import '../Models/datos_ejemplo.dart';
import '../widgets/componentes.dart';

class PerfilPantalla extends StatefulWidget {
  const PerfilPantalla({super.key, required this.datos});
  final DatosEjemplo datos;
  @override
  State<PerfilPantalla> createState() => _PerfilPantallaState();
}

class _PerfilPantallaState extends State<PerfilPantalla> {
  final formulario = GlobalKey<FormState>();
  late final TextEditingController nombre, correo, direccion;
  @override
  void initState() {
    super.initState();
    final u = widget.datos.usuarioActual!;
    nombre = TextEditingController(text: u.nombre);
    correo = TextEditingController(text: u.correo);
    direccion = TextEditingController(text: u.direccion);
  }

  @override
  void dispose() {
    nombre.dispose();
    correo.dispose();
    direccion.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => Scaffold(
    appBar: AppBar(title: const Text('Thank U Music')),
    body: ContenidoPagina(
      width: 650,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const TituloSeccion('Mi perfil'),
          Tarjeta(
            child: Form(
              key: formulario,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  const Center(
                    child: CircleAvatar(
                      radius: 48,
                      child: Icon(Icons.person_outline, size: 54),
                    ),
                  ),
                  const SizedBox(height: 32),
                  CampoTexto('Nombre completo', nombre),
                  CampoTexto('Correo electrónico', correo, correo: true),
                  CampoTexto('Dirección', direccion, validator: (_) => null),
                  FilledButton(
                    onPressed: () {
                      if (!formulario.currentState!.validate()) return;
                      final u = widget.datos.usuarioActual!;
                      if (widget.datos.usuarios.any(
                        (other) =>
                            other != u &&
                            other.correo.toLowerCase() ==
                                correo.text.trim().toLowerCase(),
                      )) {
                        mostrarAviso(context, 'Ese correo ya está registrado.');
                        return;
                      }
                      u.nombre = nombre.text.trim();
                      u.correo = correo.text.trim();
                      u.direccion = direccion.text.trim();
                      widget.datos.actualizar();
                      mostrarAviso(context, 'nomanches ni base de datos tnego, no guarde xd');
                    },
                    child: const Text('Guardar cambios'),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    ),
  );
}
