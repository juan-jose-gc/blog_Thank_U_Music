import 'package:flutter/foundation.dart';

class BlogUser {
  BlogUser(this.name, this.email, {this.address = '', this.admin = false});
  String name, email, address;
  bool admin;
  bool banned = false;
}

class Comment {
  Comment(this.author, this.text);
  final String author, text;
}

class Post {
  Post(this.title, this.content, this.cover, this.tags);
  String title, content;
  int cover;
  List<String> tags;
  final List<Comment> comments = [];
}

/// In-memory demo. Replace with an API repository later. No credentials stored.
class BlogStore extends ChangeNotifier {
  final users = [
    BlogUser('Alamos', 'alamos@example.com'),
    BlogUser('Administrador', 'admin@example.com', admin: true),
    BlogUser('Adriana Contreras', 'adriana@example.com'),
    BlogUser('Carlos Pérez', 'carlos@example.com'),
    BlogUser('Wesly Orozco', 'wesly@example.com'),
  ];
  final posts = [
    Post(
      'MÚSICA 1',
      'Haremos una reseña del álbum BOCANADA de Gustavo Cerati, un disco emblemático del rock en español.\n\nEn esta publicación analizaremos su estilo, las letras y el impacto que tuvo en la música latinoamericana.',
      0,
      ['Reseñas', 'Rock'],
    ),
    Post(
      'RESEÑA DE BOCANADA PRONTO…',
      'El próximo viernes estaré publicando la reseña de BOCANADA. Una invitación para escuchar el disco completo y compartir nuestras canciones favoritas.',
      1,
      ['Noticias'],
    ),
    Post(
      'Peso Pluma: el fenómeno de la música mexicana actual',
      'Un espacio para conversar sobre su estilo, sus colaboraciones y la evolución de la música mexicana. ¿Qué canción agregarías a esta selección?',
      2,
      ['Música mexicana'],
    ),
  ];
  BlogUser? current;
  BlogStore() {
    posts.first.comments.addAll([
      Comment('Juan Gutiérrez', 'Muy buen análisis, ese álbum es una joya.'),
      Comment('Wesly Orozco', 'Bocanada es de los mejores discos de Cerati.'),
    ]);
    posts.last.comments.add(
      Comment('Carlos Pérez', 'Me gustaría leer más sobre música mexicana.'),
    );
  }
  void enterDemo(bool admin) {
    current = users[admin ? 1 : 0];
    notifyListeners();
  }

  void logout() {
    current = null;
    notifyListeners();
  }

  void changed() => notifyListeners();
}
