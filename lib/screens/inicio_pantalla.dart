import 'package:flutter/material.dart';

import '../Models/datos_ejemplo.dart';
import '../widgets/componentes.dart';
import '../widgets/menu_lateral.dart';
import 'registro_pantalla.dart';
import 'detalle_publicacion_pantalla.dart';
import 'editar_publicacion_pantalla.dart';
import 'perfil_pantalla.dart';
import 'usuarios_pantalla.dart';

class InicioPantalla extends StatefulWidget {
  const InicioPantalla({super.key, required this.datos});

  final DatosEjemplo datos;

  @override
  State<InicioPantalla> createState() => _InicioPantallaState();
}

class _InicioPantallaState extends State<InicioPantalla> {
  String seccion = 'Inicio';

  void abrir(Widget screen) =>
      Navigator.push(context, MaterialPageRoute<void>(builder: (_) => screen));

  @override
  Widget build(BuildContext context) {
    final usuario = widget.datos.usuarioActual!;
    final editando = seccion == 'Editar publicaciones';
    final publicaciones = widget.datos.publicaciones;

    return Scaffold(
      appBar: AppBar(
        leading: Builder(
        builder: (context) => IconButton(
        tooltip: 'Abrete sesamo',
        icon: const Icon(Icons.menu),
        onPressed: () => Scaffold.of(context).openDrawer(),
          ),
        ),
        title: const Row(
          children: [
            Icon(Icons.headphones),
            SizedBox(width: 10),
            Flexible(child: Text('Thank U Music')),
          ],
        ),
      ),
      drawer: MenuLateral(
        usuario: usuario,
        seccion: seccion,
        alIrInicio: () => setState(() {
          seccion = 'Inicio';
        }),
        alIrPerfil: () => abrir(PerfilPantalla(datos: widget.datos)),
        alRegistrar: () => abrir(
          RegistroPantalla(
            datos: widget.datos,
            registrarAdministrador: true,
          ),
        ),
        alGestionar: () => abrir(UsuariosPantalla(datos: widget.datos)),
        alAgregar: () => abrir(
          EditarPublicacionPantalla(datos: widget.datos),
        ),
        alEditar: () => setState(() {
          seccion = 'Editar publicaciones';
        }),
        alCerrarSesion: widget.datos.cerrarSesion,
      ),
      body: ContenidoPagina(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            TituloSeccion(
              editando ? 'Tus publicaciones' : 'Que onda, ${usuario.nombre}',
            ),
            if (publicaciones.isEmpty)
              const Tarjeta(
                child: Text('Todavía no hay publicaciones.'),
              ),
            for (final publicacion in publicaciones)
              Padding(
                padding: const EdgeInsets.only(bottom: 24),
                child: Tarjeta(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Portada(publicacion.portada),
                      const SizedBox(height: 16),
                      Text(
                        publicacion.titulo,
                        style: const TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFFB50020),
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        publicacion.contenido,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 8),
                      TextButton.icon(
                        onPressed: () => abrir(
                          editando
                              ? EditarPublicacionPantalla(
                                  datos: widget.datos,
                                  publicacion: publicacion,
                                )
                              : DetallePublicacionPantalla(
                                  datos: widget.datos,
                                  publicacion: publicacion,
                                ),
                        ),
                        icon: Icon(
                          editando
                              ? Icons.edit_outlined
                              : Icons.article_outlined,
                        ),
                        label: Text(
                          editando ? 'Editar publicación' : 'Leer publicación',
                        ),
                      ),
                      if (editando)
                        TextButton.icon(
                          onPressed: () => abrir(
                            DetallePublicacionPantalla(
                              datos: widget.datos,
                              publicacion: publicacion,
                              moderar: true,
                            ),
                          ),
                          icon: const Icon(Icons.chat_bubble_outline),
                          label: const Text('Moderar comentarios'),
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