import 'package:flutter/material.dart';

class ContenidoPagina extends StatelessWidget {
  const ContenidoPagina({super.key, required this.child, this.width = 1120});
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
