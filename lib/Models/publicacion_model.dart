import 'comentario_model.dart';

class Publicacion {
  Publicacion(this.titulo, this.contenido, this.portada, this.etiquetas);
  String titulo, contenido;
  int portada;
  List<String> etiquetas;
  final List<Comentario> comentarios = [];
}
