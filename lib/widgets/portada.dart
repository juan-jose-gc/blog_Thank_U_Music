import 'package:flutter/material.dart';

class Portada extends StatelessWidget {
  const Portada(this.index, {super.key, this.height = 170});
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
