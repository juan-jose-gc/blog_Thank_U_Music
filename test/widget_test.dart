import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:thank_u_music/main.dart';
import 'package:thank_u_music/data/blog_store.dart';
import 'package:thank_u_music/screens/posts.dart';
import 'package:thank_u_music/screens/users.dart';

void main() {
  testWidgets('Login validates and demo opens the feed', (tester) async {
    await tester.pumpWidget(ThankUMusicApp());
    await tester.tap(find.text('Entrar'));
    await tester.pump();
    expect(find.text('Completa este campo'), findsNWidgets(2));
    await tester.ensureVisible(find.text('Entrar como usuario'));
    await tester.tap(find.text('Entrar como usuario'));
    await tester.pumpAndSettle();
    expect(find.text('Bienvenido, Alamos'), findsOneWidget);
    await tester.enterText(find.byType(TextField), 'sin resultados');
    await tester.pump();
    expect(
      find.text('No encontramos publicaciones. Prueba con otra búsqueda.'),
      findsOneWidget,
    );
  });
  testWidgets('Reader can add a comment', (tester) async {
    final store = BlogStore()..enterDemo(false);
    await tester.pumpWidget(
      MaterialApp(
        home: PostScreen(store: store, post: store.posts.first),
      ),
    );
    await tester.ensureVisible(find.byType(TextField));
    await tester.enterText(find.byType(TextField), 'Me gusta esta reseña');
    await tester.ensureVisible(find.text('Comentar'));
    await tester.tap(find.text('Comentar'));
    await tester.pumpAndSettle();
    expect(store.posts.first.comments.last.text, 'Me gusta esta reseña');
  });
  testWidgets('Editor saves a publication', (tester) async {
    final store = BlogStore()..enterDemo(true);
    await tester.pumpWidget(MaterialApp(home: EditorScreen(store: store)));
    await tester.enterText(find.byType(TextFormField).at(0), 'Nuevo disco');
    await tester.enterText(
      find.byType(TextFormField).at(1),
      'Una reseña de prueba',
    );
    await tester.ensureVisible(find.text('Publicar'));
    await tester.tap(find.text('Publicar'));
    await tester.pumpAndSettle();
    expect(store.posts.first.title, 'Nuevo disco');
  });
  testWidgets('Screens fit a narrow mobile viewport', (tester) async {
    tester.view.physicalSize = const Size(390, 844);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);
    final store = BlogStore()..enterDemo(true);
    for (final screen in <Widget>[
      ThankUMusicApp(),
      ThankUMusicApp(store: store),
      MaterialApp(home: EditorScreen(store: store)),
      MaterialApp(home: ProfileScreen(store: store)),
      MaterialApp(home: UsersScreen(store: store)),
      MaterialApp(
        home: PostScreen(store: store, post: store.posts.first),
      ),
    ]) {
      await tester.pumpWidget(screen);
      await tester.pumpAndSettle();
      expect(tester.takeException(), isNull);
    }
  });
}
