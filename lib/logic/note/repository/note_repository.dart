import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../models/note_model.dart';

/// Repository for managing note data
/// Handles all Firebase Firestore operations for notes
class NoteRepository {
  final FirebaseFirestore _firestore;
  final FirebaseAuth _auth;

  NoteRepository({FirebaseFirestore? firestore, FirebaseAuth? auth})
    : _firestore = firestore ?? FirebaseFirestore.instance,
      _auth = auth ?? FirebaseAuth.instance;

  /// Get current user ID
  String? get _userId => _auth.currentUser?.uid;

  /// Reference to notes collection
  CollectionReference get _notesCollection => _firestore.collection('notes');

  /// Stream of notes for the current user
  /// Returns real-time updates whenever notes change
  Stream<List<NoteModel>> getNotesStream() {
    if (_userId == null) {
      return Stream.value([]);
    }

    return _notesCollection
        .where('userId', isEqualTo: _userId)
        .where('isArchived', isEqualTo: false)
        .orderBy('updatedAt', descending: true)
        .snapshots()
        .map((snapshot) {
          final notes = snapshot.docs
              .map(
                (doc) => NoteModel.fromJson(doc.data() as Map<String, dynamic>),
              )
              .toList();

          // Sort by pinned status in memory to avoid composite index requirement
          notes.sort((a, b) {
            if (a.isPinned && !b.isPinned) return -1;
            if (!a.isPinned && b.isPinned) return 1;
            return 0;
          });

          return notes;
        });
  }

  /// Stream of archived notes for the current user
  /// Returns real-time updates whenever archived notes change
  Stream<List<NoteModel>> getArchivedNotesStream() {
    if (_userId == null) {
      return Stream.value([]);
    }

    return _notesCollection
        .where('userId', isEqualTo: _userId)
        .where('isArchived', isEqualTo: true)
        .orderBy('updatedAt', descending: true)
        .snapshots()
        .map((snapshot) {
          final notes = snapshot.docs
              .map(
                (doc) => NoteModel.fromJson(doc.data() as Map<String, dynamic>),
              )
              .toList();

          // Sort by pinned status in memory to avoid composite index requirement
          notes.sort((a, b) {
            if (a.isPinned && !b.isPinned) return -1;
            if (!a.isPinned && b.isPinned) return 1;
            return 0;
          });

          return notes;
        });
  }

  /// Get all notes for the current user (one-time fetch)
  Future<List<NoteModel>> getNotes() async {
    if (_userId == null) {
      throw Exception('User not authenticated');
    }

    final snapshot = await _notesCollection
        .where('userId', isEqualTo: _userId)
        .where('isArchived', isEqualTo: false)
        .orderBy('updatedAt', descending: true)
        .get();

    final notes = snapshot.docs
        .map((doc) => NoteModel.fromJson(doc.data() as Map<String, dynamic>))
        .toList();

    // Sort by pinned status in memory
    notes.sort((a, b) {
      if (a.isPinned && !b.isPinned) return -1;
      if (!a.isPinned && b.isPinned) return 1;
      return 0;
    });

    return notes;
  }

  /// Get a single note by ID
  Future<NoteModel?> getNoteById(String noteId) async {
    final doc = await _notesCollection.doc(noteId).get();
    if (!doc.exists) return null;
    return NoteModel.fromJson(doc.data() as Map<String, dynamic>);
  }

  /// Add a new note
  Future<void> addNote(NoteModel note) async {
    if (_userId == null) {
      throw Exception('User not authenticated');
    }

    print('NoteRepository: Adding note for user $_userId');
    // Update the note with the actual user ID
    final noteWithUserId = note.copyWith(userId: _userId!);
    print('NoteRepository: Note data: ${noteWithUserId.toJson()}');
    await _notesCollection.doc(note.id).set(noteWithUserId.toJson());
    print('NoteRepository: Note saved successfully');
  }

  /// Update an existing note
  Future<void> updateNote(NoteModel note) async {
    if (_userId == null) {
      throw Exception('User not authenticated');
    }

    // Ensure the note has the correct user ID
    final noteWithUserId = note.copyWith(userId: _userId!);
    await _notesCollection.doc(note.id).update(noteWithUserId.toJson());
  }

  /// Delete a note
  Future<void> deleteNote(String noteId) async {
    if (_userId == null) {
      throw Exception('User not authenticated');
    }

    await _notesCollection.doc(noteId).delete();
  }

  /// Archive a note
  Future<void> archiveNote(String noteId) async {
    if (_userId == null) {
      throw Exception('User not authenticated');
    }

    await _notesCollection.doc(noteId).update({
      'isArchived': true,
      'updatedAt': DateTime.now().toIso8601String(),
    });
  }

  /// Unarchive a note
  Future<void> unarchiveNote(String noteId) async {
    if (_userId == null) {
      throw Exception('User not authenticated');
    }

    await _notesCollection.doc(noteId).update({
      'isArchived': false,
      'updatedAt': DateTime.now().toIso8601String(),
    });
  }

  /// Pin a note
  Future<void> pinNote(String noteId) async {
    if (_userId == null) {
      throw Exception('User not authenticated');
    }

    await _notesCollection.doc(noteId).update({
      'isPinned': true,
      'updatedAt': DateTime.now().toIso8601String(),
    });
  }

  /// Unpin a note
  Future<void> unpinNote(String noteId) async {
    if (_userId == null) {
      throw Exception('User not authenticated');
    }

    await _notesCollection.doc(noteId).update({
      'isPinned': false,
      'updatedAt': DateTime.now().toIso8601String(),
    });
  }

  /// Search notes by title or content
  Future<List<NoteModel>> searchNotes(String query) async {
    if (_userId == null) {
      throw Exception('User not authenticated');
    }

    if (query.trim().isEmpty) {
      return getNotes();
    }

    final snapshot = await _notesCollection
        .where('userId', isEqualTo: _userId)
        .where('isArchived', isEqualTo: false)
        .get();

    final allNotes = snapshot.docs
        .map((doc) => NoteModel.fromJson(doc.data() as Map<String, dynamic>))
        .toList();

    // Filter notes by title or content containing the query
    return allNotes
        .where(
          (note) =>
              note.title.toLowerCase().contains(query.toLowerCase()) ||
              note.content.toLowerCase().contains(query.toLowerCase()),
        )
        .toList();
  }

  /// Get notes by category
  Future<List<NoteModel>> getNotesByCategory(String category) async {
    if (_userId == null) {
      throw Exception('User not authenticated');
    }

    final snapshot = await _notesCollection
        .where('userId', isEqualTo: _userId)
        .where('category', isEqualTo: category)
        .where('isArchived', isEqualTo: false)
        .orderBy('isPinned', descending: true)
        .orderBy('updatedAt', descending: true)
        .get();

    return snapshot.docs
        .map((doc) => NoteModel.fromJson(doc.data() as Map<String, dynamic>))
        .toList();
  }

  /// Get pinned notes
  Future<List<NoteModel>> getPinnedNotes() async {
    if (_userId == null) {
      throw Exception('User not authenticated');
    }

    final snapshot = await _notesCollection
        .where('userId', isEqualTo: _userId)
        .where('isPinned', isEqualTo: true)
        .where('isArchived', isEqualTo: false)
        .orderBy('updatedAt', descending: true)
        .get();

    return snapshot.docs
        .map((doc) => NoteModel.fromJson(doc.data() as Map<String, dynamic>))
        .toList();
  }
}
