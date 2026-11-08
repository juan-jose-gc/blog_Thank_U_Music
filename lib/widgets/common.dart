import 'package:flutter/material.dart';

class PageBody extends StatelessWidget {
  const PageBody({super.key, required this.child, this.width = 1120});
  final Widget child;
  final double width;
  @override
  Widget build(BuildContext context) => SingleChildScrollView(
    padding: EdgeInsets.all(MediaQuery.sizeOf(context).width < 600 ? 16 : 32),
    child: Align(
      alignment: Alignment.topCenter,
      child: ConstrainedBox(
        constraints: BoxConstraints(maxWidth: width),
        child: child,
      ),
    ),
  );
}

class Panel extends StatelessWidget {
  const Panel({super.key, required this.child});
  final Widget child;
  @override
  Widget build(BuildContext context) => Container(
    padding: const EdgeInsets.all(24),
    decoration: BoxDecoration(
      color: Colors.white,
      borderRadius: BorderRadius.circular(18),
      border: Border.all(color: const Color(0xFFEEDFE2)),
    ),
    child: child,
  );
}

class Heading extends StatelessWidget {
  const Heading(this.text, {super.key});
  final String text;
  @override
  Widget build(BuildContext context) => Padding(
    padding: const EdgeInsets.only(bottom: 24),
    child: Text(
      text,
      style: TextStyle(
        fontSize: 28,
        fontWeight: FontWeight.bold,
        color: Theme.of(context).colorScheme.primary,
      ),
    ),
  );
}

class Cover extends StatelessWidget {
  const Cover(this.index, {super.key, this.height = 170});
  final int index;
  final double height;
  @override
  Widget build(BuildContext context) {
    final colors = [
      const Color(0xFF834C35),
      const Color(0xFF393342),
      const Color(0xFF970020),
    ];
    final icons = [Icons.headphones, Icons.piano, Icons.mic];
    return Container(
      height: height,
      width: double.infinity,
      decoration: BoxDecoration(
        color: colors[index % 3],
        borderRadius: BorderRadius.circular(12),
      ),
      child: Icon(icons[index % 3], size: 90, color: Colors.white70),
    );
  }
}

void message(BuildContext context, String text) =>
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(text)));
Future<bool> confirm(BuildContext context, String text) async =>
    await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(text),
        content: const Text(
          'Este cambio solo afecta los datos de demostración.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Cancelar'),
          ),
          FilledButton(
            onPressed: () => Navigator.pop(context, true),
            child: const Text('Eliminar'),
          ),
        ],
      ),
    ) ??
    false;

class EntryField extends StatefulWidget {
  const EntryField(
    this.label,
    this.controller, {
    super.key,
    this.secret = false,
    this.email = false,
    this.lines = 1,
    this.validator,
  });
  final String label;
  final TextEditingController controller;
  final bool secret, email;
  final int lines;
  final String? Function(String?)? validator;
  @override
  State<EntryField> createState() => _EntryFieldState();
}

class _EntryFieldState extends State<EntryField> {
  bool visible = false;
  @override
  Widget build(BuildContext context) => Padding(
    padding: const EdgeInsets.only(bottom: 18),
    child: TextFormField(
      controller: widget.controller,
      maxLines: widget.lines,
      obscureText: widget.secret && !visible,
      keyboardType: widget.email
          ? TextInputType.emailAddress
          : widget.lines > 1
          ? TextInputType.multiline
          : TextInputType.text,
      decoration: InputDecoration(
        labelText: widget.label,
        suffixIcon: widget.secret
            ? IconButton(
                tooltip: visible ? 'Ocultar contraseña' : 'Mostrar contraseña',
                onPressed: () => setState(() => visible = !visible),
                icon: Icon(visible ? Icons.visibility_off : Icons.visibility),
              )
            : null,
      ),
      validator:
          widget.validator ??
          (value) {
            if (value == null || value.trim().isEmpty) {
              return 'Completa este campo';
            }
            if (widget.email &&
                !RegExp(r'^[^\s@]+@[^\s@]+\.[^\s@]+$').hasMatch(value.trim())) {
              return 'Escribe un correo válido';
            }
            if (widget.secret && value.length < 6) {
              return 'Usa al menos 6 caracteres';
            }
            return null;
          },
    ),
  );
}
