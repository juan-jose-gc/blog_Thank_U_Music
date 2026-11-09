import 'package:flutter/material.dart';

class CampoTexto extends StatefulWidget {
  const CampoTexto(
    this.label,
    this.controller, {
    super.key,
    this.oculto = false,
    this.correo = false,
    this.lineas = 1,
    this.validator,
  });
  final String label;
  final TextEditingController controller;
  final bool oculto, correo;
  final int lineas;
  final String? Function(String?)? validator;
  @override
  State<CampoTexto> createState() => _CampoTextoState();
}

class _CampoTextoState extends State<CampoTexto> {
  bool visible = false;
  @override
  Widget build(BuildContext context) => Padding(
    padding: const EdgeInsets.only(bottom: 18),
    child: TextFormField(
      controller: widget.controller,
      maxLines: widget.lineas,
      obscureText: widget.oculto && !visible,
      keyboardType: widget.correo
          ? TextInputType.emailAddress
          : widget.lineas > 1
          ? TextInputType.multiline
          : TextInputType.text,
      decoration: InputDecoration(
        labelText: widget.label,
        suffixIcon: widget.oculto
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
            if (widget.correo &&
                !RegExp(r'^[^\s@]+@[^\s@]+\.[^\s@]+$').hasMatch(value.trim())) {
              return 'Escribe un correo válido';
            }
            if (widget.oculto && value.length < 6) {
              return 'Usa al menos 6 caracteres';
            }
            return null;
          },
    ),
  );
}
