import 'package:flutter/material.dart';

import '../data/blog_store.dart';
import '../widgets/common.dart';

class PostScreen extends StatefulWidget {
  const PostScreen({
    super.key,
    required this.store,
    required this.post,
    this.moderate = false,
  });
  final BlogStore store;
  final Post post;
  final bool moderate;
  @override
  State<PostScreen> createState() => _PostScreenState();
}

class _PostScreenState extends State<PostScreen> {
  final comment = TextEditingController();
  bool expanded = false;
  @override
  void dispose() {
    comment.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final post = widget.post;
    return Scaffold(
      appBar: AppBar(title: const Text('Thank U Music')),
      body: PageBody(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Heading(
              widget.moderate ? 'Moderación de comentarios' : 'Publicación',
            ),
            Panel(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  if (!widget.moderate) ...[
                    Cover(post.cover),
                    const SizedBox(height: 20),
                  ],
                  Text(
                    post.title,
                    style: const TextStyle(
                      fontSize: 26,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFFB50020),
                    ),
                  ),
                  const SizedBox(height: 12),
                  if (!widget.moderate) ...[
                    const Text(
                      'Alamos  ·  06 nov 2026',
                      style: TextStyle(color: Colors.black54),
                    ),
                    const SizedBox(height: 16),
                    Text(
                      post.content,
                      maxLines: expanded ? null : 3,
                      overflow: expanded ? null : TextOverflow.ellipsis,
                      style: const TextStyle(fontSize: 16, height: 1.6),
                    ),
                    TextButton.icon(
                      onPressed: () => setState(() => expanded = !expanded),
                      icon: Icon(
                        expanded ? Icons.expand_less : Icons.expand_more,
                      ),
                      label: Text(expanded ? 'Ver menos' : 'Ver más'),
                    ),
                    Wrap(
                      spacing: 8,
                      runSpacing: 8,
                      children: post.tags
                          .map((t) => Chip(label: Text(t)))
                          .toList(),
                    ),
                  ],
                ],
              ),
            ),
            const SizedBox(height: 24),
            Heading('Comentarios (${post.comments.length})'),
            if (post.comments.isEmpty) const Text('Aún no hay comentarios.'),
            for (final c in post.comments)
              Padding(
                padding: const EdgeInsets.only(bottom: 12),
                child: Panel(
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
                              c.author,
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(height: 6),
                            Text(c.text),
                          ],
                        ),
                      ),
                      if (widget.moderate)
                        IconButton(
                          tooltip: 'Eliminar comentario',
                          icon: const Icon(Icons.delete_outline),
                          onPressed: () async {
                            if (await confirm(
                              context,
                              '¿Eliminar comentario?',
                            )) {
                              if (!mounted) return;
                              setState(() => post.comments.remove(c));
                              widget.store.changed();
                            }
                          },
                        ),
                    ],
                  ),
                ),
              ),
            if (!widget.moderate) ...[
              const SizedBox(height: 12),
              TextField(
                controller: comment,
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
                    if (comment.text.trim().isEmpty) {
                      message(context, 'Escribe un comentario primero.');
                      return;
                    }
                    setState(() {
                      post.comments.add(
                        Comment(
                          widget.store.current!.name,
                          comment.text.trim(),
                        ),
                      );
                      comment.clear();
                    });
                    widget.store.changed();
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

class EditorScreen extends StatefulWidget {
  const EditorScreen({super.key, required this.store, this.post});
  final BlogStore store;
  final Post? post;
  @override
  State<EditorScreen> createState() => _EditorScreenState();
}

class _EditorScreenState extends State<EditorScreen> {
  final form = GlobalKey<FormState>();
  late final TextEditingController title, content, tags;
  int cover = 0;
  @override
  void initState() {
    super.initState();
    title = TextEditingController(text: widget.post?.title);
    content = TextEditingController(text: widget.post?.content);
    tags = TextEditingController(text: widget.post?.tags.join(', '));
    cover = widget.post?.cover ?? 0;
  }

  @override
  void dispose() {
    title.dispose();
    content.dispose();
    tags.dispose();
    super.dispose();
  }

  void save() {
    if (!form.currentState!.validate()) return;
    final labels = tags.text
        .split(',')
        .map((t) => t.trim())
        .where((t) => t.isNotEmpty)
        .toSet()
        .toList();
    if (widget.post == null) {
      widget.store.posts.insert(
        0,
        Post(title.text.trim(), content.text.trim(), cover, labels),
      );
    } else {
      widget.post!
        ..title = title.text.trim()
        ..content = content.text.trim()
        ..cover = cover
        ..tags = labels;
    }
    widget.store.changed();
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) => Scaffold(
    appBar: AppBar(title: const Text('Thank U Music')),
    body: PageBody(
      width: 900,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Heading(
            widget.post == null ? 'Agregar publicación' : 'Editar publicación',
          ),
          Panel(
            child: Form(
              key: form,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Cover(cover),
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
                      if (selected != null) setState(() => cover = selected);
                    },
                    icon: const Icon(Icons.image_outlined),
                    label: const Text('Cambiar portada'),
                  ),
                  const SizedBox(height: 24),
                  EntryField('Título', title),
                  EntryField('Contenido', content, lines: 7),
                  EntryField(
                    'Etiquetas separadas por comas',
                    tags,
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
                        onPressed: save,
                        child: Text(
                          widget.post == null ? 'Publicar' : 'Guardar cambios',
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
