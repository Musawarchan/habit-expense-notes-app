import 'package:equatable/equatable.dart';
import '../models/note_model.dart';

/// Base class for all note events
abstract class NoteEvent extends Equatable {
  const NoteEvent();

  @override
  List<Object?> get props => [];
}

/// Event to load notes
class NoteLoadRequested extends NoteEvent {
  const NoteLoadRequested();
}

/// Event to load archived notes
class NoteLoadArchivedRequested extends NoteEvent {
  const NoteLoadArchivedRequested();
}

/// Event to add a new note
class NoteAddRequested extends NoteEvent {
  final NoteModel note;

  const NoteAddRequested({required this.note});

  @override
  List<Object?> get props => [note];
}

/// Event to update an existing note
class NoteUpdateRequested extends NoteEvent {
  final NoteModel note;

  const NoteUpdateRequested({required this.note});

  @override
  List<Object?> get props => [note];
}

/// Event to delete a note
class NoteDeleteRequested extends NoteEvent {
  final String noteId;

  const NoteDeleteRequested({required this.noteId});

  @override
  List<Object?> get props => [noteId];
}

/// Event to archive a note
class NoteArchiveRequested extends NoteEvent {
  final String noteId;

  const NoteArchiveRequested({required this.noteId});

  @override
  List<Object?> get props => [noteId];
}

/// Event to unarchive a note
class NoteUnarchiveRequested extends NoteEvent {
  final String noteId;

  const NoteUnarchiveRequested({required this.noteId});

  @override
  List<Object?> get props => [noteId];
}

/// Event to pin a note
class NotePinRequested extends NoteEvent {
  final String noteId;

  const NotePinRequested({required this.noteId});

  @override
  List<Object?> get props => [noteId];
}

/// Event to unpin a note
class NoteUnpinRequested extends NoteEvent {
  final String noteId;

  const NoteUnpinRequested({required this.noteId});

  @override
  List<Object?> get props => [noteId];
}

/// Event to search notes
class NoteSearchRequested extends NoteEvent {
  final String query;

  const NoteSearchRequested({required this.query});

  @override
  List<Object?> get props => [query];
}

/// Event to filter notes by category
class NoteFilterByCategoryRequested extends NoteEvent {
  final String category;

  const NoteFilterByCategoryRequested({required this.category});

  @override
  List<Object?> get props => [category];
}

/// Event to clear search/filter
class NoteFilterCleared extends NoteEvent {
  const NoteFilterCleared();
}

/// Event when notes list changes (from stream)
class NoteListChanged extends NoteEvent {
  final List<NoteModel> notes;
  final bool isArchived;

  const NoteListChanged({required this.notes, this.isArchived = false});

  @override
  List<Object?> get props => [notes, isArchived];
}

/// Event to refresh notes
class NoteRefreshRequested extends NoteEvent {
  const NoteRefreshRequested();
}
