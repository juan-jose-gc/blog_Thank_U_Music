import 'package:flutter/foundation.dart';

import 'usuario_model.dart';
import 'comentario_model.dart';
import 'publicacion_model.dart';
export 'usuario_model.dart';
export 'comentario_model.dart';
export 'publicacion_model.dart';

// Datos locales para que pueda entrar a el blog xd
class DatosEjemplo extends ChangeNotifier {
  final usuarios = [
    Usuario('comentador', 'comentador@gmail.com'),
    Usuario('Admin', 'admin@gmail.com', administrador: true),
  ];
  final publicaciones = [
    Publicacion(
      'ARTAUD',
      'Artaud el mejor albun de spinneta, neta que si esta chido.\n\nEn la publicacion veremos por que "por" es una cancion infravalorada, neta escuchenla esta bien perra wacha: arbol hojas salta luz',
      0,
      ['Reseñas', 'Rock'],
    ),
    Publicacion(
      'RESEÑA DE ARTAUD PRONTO… SE VIENEN COSITAS MI GENTE',
      'El próximo viernes estaré publicando la reseña de ARTAUD. Escuchenselo completo perros',
      1,
      ['Noticias'],
    ),
    Publicacion(
      'Peso Pluma vive en santa rosa.?',
      'ajjaja se tragaron el clickbait',
      2,
      ['Música mexicana'],
    ),
  ];
  Usuario? usuarioActual;
  DatosEjemplo() {
    publicaciones.first.comentarios.addAll([
      Comentario('Juan', 'Muy buen análisis, ese álbum es goty'),
      Comentario(
        'Wesly Orozco',
        'dooo me llamo wesly',
      ),
    ]);
    publicaciones.last.comentarios.add(
      Comentario('Alamos', 'VIVAAAA SPINNETA CARAJO'),
    );
  }
  void entrarVista(bool administrador) {
    usuarioActual = usuarios[administrador ? 1 : 0];
    notifyListeners();
  }

  void cerrarSesion() {
    usuarioActual = null;
    notifyListeners();
  }

  void actualizar() => notifyListeners();
}
