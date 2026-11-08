import 'package:flutter/material.dart';

import '../data/blog_store.dart';
import '../widgets/common.dart';
import 'auth.dart';
import 'posts.dart';
import 'users.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key, required this.store});
  final BlogStore store;
  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  String section = 'Inicio';
  String query = '';
  final search = TextEditingController();
  @override
  void dispose() {
    search.dispose();
    super.dispose();
  }

  void open(Widget screen) =>
      Navigator.push(context, MaterialPageRoute<void>(builder: (_) => screen));
  @override
  Widget build(BuildContext context) {
    final user = widget.store.current!;
    final editing = section == 'Editar publicaciones';
    final posts = widget.store.posts
        .where(
          (p) => '${p.title} ${p.content} ${p.tags.join(' ')}'
              .toLowerCase()
              .contains(query.toLowerCase()),
        )
        .toList();
    return Scaffold(
      appBar: AppBar(
        title: const Row(
          children: [
            Icon(Icons.headphones),
            SizedBox(width: 10),
            Flexible(child: Text('Thank U Music')),
          ],
        ),
      ),
      drawer: Drawer(
        child: SafeArea(
          child: ListView(
            children: [
              UserAccountsDrawerHeader(
                decoration: const BoxDecoration(color: Color(0xFFFFE4E9)),
                currentAccountPicture: const CircleAvatar(
                  child: Icon(Icons.person_outline),
                ),
                accountName: Text(
                  user.name,
                  style: const TextStyle(
                    color: Color(0xFFB50020),
                    fontWeight: FontWeight.bold,
                  ),
                ),
                accountEmail: Text(
                  user.email,
                  style: const TextStyle(color: Colors.black54),
                ),
              ),
              nav(
                'Inicio',
                Icons.home_outlined,
                () => setState(() {
                  section = 'Inicio';
                  query = '';
                  search.clear();
                }),
              ),
              nav(
                'Mi perfil',
                Icons.person_outline,
                () => open(ProfileScreen(store: widget.store)),
              ),
              if (user.admin) ...[
                nav(
                  'Registrar usuario',
                  Icons.person_add_outlined,
                  () => open(
                    AuthScreen(store: widget.store, registerAdmin: true),
                  ),
                ),
                nav(
                  'Gestionar usuarios',
                  Icons.group_outlined,
                  () => open(UsersScreen(store: widget.store)),
                ),
                nav(
                  'Agregar publicación',
                  Icons.post_add,
                  () => open(EditorScreen(store: widget.store)),
                ),
                nav(
                  'Editar publicaciones',
                  Icons.edit_outlined,
                  () => setState(() {
                    section = 'Editar publicaciones';
                    query = '';
                    search.clear();
                  }),
                ),
              ],
              const Divider(),
              nav('Cerrar sesión', Icons.logout, widget.store.logout),
            ],
          ),
        ),
      ),
      body: PageBody(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Heading(editing ? 'Tus publicaciones' : 'Bienvenido, ${user.name}'),
            TextField(
              controller: search,
              onChanged: (v) => setState(() => query = v),
              decoration: const InputDecoration(
                hintText: 'Buscar publicaciones…',
                prefixIcon: Icon(Icons.search),
              ),
            ),
            const SizedBox(height: 24),
            if (posts.isEmpty)
              const Panel(
                child: Text(
                  'No encontramos publicaciones. Prueba con otra búsqueda.',
                ),
              ),
            for (final post in posts)
              Padding(
                padding: const EdgeInsets.only(bottom: 24),
                child: Panel(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Cover(post.cover),
                      const SizedBox(height: 16),
                      Text(
                        post.title,
                        style: const TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFFB50020),
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        post.content,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 8),
                      TextButton.icon(
                        onPressed: () => open(
                          editing
                              ? EditorScreen(store: widget.store, post: post)
                              : PostScreen(store: widget.store, post: post),
                        ),
                        icon: Icon(
                          editing
                              ? Icons.edit_outlined
                              : Icons.article_outlined,
                        ),
                        label: Text(
                          editing ? 'Editar publicación' : 'Leer publicación',
                        ),
                      ),
                      if (editing)
                        TextButton.icon(
                          onPressed: () => open(
                            PostScreen(
                              store: widget.store,
                              post: post,
                              moderate: true,
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

  Widget nav(String title, IconData icon, VoidCallback action) => ListTile(
    leading: Icon(icon, color: const Color(0xFFB50020)),
    title: Text(title),
    selected: title == section,
    onTap: () {
      Navigator.pop(context);
      action();
    },
  );
}
