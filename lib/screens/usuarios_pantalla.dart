import 'package:flutter/material.dart';

import '../Models/datos_ejemplo.dart';
import '../widgets/componentes.dart';

class UsuariosPantalla extends StatefulWidget {
  const UsuariosPantalla({super.key, required this.datos});

  final DatosEjemplo datos;

  @override
  State<UsuariosPantalla> createState() => _UsuariosPantallaState();
}

class _UsuariosPantallaState extends State<UsuariosPantalla> {
  Future<void> edit(Usuario user, bool role) async {
    bool selected = role ? user.administrador : user.baneado;

    final result = await showDialog<bool>(
      context: context,
      builder: (dialogContext) => StatefulBuilder(
        builder: (context, update) => AlertDialog(
          title: Text(role ? 'Editar usuario' : 'Estado del usuario'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                user.nombre,
                style: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const Divider(height: 32),
              Text(role ? 'Rol del usuario' : 'Estado del usuario'),
              const SizedBox(height: 16),
              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: [
                  ChoiceChip(
                    label: Text(role ? 'Normal' : 'Activo'),
                    selected: !selected,
                    onSelected: (_) => update(() => selected = false),
                  ),
                  ChoiceChip(
                    label: Text(role ? 'Administrador' : 'Baneado'),
                    selected: selected,
                    onSelected: (_) => update(() => selected = true),
                  ),
                ],
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(dialogContext),
              child: const Text('Cancelar'),
            ),
            FilledButton(
              onPressed: () => Navigator.pop(dialogContext, selected),
              child: const Text('Guardar cambios'),
            ),
          ],
        ),
      ),
    );

    if (result == null || !mounted) return;

    setState(() {
      if (role) {
        user.administrador = result;
      } else {
        user.baneado = result;
      }
    });

    widget.datos.actualizar();
  }

  @override
  Widget build(BuildContext context) {
    final usuarios = widget.datos.usuarios;

    return Scaffold(
      appBar: AppBar(title: const Text('Thank U Music')),
      body: ContenidoPagina(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const TituloSeccion('Gestión de usuarios'),
            if (usuarios.isEmpty) const Text('Todavía no hay usuarios.'),
            for (final user in usuarios)
              Padding(
                padding: const EdgeInsets.only(bottom: 16),
                child: Tarjeta(
                  child: Row(
                    children: [
                      const CircleAvatar(child: Icon(Icons.person_outline)),
                      const SizedBox(width: 16),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              user.nombre,
                              style: const TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            Text(user.correo),
                            const SizedBox(height: 4),
                            Text(
                              '${user.administrador ? 'Administrador' : 'Normal'} · ${user.baneado ? 'Baneado' : 'Activo'}',
                              style: const TextStyle(
                                color: Colors.black54,
                                fontSize: 12,
                              ),
                            ),
                          ],
                        ),
                      ),
                      if (user != widget.datos.usuarioActual)
                        PopupMenuButton<String>(
                          tooltip: 'Opciones de usuario',
                          onSelected: (v) => edit(user, v == 'role'),
                          itemBuilder: (_) => [
                            const PopupMenuItem(
                              value: 'role',
                              child: Text('Editar rol'),
                            ),
                            const PopupMenuItem(
                              value: 'status',
                              child: Text('Cambiar estado'),
                            ),
                          ],
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
}