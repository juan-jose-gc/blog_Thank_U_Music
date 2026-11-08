import 'package:flutter/material.dart';

import '../data/blog_store.dart';
import '../widgets/common.dart';

class AuthScreen extends StatefulWidget {
  const AuthScreen({
    super.key,
    required this.store,
    this.registerAdmin = false,
  });
  final BlogStore store;
  final bool registerAdmin;
  @override
  State<AuthScreen> createState() => _AuthScreenState();
}

class _AuthScreenState extends State<AuthScreen> {
  final form = GlobalKey<FormState>();
  final name = TextEditingController(),
      email = TextEditingController(),
      address = TextEditingController(),
      password = TextEditingController(),
      repeat = TextEditingController();
  bool register = false;
  @override
  void initState() {
    super.initState();
    register = widget.registerAdmin;
  }

  @override
  void dispose() {
    for (final c in [name, email, address, password, repeat]) {
      c.dispose();
    }
    super.dispose();
  }

  void submit() {
    if (!form.currentState!.validate()) return;
    if (register) {
      if (widget.store.users.any(
        (u) => u.email.toLowerCase() == email.text.trim().toLowerCase(),
      )) {
        message(context, 'Este correo ya está registrado en la demo.');
        return;
      }
      final user = BlogUser(
        name.text.trim(),
        email.text.trim(),
        address: address.text.trim(),
        admin: widget.registerAdmin,
      );
      widget.store.users.add(user);
      if (widget.registerAdmin) {
        widget.store.changed();
        Navigator.pop(context);
        return;
      }
      widget.store.current = user;
      widget.store.changed();
    } else {
      // UI-only login; this is intentionally not real authentication.
      final matches = widget.store.users.where(
        (u) => u.email.toLowerCase() == email.text.trim().toLowerCase(),
      );
      if (matches.isEmpty) {
        message(
          context,
          'Usa un acceso de demostración o registra un usuario.',
        );
        return;
      }
      if (matches.first.banned) {
        message(context, 'Este usuario está baneado en la demo.');
        return;
      }
      widget.store.current = matches.first;
      widget.store.changed();
    }
  }

  @override
  Widget build(BuildContext context) => Scaffold(
    appBar: widget.registerAdmin
        ? AppBar(title: const Text('Thank U Music'))
        : null,
    body: SafeArea(
      child: PageBody(
        width: 550,
        child: Panel(
          child: Form(
            key: form,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Image.asset(
                  'assets/logo.jpeg',
                  height: 100,
                  fit: BoxFit.contain,
                ),
                const SizedBox(height: 24),
                Heading(
                  widget.registerAdmin
                      ? 'Registrar administrador'
                      : register
                      ? 'Registro'
                      : 'Iniciar sesión',
                ),
                if (register) EntryField('Nombre', name),
                EntryField('Correo electrónico', email, email: true),
                if (register) EntryField('Dirección', address),
                EntryField('Contraseña', password, secret: true),
                if (register)
                  EntryField(
                    'Confirmar contraseña',
                    repeat,
                    secret: true,
                    validator: (v) => v != password.text || (v?.isEmpty ?? true)
                        ? 'Las contraseñas deben coincidir'
                        : null,
                  ),
                FilledButton(
                  onPressed: submit,
                  child: Text(
                    register
                        ? widget.registerAdmin
                              ? 'Crear administrador'
                              : 'Crear cuenta'
                        : 'Entrar',
                  ),
                ),
                if (!register)
                  TextButton(
                    onPressed: () => showDialog<void>(
                      context: context,
                      builder: (context) => AlertDialog(
                        title: const Text('Recuperar contraseña'),
                        content: const Text(
                          'La recuperación por correo estará disponible al conectar la API. Por ahora puedes usar los accesos de demostración.',
                        ),
                        actions: [
                          TextButton(
                            onPressed: () => Navigator.pop(context),
                            child: const Text('Entendido'),
                          ),
                        ],
                      ),
                    ),
                    child: const Text('¿Olvidaste tu contraseña?'),
                  ),
                if (!widget.registerAdmin)
                  TextButton(
                    onPressed: () => setState(() {
                      register = !register;
                      form.currentState?.reset();
                    }),
                    child: Text(
                      register
                          ? 'Ya tengo cuenta · Iniciar sesión'
                          : '¿No tienes cuenta? Regístrate',
                    ),
                  ),
                if (!widget.registerAdmin) ...[
                  const Divider(height: 32),
                  const Text(
                    'Vista de demostración',
                    textAlign: TextAlign.center,
                    style: TextStyle(fontWeight: FontWeight.w600),
                  ),
                  const SizedBox(height: 12),
                  Wrap(
                    alignment: WrapAlignment.center,
                    spacing: 12,
                    runSpacing: 12,
                    children: [
                      OutlinedButton(
                        onPressed: () => widget.store.enterDemo(false),
                        child: const Text('Entrar como usuario'),
                      ),
                      OutlinedButton(
                        onPressed: () => widget.store.enterDemo(true),
                        child: const Text('Entrar como administrador'),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  const Text(
                    'Sin conexión a la API. Los cambios se reinician al cerrar o recargar.',
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 12, color: Colors.black54),
                  ),
                ],
              ],
            ),
          ),
        ),
      ),
    ),
  );
}
