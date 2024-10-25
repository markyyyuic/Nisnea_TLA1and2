// lib/controllers/notes_controller.dart
import 'package:flutter_riverpod/flutter_riverpod.dart';

// Note model
class Note {
  final String id;
  final String title;
  final String content;

  Note({
    required this.id,
    required this.title,
    required this.content,
  });
}

// NotesNotifier handles all note-related operations
class NotesNotifier extends StateNotifier<List<Note>> {
  NotesNotifier() : super([]);

  void addNote(String title, String content) {
    final newNote = Note(
      id: DateTime.now().toString(),
      title: title,
      content: content,
    );
    state = [...state, newNote];
  }

  void editNote(String id, String newTitle, String newContent) {
    state = [
      for (final note in state)
        if (note.id == id)
          Note(
            id: note.id,
            title: newTitle,
            content: newContent,
          )
        else
          note,
    ];
  }

  void deleteNote(String id) {
    state = state.where((note) => note.id != id).toList();
  }
}

// Riverpod provider to manage NotesNotifier
final notesProvider = StateNotifierProvider<NotesNotifier, List<Note>>((ref) {
  return NotesNotifier();
});


//Commentsss