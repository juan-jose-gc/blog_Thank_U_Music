import 'package:flutter/material.dart';

import '../Models/datos_ejemplo.dart';
import '../widgets/componentes.dart';

class DetallePublicacionPantalla extends StatefulWidget {
  const DetallePublicacionPantalla({
    super.key,
    required this.datos,
    required this.publicacion,
    this.moderar = false,
  });
  final DatosEjemplo datos;
  final Publicacion publicacion;
  final bool moderar;
  @override
  State<DetallePublicacionPantalla> createState() =>
      _DetallePublicacionPantallaState();
}

class _DetallePublicacionPantallaState
    extends State<DetallePublicacionPantalla> {
  final comentario = TextEditingController();
  bool expandido = false;
  @override
  void dispose() {
    comentario.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final publicacion = widget.publicacion;
    return Scaffold(
      appBar: AppBar(title: const Text('Thank U Music')),
      body: ContenidoPagina(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            TituloSeccion(
              widget.moderar ? 'Moderación de comentarios' : 'Publicación',
            ),
            Tarjeta(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  if (!widget.moderar) ...[
                    Portada(publicacion.portada),
                    const SizedBox(height: 20),
                  ],
                  Text(
                    publicacion.titulo,
                    style: const TextStyle(
                      fontSize: 26,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFFB50020),
                    ),
                  ),
                  const SizedBox(height: 12),
                  if (!widget.moderar) ...[
                    const Text(
                      'Alamos  ·  06 nov 2026',
                      style: TextStyle(color: Colors.black54),
                    ),
                    const SizedBox(height: 16),
                    Text(
                      publicacion.contenido,
                      maxLines: expandido ? null : 3,
                      overflow: expandido ? null : TextOverflow.ellipsis,
                      style: const TextStyle(fontSize: 16, height: 1.6),
                    ),
                    TextButton.icon(
                      onPressed: () => setState(() => expandido = !expandido),
                      icon: Icon(
                        expandido ? Icons.expand_less : Icons.expand_more,
                      ),
                      label: Text(expandido ? 'Ver menos' : 'Ver más'),
                    ),
                    Wrap(
                      spacing: 8,
                      runSpacing: 8,
                      children: publicacion.etiquetas
                          .map((t) => Chip(label: Text(t)))
                          .toList(),
                    ),
                  ],
                ],
              ),
            ),
            const SizedBox(height: 24),
            TituloSeccion('Comentarios (${publicacion.comentarios.length})'),
            if (publicacion.comentarios.isEmpty)
              const Text('Aún no hay comentarios.'),
            for (final c in publicacion.comentarios)
              Padding(
                padding: const EdgeInsets.only(bottom: 12),
                child: Tarjeta(
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const CircleAvatar(child: Icon(Icons.person_outline)),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              c.autor,
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(height: 6),
                            Text(c.texto),
                          ],
                        ),
                      ),
                      if (widget.moderar)
                        IconButton(
                          tooltip: 'Eliminar comentario',
                          icon: const Icon(Icons.delete_outline),
                          onPressed: () async {
                            if (await confirmarEliminacion(
                              context,
                              '¿Eliminar comentario?',
                            )) {
                              if (!mounted) return;
                              setState(() => publicacion.comentarios.remove(c));
                              widget.datos.actualizar();
                            }
                          },
                        ),
                    ],
                  ),
                ),
              ),
            if (!widget.moderar) ...[
              const SizedBox(height: 12),
              TextField(
                controller: comentario,
                minLines: 1,
                maxLines: 4,
                decoration: const InputDecoration(
                  hintText: 'Escribe un comentario…',
                  prefixIcon: Icon(Icons.chat_bubble_outline),
                ),
              ),
              const SizedBox(height: 12),
              Align(
                alignment: Alignment.centerRight,
                child: FilledButton.icon(
                  onPressed: () {
                    if (comentario.text.trim().isEmpty) {
                      mostrarAviso(context, 'Escribe un comentario primero.');
                      return;
                    }
                    setState(() {
                      publicacion.comentarios.add(
                        Comentario(
                          widget.datos.usuarioActual!.nombre,
                          comentario.text.trim(),
                        ),
                      );
                      comentario.clear();
                    });
                    widget.datos.actualizar();
                  },
                  icon: const Icon(Icons.send_outlined),
                  label: const Text('Comentar'),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
