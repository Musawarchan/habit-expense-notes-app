import 'dart:async';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'note_event.dart';
import 'note_state.dart';
import '../repository/note_repository.dart';
import '../models/note_model.dart';

/// BLoC for managing note state and business logic
/// Handles all note-related events and emits appropriate states
class NoteBloc extends Bloc<NoteEvent, NoteState> {
  final NoteRepository _noteRepository;
  StreamSubscription<List<NoteModel>>? _notesSubscription;

  NoteBloc({required NoteRepository noteRepository})
    : _noteRepository = noteRepository,
      super(const NoteInitial()) {
    // Register event handlers
    on<NoteLoadRequested>(_onLoadRequested);
    on<NoteLoadArchivedRequested>(_onLoadArchivedRequested);
    on<NoteAddRequested>(_onAddRequested);
    on<NoteUpdateRequested>(_onUpdateRequested);
    on<NoteDeleteRequested>(_onDeleteRequested);
    on<NoteArchiveRequested>(_onArchiveRequested);
    on<NoteUnarchiveRequested>(_onUnarchiveRequested);
    on<NotePinRequested>(_onPinRequested);
    on<NoteUnpinRequested>(_onUnpinRequested);
    on<NoteSearchRequested>(_onSearchRequested);
    on<NoteFilterByCategoryRequested>(_onFilterByCategoryRequested);
    on<NoteFilterCleared>(_onFilterCleared);
    on<NoteListChanged>(_onListChanged);
    on<NoteRefreshRequested>(_onRefreshRequested);
  }

  /// Handle note load request
  /// Sets up real-time listener for note changes
  Future<void> _onLoadRequested(
    NoteLoadRequested event,
    Emitter<NoteState> emit,
  ) async {
    try {
      emit(const NoteLoading());

      // Cancel existing subscription if any
      await _notesSubscription?.cancel();

      // Subscribe to notes stream
      _notesSubscription = _noteRepository.getNotesStream().listen(
        (notes) => add(NoteListChanged(notes: notes, isArchived: false)),
      );
    } catch (e) {
      emit(NoteError(message: e.toString()));
    }
  }

  /// Handle archived notes load request
  /// Sets up real-time listener for archived note changes
  Future<void> _onLoadArchivedRequested(
    NoteLoadArchivedRequested event,
    Emitter<NoteState> emit,
  ) async {
    try {
      emit(const NoteLoading());

      // Cancel existing subscription if any
      await _notesSubscription?.cancel();

      // Subscribe to archived notes stream
      _notesSubscription = _noteRepository.getArchivedNotesStream().listen(
        (notes) => add(NoteListChanged(notes: notes, isArchived: true)),
      );
    } catch (e) {
      emit(NoteError(message: e.toString()));
    }
  }

  /// Handle note add request
  Future<void> _onAddRequested(
    NoteAddRequested event,
    Emitter<NoteState> emit,
  ) async {
    try {
      print('NoteBloc: Adding note - ${event.note.title}');
      await _noteRepository.addNote(event.note);
      print('NoteBloc: Note added successfully');
      // Don't emit success - the stream will automatically update
    } catch (e) {
      print('NoteBloc: Error adding note - $e');
      emit(NoteError(message: 'Failed to add note: ${e.toString()}'));
    }
  }

  /// Handle note update request
  Future<void> _onUpdateRequested(
    NoteUpdateRequested event,
    Emitter<NoteState> emit,
  ) async {
    try {
      await _noteRepository.updateNote(event.note);
      // Don't emit success - the stream will automatically update
    } catch (e) {
      emit(NoteError(message: 'Failed to update note: ${e.toString()}'));
    }
  }

  /// Handle note delete request
  Future<void> _onDeleteRequested(
    NoteDeleteRequested event,
    Emitter<NoteState> emit,
  ) async {
    try {
      await _noteRepository.deleteNote(event.noteId);
      // Don't emit success - the stream will automatically update
    } catch (e) {
      emit(NoteError(message: 'Failed to delete note: ${e.toString()}'));
    }
  }

  /// Handle note archive request
  Future<void> _onArchiveRequested(
    NoteArchiveRequested event,
    Emitter<NoteState> emit,
  ) async {
    try {
      await _noteRepository.archiveNote(event.noteId);
      // Don't emit success - the stream will automatically update
    } catch (e) {
      emit(NoteError(message: 'Failed to archive note: ${e.toString()}'));
    }
  }

  /// Handle note unarchive request
  Future<void> _onUnarchiveRequested(
    NoteUnarchiveRequested event,
    Emitter<NoteState> emit,
  ) async {
    try {
      await _noteRepository.unarchiveNote(event.noteId);
      // Switch back to regular notes view after unarchiving
      add(const NoteLoadRequested());
    } catch (e) {
      emit(NoteError(message: 'Failed to unarchive note: ${e.toString()}'));
    }
  }

  /// Handle note pin request
  Future<void> _onPinRequested(
    NotePinRequested event,
    Emitter<NoteState> emit,
  ) async {
    try {
      await _noteRepository.pinNote(event.noteId);
      // Don't emit success - the stream will automatically update
    } catch (e) {
      emit(NoteError(message: 'Failed to pin note: ${e.toString()}'));
    }
  }

  /// Handle note unpin request
  Future<void> _onUnpinRequested(
    NoteUnpinRequested event,
    Emitter<NoteState> emit,
  ) async {
    try {
      await _noteRepository.unpinNote(event.noteId);
      // Don't emit success - the stream will automatically update
    } catch (e) {
      emit(NoteError(message: 'Failed to unpin note: ${e.toString()}'));
    }
  }

  /// Handle note search request
  Future<void> _onSearchRequested(
    NoteSearchRequested event,
    Emitter<NoteState> emit,
  ) async {
    try {
      emit(const NoteLoading());
      final notes = await _noteRepository.searchNotes(event.query);

      if (notes.isEmpty) {
        emit(const NoteEmpty());
      } else {
        final pinnedNotes = notes.where((note) => note.isPinned).toList();
        final regularNotes = notes.where((note) => !note.isPinned).toList();

        emit(
          NoteLoaded(
            notes: notes,
            pinnedNotes: pinnedNotes,
            regularNotes: regularNotes,
            searchQuery: event.query,
            totalNotes: notes.length,
            pinnedCount: pinnedNotes.length,
          ),
        );
      }
    } catch (e) {
      emit(NoteError(message: 'Failed to search notes: ${e.toString()}'));
    }
  }

  /// Handle filter by category request
  Future<void> _onFilterByCategoryRequested(
    NoteFilterByCategoryRequested event,
    Emitter<NoteState> emit,
  ) async {
    try {
      emit(const NoteLoading());
      final notes = await _noteRepository.getNotesByCategory(event.category);

      if (notes.isEmpty) {
        emit(const NoteEmpty());
      } else {
        final pinnedNotes = notes.where((note) => note.isPinned).toList();
        final regularNotes = notes.where((note) => !note.isPinned).toList();

        emit(
          NoteLoaded(
            notes: notes,
            pinnedNotes: pinnedNotes,
            regularNotes: regularNotes,
            filterCategory: event.category,
            totalNotes: notes.length,
            pinnedCount: pinnedNotes.length,
          ),
        );
      }
    } catch (e) {
      emit(NoteError(message: 'Failed to filter notes: ${e.toString()}'));
    }
  }

  /// Handle filter clear request
  Future<void> _onFilterCleared(
    NoteFilterCleared event,
    Emitter<NoteState> emit,
  ) async {
    // Reload all notes
    add(const NoteLoadRequested());
  }

  /// Handle notes list change (from stream)
  Future<void> _onListChanged(
    NoteListChanged event,
    Emitter<NoteState> emit,
  ) async {
    print('NoteBloc: List changed - ${event.notes.length} notes received');
    if (!emit.isDone) {
      if (event.notes.isEmpty) {
        print('NoteBloc: Emitting empty state');
        emit(const NoteEmpty());
      } else {
        final pinnedNotes = event.notes.where((note) => note.isPinned).toList();
        final regularNotes = event.notes
            .where((note) => !note.isPinned)
            .toList();

        print(
          'NoteBloc: Emitting loaded state - ${event.notes.length} total, ${pinnedNotes.length} pinned, ${regularNotes.length} regular',
        );
        emit(
          NoteLoaded(
            notes: event.notes,
            pinnedNotes: pinnedNotes,
            regularNotes: regularNotes,
            totalNotes: event.notes.length,
            pinnedCount: pinnedNotes.length,
            isShowingArchived: event.isArchived,
          ),
        );
      }
    }
  }

  /// Handle refresh request
  Future<void> _onRefreshRequested(
    NoteRefreshRequested event,
    Emitter<NoteState> emit,
  ) async {
    // Reload all notes
    add(const NoteLoadRequested());
  }

  /// Refresh current view (regular or archived)
  void refreshCurrentView() {
    final currentState = state;
    if (currentState is NoteLoaded && currentState.isShowingArchived) {
      add(const NoteLoadArchivedRequested());
    } else {
      add(const NoteLoadRequested());
    }
  }

  @override
  Future<void> close() {
    _notesSubscription?.cancel();
    return super.close();
  }
}
