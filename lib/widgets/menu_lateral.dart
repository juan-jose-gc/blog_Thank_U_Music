import 'package:flutter/material.dart';

import '../Models/usuario_model.dart';

class MenuLateral extends StatelessWidget {
  const MenuLateral({
    super.key,
    required this.usuario,
    required this.seccion,
    required this.alIrInicio,
    required this.alIrPerfil,
    required this.alRegistrar,
    required this.alGestionar,
    required this.alAgregar,
    required this.alEditar,
    required this.alCerrarSesion,
  });
  final Usuario usuario;
  final String seccion;
  final VoidCallback alIrInicio,
      alIrPerfil,
      alRegistrar,
      alGestionar,
      alAgregar,
      alEditar,
      alCerrarSesion;

  @override
  Widget build(BuildContext context) {
    Widget opcion(String titulo, IconData icono, VoidCallback accion) =>
        ListTile(
          leading: Icon(icono, color: const Color(0xFFB50020)),
          title: Text(titulo),
          selected: titulo == seccion,
          onTap: () {
            Navigator.pop(context);
            accion();
          },
        );
    return Drawer(
      child: SafeArea(
        child: ListView(
          children: [
            UserAccountsDrawerHeader(
              decoration: const BoxDecoration(color: Color(0xFFFFE4E9)),
              currentAccountPicture: const CircleAvatar(
                child: Icon(Icons.person_outline),
              ),
              accountName: Text(
                usuario.nombre,
                style: const TextStyle(
                  color: Color(0xFFB50020),
                  fontWeight: FontWeight.bold,
                ),
              ),
              accountEmail: Text(
                usuario.correo,
                style: const TextStyle(color: Colors.black54),
              ),
            ),
            opcion('Inicio', Icons.home_outlined, alIrInicio),
            opcion('Mi perfil', Icons.person_outline, alIrPerfil),
            if (usuario.administrador) ...[
              opcion(
                'Registrar usuario',
                Icons.person_add_outlined,
                alRegistrar,
              ),
              opcion('Gestionar usuarios', Icons.group_outlined, alGestionar),
              opcion('Agregar publicación', Icons.post_add, alAgregar),
              opcion('Editar publicaciones', Icons.edit_outlined, alEditar),
            ],
            const Divider(),
            opcion('Cerrar sesión', Icons.logout, alCerrarSesion),
          ],
        ),
      ),
    );
  }
}
