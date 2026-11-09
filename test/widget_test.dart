import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:thank_u_music/main.dart';
import 'package:thank_u_music/Models/datos_ejemplo.dart';
import 'package:thank_u_music/screens/detalle_publicacion_pantalla.dart';
import 'package:thank_u_music/screens/usuarios_pantalla.dart';
import 'package:thank_u_music/screens/perfil_pantalla.dart';
import 'package:thank_u_music/screens/editar_publicacion_pantalla.dart';

void main() {
  testWidgets('El acceso valida campos y abre el inicio', (tester) async {
    await tester.pumpWidget(AplicacionThankUMusic());
    await tester.tap(find.text('Entrar'));
    await tester.pump();
    expect(find.text('Completa este campo'), findsNWidgets(2));
    await tester.enterText(
      find.byType(TextFormField).at(0),
      'alamos@example.com',
    );
    await tester.enterText(find.byType(TextFormField).at(1), 'ejemplo');
    await tester.tap(find.text('Entrar'));
    await tester.pumpAndSettle();
    expect(find.text('Bienvenido, Alamos'), findsOneWidget);
    await tester.enterText(find.byType(TextField), 'sin resultados');
    await tester.pump();
    expect(
      find.text('No encontramos publicaciones. Prueba con otra búsqueda.'),
      findsOneWidget,
    );
  });
  testWidgets('El lector puede comentar', (tester) async {
    final datos = DatosEjemplo()..entrarVista(false);
    await tester.pumpWidget(
      MaterialApp(
        home: DetallePublicacionPantalla(
          datos: datos,
          publicacion: datos.publicaciones.first,
        ),
      ),
    );
    await tester.ensureVisible(find.byType(TextField));
    await tester.enterText(find.byType(TextField), 'Me gusta esta reseña');
    await tester.ensureVisible(find.text('Comentar'));
    await tester.tap(find.text('Comentar'));
    await tester.pumpAndSettle();
    expect(
      datos.publicaciones.first.comentarios.last.texto,
      'Me gusta esta reseña',
    );
  });
  testWidgets('El editor guarda una publicación', (tester) async {
    final datos = DatosEjemplo()..entrarVista(true);
    await tester.pumpWidget(
      MaterialApp(home: EditarPublicacionPantalla(datos: datos)),
    );
    await tester.enterText(find.byType(TextFormField).at(0), 'Nuevo disco');
    await tester.enterText(
      find.byType(TextFormField).at(1),
      'Una reseña de prueba',
    );
    await tester.ensureVisible(find.text('Publicar'));
    await tester.tap(find.text('Publicar'));
    await tester.pumpAndSettle();
    expect(datos.publicaciones.first.titulo, 'Nuevo disco');
  });
  testWidgets('Las pantallas se adaptan a móvil', (tester) async {
    tester.view.physicalSize = const Size(390, 844);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);
    final datos = DatosEjemplo()..entrarVista(true);
    for (final screen in <Widget>[
      AplicacionThankUMusic(),
      AplicacionThankUMusic(datos: datos),
      MaterialApp(home: EditarPublicacionPantalla(datos: datos)),
      MaterialApp(home: PerfilPantalla(datos: datos)),
      MaterialApp(home: UsuariosPantalla(datos: datos)),
      MaterialApp(
        home: DetallePublicacionPantalla(
          datos: datos,
          publicacion: datos.publicaciones.first,
        ),
      ),
    ]) {
      await tester.pumpWidget(screen);
      await tester.pumpAndSettle();
      expect(tester.takeException(), isNull);
    }
  });
}
