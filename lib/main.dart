// lib/main.dart
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'screens/note_screen.dart';

void main() {
  runApp(const ProviderScope(child: MyApp()));
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Notes App',
      theme: ThemeData(
        primarySwatch: Colors.indigo,
        scaffoldBackgroundColor: Colors.grey[100],
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: const NotesScreen(),
    );
  }
}

// NotesScreen UI
class NotesScreen extends ConsumerWidget {
  const NotesScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final notes = ref.watch(notesProvider);
    final notesNotifier = ref.read(notesProvider.notifier);

    final TextEditingController titleController = TextEditingController();
    final TextEditingController contentController = TextEditingController();

    void showNoteDialog({String? id, String? title, String? content}) {
      titleController.text = title ?? '';
      contentController.text = content ?? '';
      final isEditing = id != null;

      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: Text(isEditing ? 'Edit Note' : 'Add Note'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: titleController,
                decoration: const InputDecoration(labelText: 'Title'),
              ),
              TextField(
                controller: contentController,
                decoration: const InputDecoration(labelText: 'Content'),
                maxLines: 3,
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                if (titleController.text.isNotEmpty &&
                    contentController.text.isNotEmpty) {
                  if (isEditing) {
                    notesNotifier.editNote(
                      id!,
                      titleController.text,
                      contentController.text,
                    );
                  } else {
                    notesNotifier.addNote(
                      titleController.text,
                      contentController.text,
                    );
                  }
                  Navigator.pop(context);
                }
              },
              child: Text(isEditing ? 'Save' : 'Add'),
            ),
          ],
        ),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('Notes'),
        actions: [
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: () => showNoteDialog(),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(10.0),
        child: notes.isEmpty
            ? Center(
                child: Text(
                  'No Notes Available',
                  style: TextStyle(
                    color: Colors.grey[600],
                    fontSize: 16,
                  ),
                ),
              )
            : ListView.builder(
                itemCount: notes.length,
                itemBuilder: (context, index) {
                  final note = notes[index];
                  return Card(
                    margin: const EdgeInsets.symmetric(vertical: 8.0),
                    elevation: 2,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8.0),
                    ),
                    child: ListTile(
                      title: Text(
                        note.title,
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                      ),
                      subtitle: Padding(
                        padding: const EdgeInsets.only(top: 4.0),
                        child: Text(
                          note.content,
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(color: Colors.grey[700]),
                        ),
                      ),
                      trailing: IconButton(
                        icon: const Icon(Icons.delete, color: Colors.red),
                        onPressed: () => notesNotifier.deleteNote(note.id),
                      ),
                      onTap: () => showNoteDialog(
                        id: note.id,
                        title: note.title,
                        content: note.content,
                      ),
                    ),
                  );
                },
              ),
      ),
    );
  }
}
