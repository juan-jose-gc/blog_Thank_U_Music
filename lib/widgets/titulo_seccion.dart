import 'package:flutter/material.dart';

class TituloSeccion extends StatelessWidget {
  const TituloSeccion(this.text, {super.key});
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
