import 'package:flutter/material.dart';

class Tarjeta extends StatelessWidget {
  const Tarjeta({super.key, required this.child});
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
