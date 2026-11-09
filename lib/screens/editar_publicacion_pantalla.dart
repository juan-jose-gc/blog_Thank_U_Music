import 'package:flutter/material.dart';

import '../Models/datos_ejemplo.dart';
import '../widgets/componentes.dart';

class EditarPublicacionPantalla extends StatefulWidget {
  const EditarPublicacionPantalla({
    super.key,
    required this.datos,
    this.publicacion,
  });
  final DatosEjemplo datos;
  final Publicacion? publicacion;
  @override
  State<EditarPublicacionPantalla> createState() =>
      _EditarPublicacionPantallaState();
}

class _EditarPublicacionPantallaState extends State<EditarPublicacionPantalla> {
  final formulario = GlobalKey<FormState>();
  late final TextEditingController title, content, etiquetas;
  int portada = 0;
  @override
  void initState() {
    super.initState();
    title = TextEditingController(text: widget.publicacion?.titulo);
    content = TextEditingController(text: widget.publicacion?.contenido);
    etiquetas = TextEditingController(
      text: widget.publicacion?.etiquetas.join(', '),
    );
    portada = widget.publicacion?.portada ?? 0;
  }

  @override
  void dispose() {
    title.dispose();
    content.dispose();
    etiquetas.dispose();
    super.dispose();
  }

  void guardar() {
    if (!formulario.currentState!.validate()) return;
    final labels = etiquetas.text
        .split(',')
        .map((t) => t.trim())
        .where((t) => t.isNotEmpty)
        .toSet()
        .toList();
    if (widget.publicacion == null) {
      widget.datos.publicaciones.insert(
        0,
        Publicacion(title.text.trim(), content.text.trim(), portada, labels),
      );
    } else {
      widget.publicacion!
        ..titulo = title.text.trim()
        ..contenido = content.text.trim()
        ..portada = portada
        ..etiquetas = labels;
    }
    widget.datos.actualizar();
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) => Scaffold(
    appBar: AppBar(title: const Text('Thank U Music')),
    body: ContenidoPagina(
      width: 900,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          TituloSeccion(
            widget.publicacion == null
                ? 'Agregar publicación'
                : 'Editar publicación',
          ),
          Tarjeta(
            child: Form(
              key: formulario,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Portada(portada),
                  const SizedBox(height: 12),
                  OutlinedButton.icon(
                    onPressed: () async {
                      final selected = await showDialog<int>(
                        context: context,
                        builder: (context) => SimpleDialog(
                          title: const Text('Elegir portada'),
                          children: List.generate(
                            3,
                            (i) => SimpleDialogOption(
                              onPressed: () => Navigator.pop(context, i),
                              child: Padding(
                                padding: const EdgeInsets.all(8),
                                child: Text(
                                  ['Audífonos', 'Piano', 'Micrófono'][i],
                                ),
                              ),
                            ),
                          ),
                        ),
                      );
                      if (selected != null) setState(() => portada = selected);
                    },
                    icon: const Icon(Icons.image_outlined),
                    label: const Text('Cambiar portada'),
                  ),
                  const SizedBox(height: 24),
                  CampoTexto('Título', title),
                  CampoTexto('Contenido', content, lineas: 7),
                  CampoTexto(
                    'Etiquetas separadas por comas',
                    etiquetas,
                    validator: (_) => null,
                  ),
                  Wrap(
                    alignment: WrapAlignment.end,
                    spacing: 12,
                    runSpacing: 12,
                    children: [
                      OutlinedButton(
                        onPressed: () => Navigator.pop(context),
                        child: const Text('Cancelar'),
                      ),
                      FilledButton(
                        onPressed: guardar,
                        child: Text(
                          widget.publicacion == null
                              ? 'Publicar'
                              : 'Guardar cambios',
                        ),
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
