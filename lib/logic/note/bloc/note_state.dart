import 'package:equatable/equatable.dart';
import '../models/note_model.dart';

/// Base class for all note states
abstract class NoteState extends Equatable {
  const NoteState();

  @override
  List<Object?> get props => [];
}

/// Initial state when the app starts
class NoteInitial extends NoteState {
  const NoteInitial();
}

/// Loading state when notes are being fetched
class NoteLoading extends NoteState {
  const NoteLoading();
}

/// Error state when something goes wrong
class NoteError extends NoteState {
  final String message;

  const NoteError({required this.message});

  @override
  List<Object?> get props => [message];
}

/// Empty state when no notes exist
class NoteEmpty extends NoteState {
  const NoteEmpty();
}

/// Loaded state when notes are successfully fetched
class NoteLoaded extends NoteState {
  final List<NoteModel> notes;
  final List<NoteModel> pinnedNotes;
  final List<NoteModel> regularNotes;
  final String? searchQuery;
  final String? filterCategory;
  final int totalNotes;
  final int pinnedCount;
  final bool isShowingArchived;

  const NoteLoaded({
    required this.notes,
    required this.pinnedNotes,
    required this.regularNotes,
    this.searchQuery,
    this.filterCategory,
    required this.totalNotes,
    required this.pinnedCount,
    this.isShowingArchived = false,
  });

  @override
  List<Object?> get props => [
    notes,
    pinnedNotes,
    regularNotes,
    searchQuery,
    filterCategory,
    totalNotes,
    pinnedCount,
    isShowingArchived,
  ];

  /// Check if notes are being filtered
  bool get isFiltered => searchQuery != null || filterCategory != null;

  /// Get notes by category
  List<NoteModel> getNotesByCategory(String category) {
    return notes.where((note) => note.category == category).toList();
  }

  /// Get available categories
  List<String> get availableCategories {
    return notes.map((note) => note.category).toSet().toList()..sort();
  }
}

/// State when a note operation is in progress
class NoteActionInProgress extends NoteState {
  final List<NoteModel> current;
  final String action;

  const NoteActionInProgress({required this.current, required this.action});

  @override
  List<Object?> get props => [current, action];
}

/// State when a note operation is successful
class NoteOperationSuccess extends NoteState {
  final String message;
  final List<NoteModel> notes;

  const NoteOperationSuccess({required this.message, required this.notes});

  @override
  List<Object?> get props => [message, notes];
}
