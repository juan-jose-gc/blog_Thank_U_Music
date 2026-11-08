import 'package:flutter/material.dart';

import '../data/blog_store.dart';
import '../widgets/common.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key, required this.store});
  final BlogStore store;
  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final form = GlobalKey<FormState>();
  late final TextEditingController name, email, address;
  @override
  void initState() {
    super.initState();
    final u = widget.store.current!;
    name = TextEditingController(text: u.name);
    email = TextEditingController(text: u.email);
    address = TextEditingController(text: u.address);
  }

  @override
  void dispose() {
    name.dispose();
    email.dispose();
    address.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => Scaffold(
    appBar: AppBar(title: const Text('Thank U Music')),
    body: PageBody(
      width: 650,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const Heading('Mi perfil'),
          Panel(
            child: Form(
              key: form,
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
                  EntryField('Nombre completo', name),
                  EntryField('Correo electrónico', email, email: true),
                  EntryField('Dirección', address, validator: (_) => null),
                  FilledButton(
                    onPressed: () {
                      if (!form.currentState!.validate()) return;
                      final u = widget.store.current!;
                      if (widget.store.users.any(
                        (other) =>
                            other != u &&
                            other.email.toLowerCase() ==
                                email.text.trim().toLowerCase(),
                      )) {
                        message(context, 'Ese correo ya está registrado.');
                        return;
                      }
                      u.name = name.text.trim();
                      u.email = email.text.trim();
                      u.address = address.text.trim();
                      widget.store.changed();
                      message(context, 'Cambios guardados en la demo.');
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

class UsersScreen extends StatefulWidget {
  const UsersScreen({super.key, required this.store});
  final BlogStore store;
  @override
  State<UsersScreen> createState() => _UsersScreenState();
}

class _UsersScreenState extends State<UsersScreen> {
  String query = '';
  Future<void> edit(BlogUser user, bool role) async {
    bool selected = role ? user.admin : user.banned;
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
                user.name,
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
        user.admin = result;
      } else {
        user.banned = result;
      }
    });
    widget.store.changed();
  }

  @override
  Widget build(BuildContext context) {
    final users = widget.store.users
        .where(
          (u) => '${u.name} ${u.email}'.toLowerCase().contains(
            query.toLowerCase(),
          ),
        )
        .toList();
    return Scaffold(
      appBar: AppBar(title: const Text('Thank U Music')),
      body: PageBody(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const Heading('Gestión de usuarios'),
            TextField(
              onChanged: (v) => setState(() => query = v),
              decoration: const InputDecoration(
                prefixIcon: Icon(Icons.search),
                hintText: 'Buscar usuarios…',
              ),
            ),
            const SizedBox(height: 24),
            if (users.isEmpty) const Text('No encontramos usuarios.'),
            for (final user in users)
              Padding(
                padding: const EdgeInsets.only(bottom: 16),
                child: Panel(
                  child: Row(
                    children: [
                      const CircleAvatar(child: Icon(Icons.person_outline)),
                      const SizedBox(width: 16),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              user.name,
                              style: const TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            Text(user.email),
                            const SizedBox(height: 4),
                            Text(
                              '${user.admin ? 'Administrador' : 'Normal'} · ${user.banned ? 'Baneado' : 'Activo'}',
                              style: const TextStyle(
                                color: Colors.black54,
                                fontSize: 12,
                              ),
                            ),
                          ],
                        ),
                      ),
                      if (user != widget.store.current)
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
