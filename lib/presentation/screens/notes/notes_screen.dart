import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/constants/app_strings.dart';
import '../../../../core/services/dialog_service.dart';
import '../../../../logic/note/bloc/note_bloc.dart';
import '../../../../logic/note/bloc/note_event.dart';
import '../../../../logic/note/bloc/note_state.dart';
import '../../../../logic/note/models/note_model.dart';
import '../../../../logic/auth/bloc/auth_bloc.dart';
import '../../../../logic/auth/bloc/auth_state.dart';

class NotesScreen extends StatelessWidget {
  const NotesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // Load notes when screen initializes
    // WidgetsBinding.instance.addPostFrameCallback((_) {
    final authState = context.read<AuthBloc>().state;
    if (authState is AuthAuthenticated) {
      context.read<NoteBloc>().add(const NoteLoadRequested());
    }
    // });
    return Scaffold(
      appBar: AppBar(
        title: BlocBuilder<NoteBloc, NoteState>(
          builder: (context, state) {
            if (state is NoteLoaded && state.isShowingArchived) {
              return const Text('Archived Notes');
            }
            return Text(AppStrings.notes);
          },
        ),
        // leading: IconButton(
        //   icon: const Icon(Icons.arrow_back),
        //   onPressed: () => context.pop(),
        // ),
        actions: [
          IconButton(
            icon: const Icon(Icons.search),
            onPressed: () => _showSearchDialog(context),
          ),
          IconButton(
            icon: const Icon(Icons.filter_list),
            onPressed: () => _showFilterDialog(context),
          ),
          IconButton(
            icon: const Icon(Icons.archive),
            onPressed: () => _toggleArchiveView(context),
          ),
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: () {
              context.read<NoteBloc>().add(const NoteRefreshRequested());
            },
          ),
        ],
      ),
      body: MultiBlocListener(
        listeners: [
          BlocListener<AuthBloc, AuthState>(
            listener: (context, authState) {
              if (authState is AuthAuthenticated) {
                print('NotesScreen: User authenticated, loading notes');
                context.read<NoteBloc>().add(const NoteLoadRequested());
              }
            },
          ),
          BlocListener<NoteBloc, NoteState>(
            listener: (context, state) {
              if (state is NoteOperationSuccess) {
                ScaffoldMessenger.of(
                  context,
                ).showSnackBar(SnackBar(content: Text(state.message)));
              } else if (state is NoteError) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(state.message),
                    backgroundColor: Colors.red,
                  ),
                );
              }
            },
          ),
        ],
        child: BlocBuilder<NoteBloc, NoteState>(
          builder: (context, state) {
            print('NotesScreen: Current state - ${state.runtimeType}');

            if (state is NoteLoading) {
              print('NotesScreen: Showing loading state');
              return const Center(child: CircularProgressIndicator());
            }

            if (state is NoteError) {
              print('NotesScreen: Showing error state - ${state.message}');
              return Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(
                      Icons.error_outline,
                      size: 64,
                      color: Colors.red,
                    ),
                    const SizedBox(height: 16),
                    Text(
                      state.message,
                      style: const TextStyle(fontSize: 16),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 16),
                    ElevatedButton(
                      onPressed: () {
                        context.read<NoteBloc>().add(const NoteLoadRequested());
                      },
                      child: const Text('Retry'),
                    ),
                  ],
                ),
              );
            }

            if (state is NoteEmpty) {
              print('NotesScreen: Showing empty state');
              return _buildEmptyState(context, false);
            }

            if (state is NoteLoaded) {
              print(
                'NotesScreen: Showing loaded state - ${state.notes.length} notes',
              );
              if (state.notes.isEmpty) {
                return _buildEmptyState(context, state.isShowingArchived);
              }
              return _buildNotesList(context, state);
            }

            print('NotesScreen: Showing default loading state');
            return const Center(child: CircularProgressIndicator());
          },
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => DialogService.showAddNoteDialog(context),
        child: const Icon(Icons.add),
      ),
    );
  }

  Widget _buildEmptyState(BuildContext context, bool isArchived) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            isArchived ? Icons.archive : Icons.note,
            size: 64,
            color: Colors.grey,
          ),
          const SizedBox(height: 16),
          Text(
            isArchived ? 'No Archived Notes' : 'No Notes Yet',
            style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 8),
          Text(
            isArchived
                ? 'Your archived notes will appear here'
                : 'Capture your thoughts and ideas',
            style: const TextStyle(fontSize: 16, color: Colors.grey),
          ),
          const SizedBox(height: 24),
          if (!isArchived)
            ElevatedButton.icon(
              onPressed: () => DialogService.showAddNoteDialog(context),
              icon: const Icon(Icons.add),
              label: const Text('Add Your First Note'),
            ),
        ],
      ),
    );
  }

  Widget _buildNotesList(BuildContext context, NoteLoaded state) {
    return Column(
      children: [
        // Search and filter info
        if (state.isFiltered) _buildFilterInfo(context, state),

        // Pinned notes section
        if (state.pinnedNotes.isNotEmpty) ...[
          _buildSectionHeader(
            context,
            'Pinned Notes',
            state.pinnedNotes.length,
          ),
          Expanded(
            flex: state.pinnedNotes.length,
            child: _buildNotesGrid(context, state.pinnedNotes),
          ),
        ],

        // Regular notes section
        if (state.regularNotes.isNotEmpty) ...[
          if (state.pinnedNotes.isNotEmpty)
            _buildSectionHeader(
              context,
              'All Notes',
              state.regularNotes.length,
            ),
          Expanded(child: _buildNotesGrid(context, state.regularNotes)),
        ],
      ],
    );
  }

  Widget _buildFilterInfo(BuildContext context, NoteLoaded state) {
    return Container(
      padding: const EdgeInsets.all(16),
      color: Theme.of(context).colorScheme.surfaceVariant,
      child: Row(
        children: [
          Icon(Icons.filter_list, color: Theme.of(context).colorScheme.primary),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              state.searchQuery != null
                  ? 'Search: "${state.searchQuery}"'
                  : 'Category: ${state.filterCategory}',
              style: TextStyle(
                color: Theme.of(context).colorScheme.primary,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
          TextButton(
            onPressed: () {
              context.read<NoteBloc>().add(const NoteFilterCleared());
            },
            child: const Text('Clear'),
          ),
        ],
      ),
    );
  }

  Widget _buildSectionHeader(BuildContext context, String title, int count) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Row(
        children: [
          Text(
            title,
            style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          const SizedBox(width: 8),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.primary,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Text(
              count.toString(),
              style: TextStyle(
                color: Theme.of(context).colorScheme.onPrimary,
                fontSize: 12,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildNotesGrid(BuildContext context, List<NoteModel> notes) {
    return GridView.builder(
      padding: const EdgeInsets.all(16),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        childAspectRatio: 0.8,
        crossAxisSpacing: 16,
        mainAxisSpacing: 16,
      ),
      itemCount: notes.length,
      itemBuilder: (context, index) {
        return _buildNoteCard(context, notes[index]);
      },
    );
  }

  Widget _buildNoteCard(BuildContext context, NoteModel note) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.08),
            blurRadius: note.isPinned ? 12 : 8,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Material(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        child: InkWell(
          onTap: () => _showNoteDetails(context, note),
          borderRadius: BorderRadius.circular(16),
          child: Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(16),
              gradient: note.isPinned
                  ? LinearGradient(
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                      colors: [Colors.orange.shade50, Colors.white],
                    )
                  : null,
              border: note.isPinned
                  ? Border.all(color: Colors.orange.shade200, width: 1)
                  : null,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Header with pin icon and actions
                Row(
                  children: [
                    if (note.isPinned) ...[
                      Container(
                        padding: const EdgeInsets.all(4),
                        decoration: BoxDecoration(
                          color: Colors.orange.shade100,
                          borderRadius: BorderRadius.circular(6),
                        ),
                        child: Icon(
                          Icons.push_pin,
                          size: 14,
                          color: Colors.orange.shade700,
                        ),
                      ),
                      const SizedBox(width: 8),
                    ],
                    Expanded(
                      child: Text(
                        note.title,
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: note.isPinned
                              ? Colors.orange.shade800
                              : Colors.grey.shade800,
                        ),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    PopupMenuButton<String>(
                      onSelected: (value) =>
                          _handleNoteAction(context, value, note),
                      icon: Icon(
                        Icons.more_vert,
                        color: Colors.grey.shade600,
                        size: 20,
                      ),
                      itemBuilder: (context) => [
                        PopupMenuItem(
                          value: 'edit',
                          child: Row(
                            children: [
                              Icon(
                                Icons.edit,
                                color: Colors.green.shade600,
                                size: 18,
                              ),
                              const SizedBox(width: 12),
                              const Text(
                                'Edit',
                                style: TextStyle(fontSize: 14),
                              ),
                            ],
                          ),
                        ),
                        if (!note.isArchived)
                          PopupMenuItem(
                            value: note.isPinned ? 'unpin' : 'pin',
                            child: Row(
                              children: [
                                Icon(
                                  note.isPinned
                                      ? Icons.push_pin_outlined
                                      : Icons.push_pin,
                                  color: Colors.orange.shade600,
                                  size: 18,
                                ),
                                const SizedBox(width: 12),
                                Text(
                                  note.isPinned ? 'Unpin' : 'Pin',
                                  style: const TextStyle(fontSize: 14),
                                ),
                              ],
                            ),
                          ),
                        PopupMenuItem(
                          value: note.isArchived ? 'unarchive' : 'archive',
                          child: Row(
                            children: [
                              Icon(
                                note.isArchived
                                    ? Icons.unarchive
                                    : Icons.archive,
                                color: Colors.blue.shade600,
                                size: 18,
                              ),
                              const SizedBox(width: 12),
                              Text(
                                note.isArchived ? 'Unarchive' : 'Archive',
                                style: const TextStyle(fontSize: 14),
                              ),
                            ],
                          ),
                        ),
                        PopupMenuItem(
                          value: 'delete',
                          child: Row(
                            children: [
                              Icon(
                                Icons.delete,
                                color: Colors.red.shade600,
                                size: 18,
                              ),
                              const SizedBox(width: 12),
                              Text(
                                'Delete',
                                style: TextStyle(
                                  color: Colors.red.shade600,
                                  fontSize: 14,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ],
                ),

                const SizedBox(height: 12),

                // Note content preview
                Expanded(
                  child: Text(
                    note.content,
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.grey.shade700,
                      height: 1.4,
                    ),
                    maxLines: 4,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),

                const SizedBox(height: 12),

                // Tags (if any)
                if (note.tags.isNotEmpty) ...[
                  Wrap(
                    spacing: 6,
                    runSpacing: 4,
                    children: note.tags.take(2).map((tag) {
                      return Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 8,
                          vertical: 2,
                        ),
                        decoration: BoxDecoration(
                          color: Colors.grey.shade100,
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Text(
                          '#$tag',
                          style: TextStyle(
                            fontSize: 10,
                            color: Colors.grey.shade600,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      );
                    }).toList(),
                  ),
                  const SizedBox(height: 8),
                ],

                // Footer with category and date
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 10,
                        vertical: 4,
                      ),
                      decoration: BoxDecoration(
                        color: _getCategoryColor(
                          note.category,
                        ).withOpacity(0.1),
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(
                          color: _getCategoryColor(
                            note.category,
                          ).withOpacity(0.3),
                          width: 1,
                        ),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(
                            _getCategoryIcon(note.category),
                            size: 12,
                            color: _getCategoryColor(note.category),
                          ),
                          const SizedBox(width: 4),
                          Text(
                            note.category,
                            style: TextStyle(
                              fontSize: 11,
                              color: _getCategoryColor(note.category),
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const Spacer(),
                    Text(
                      _formatDate(note.updatedAt),
                      style: TextStyle(
                        fontSize: 11,
                        color: Colors.grey.shade500,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Color _getCategoryColor(String category) {
    switch (category.toLowerCase()) {
      case 'personal':
        return Colors.purple;
      case 'work':
        return Colors.blue;
      case 'ideas':
        return Colors.green;
      case 'learning':
        return Colors.orange;
      case 'other':
        return Colors.grey;
      default:
        return Colors.blue;
    }
  }

  IconData _getCategoryIcon(String category) {
    switch (category.toLowerCase()) {
      case 'personal':
        return Icons.person;
      case 'work':
        return Icons.work;
      case 'ideas':
        return Icons.lightbulb;
      case 'learning':
        return Icons.school;
      case 'other':
        return Icons.category;
      default:
        return Icons.note;
    }
  }

  void _showNoteDetails(BuildContext context, NoteModel note) {
    showDialog(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: Text(note.title),
        content: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(note.content),
              const SizedBox(height: 16),
              _buildDetailRow('Category', note.category),
              _buildDetailRow('Created', _formatDate(note.createdAt)),
              _buildDetailRow('Updated', _formatDate(note.updatedAt)),
              if (note.tags.isNotEmpty)
                _buildDetailRow('Tags', note.tags.join(', ')),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogContext),
            child: const Text('Close'),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(dialogContext);
              _handleNoteAction(context, 'delete', note);
            },
            child: const Text('Delete', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }

  Widget _buildDetailRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 80,
            child: Text(
              '$label:',
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
          ),
          Expanded(child: Text(value)),
        ],
      ),
    );
  }

  void _handleNoteAction(BuildContext context, String action, NoteModel note) {
    switch (action) {
      case 'edit':
        _showEditNoteDialog(context, note);
        break;
      case 'pin':
        context.read<NoteBloc>().add(NotePinRequested(noteId: note.id));
        break;
      case 'unpin':
        context.read<NoteBloc>().add(NoteUnpinRequested(noteId: note.id));
        break;
      case 'archive':
        context.read<NoteBloc>().add(NoteArchiveRequested(noteId: note.id));
        // Show success message
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Note archived successfully'),
            backgroundColor: Colors.blue,
            duration: Duration(seconds: 2),
          ),
        );
        break;
      case 'unarchive':
        context.read<NoteBloc>().add(NoteUnarchiveRequested(noteId: note.id));
        // Show success message
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Note unarchived and moved to regular notes'),
            backgroundColor: Colors.green,
            duration: Duration(seconds: 2),
          ),
        );
        break;
      case 'delete':
        _showDeleteConfirmation(context, note);
        break;
    }
  }

  void _showEditNoteDialog(BuildContext context, NoteModel note) {
    final titleController = TextEditingController(text: note.title);
    final contentController = TextEditingController(text: note.content);
    final tagsController = TextEditingController(text: note.tags.join(', '));

    String selectedCategory = note.category;
    final categories = ['Personal', 'Work', 'Ideas', 'Learning', 'Other'];

    showDialog(
      context: context,
      builder: (dialogContext) => StatefulBuilder(
        builder: (context, setState) => AlertDialog(
          title: const Text('Edit Note'),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextField(
                  controller: titleController,
                  decoration: const InputDecoration(
                    labelText: 'Title',
                    border: OutlineInputBorder(),
                  ),
                  maxLines: 1,
                ),
                const SizedBox(height: 16),
                TextField(
                  controller: contentController,
                  decoration: const InputDecoration(
                    labelText: 'Content',
                    border: OutlineInputBorder(),
                  ),
                  maxLines: 4,
                ),
                const SizedBox(height: 16),
                DropdownButtonFormField<String>(
                  value: selectedCategory,
                  decoration: const InputDecoration(
                    labelText: 'Category',
                    border: OutlineInputBorder(),
                  ),
                  items: categories.map((category) {
                    return DropdownMenuItem(
                      value: category,
                      child: Text(category),
                    );
                  }).toList(),
                  onChanged: (value) {
                    setState(() {
                      selectedCategory = value!;
                    });
                  },
                ),
                const SizedBox(height: 16),
                TextField(
                  controller: tagsController,
                  decoration: const InputDecoration(
                    labelText: 'Tags (comma separated)',
                    border: OutlineInputBorder(),
                    hintText: 'e.g., important, meeting, project',
                  ),
                  maxLines: 1,
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(dialogContext),
              child: const Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () {
                final updatedNote = note.copyWith(
                  title: titleController.text.trim(),
                  content: contentController.text.trim(),
                  category: selectedCategory,
                  tags: tagsController.text
                      .split(',')
                      .map((tag) => tag.trim())
                      .where((tag) => tag.isNotEmpty)
                      .toList(),
                  updatedAt: DateTime.now(),
                );

                context.read<NoteBloc>().add(
                  NoteUpdateRequested(note: updatedNote),
                );
                Navigator.pop(dialogContext);
              },
              child: const Text('Save'),
            ),
          ],
        ),
      ),
    );
  }

  void _showDeleteConfirmation(BuildContext context, NoteModel note) {
    showDialog(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: const Text('Delete Note'),
        content: Text('Are you sure you want to delete "${note.title}"?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogContext),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(dialogContext);
              context.read<NoteBloc>().add(
                NoteDeleteRequested(noteId: note.id),
              );
            },
            child: const Text('Delete', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }

  void _showSearchDialog(BuildContext context) {
    final searchController = TextEditingController();

    showDialog(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: const Text('Search Notes'),
        content: TextField(
          controller: searchController,
          decoration: const InputDecoration(
            hintText: 'Search by title or content...',
            border: OutlineInputBorder(),
          ),
          autofocus: true,
        ),
        actions: [
          TextButton(
            onPressed: () {
              searchController.clear();
              Navigator.pop(dialogContext);
            },
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              final query = searchController.text.trim();
              if (query.isNotEmpty) {
                context.read<NoteBloc>().add(NoteSearchRequested(query: query));
              }
              Navigator.pop(dialogContext);
            },
            child: const Text('Search'),
          ),
        ],
      ),
    );
  }

  void _showFilterDialog(BuildContext context) {
    // Get available categories from current state
    final currentState = context.read<NoteBloc>().state;
    List<String> categories = ['All'];

    if (currentState is NoteLoaded) {
      categories.addAll(currentState.availableCategories);
    }

    String selectedCategory = 'All';

    showDialog(
      context: context,
      builder: (dialogContext) => StatefulBuilder(
        builder: (context, setState) => AlertDialog(
          title: const Text('Filter by Category'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: categories.map((category) {
              return RadioListTile<String>(
                title: Text(category),
                value: category,
                groupValue: selectedCategory,
                onChanged: (value) {
                  setState(() => selectedCategory = value!);
                },
              );
            }).toList(),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(dialogContext),
              child: const Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () {
                if (selectedCategory == 'All') {
                  context.read<NoteBloc>().add(const NoteFilterCleared());
                } else {
                  context.read<NoteBloc>().add(
                    NoteFilterByCategoryRequested(category: selectedCategory),
                  );
                }
                Navigator.pop(dialogContext);
              },
              child: const Text('Apply'),
            ),
          ],
        ),
      ),
    );
  }

  void _toggleArchiveView(BuildContext context) {
    final currentState = context.read<NoteBloc>().state;
    bool isShowingArchived = false;

    if (currentState is NoteLoaded) {
      isShowingArchived = currentState.isShowingArchived;
    }

    showDialog(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: const Text('Archive Options'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              leading: Icon(
                isShowingArchived ? Icons.note : Icons.archive,
                color: isShowingArchived ? Colors.blue : Colors.orange,
              ),
              title: Text(
                isShowingArchived
                    ? 'View Regular Notes'
                    : 'View Archived Notes',
              ),
              subtitle: Text(
                isShowingArchived
                    ? 'Switch back to regular notes'
                    : 'View your archived notes',
              ),
              onTap: () {
                Navigator.pop(dialogContext);
                if (isShowingArchived) {
                  context.read<NoteBloc>().add(const NoteLoadRequested());
                } else {
                  context.read<NoteBloc>().add(
                    const NoteLoadArchivedRequested(),
                  );
                }
              },
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogContext),
            child: const Text('Cancel'),
          ),
        ],
      ),
    );
  }

  String _formatDate(DateTime date) {
    final now = DateTime.now();
    final difference = now.difference(date);

    if (difference.inDays == 0) {
      return 'Today';
    } else if (difference.inDays == 1) {
      return 'Yesterday';
    } else if (difference.inDays < 7) {
      return '${difference.inDays} days ago';
    } else {
      return '${date.day}/${date.month}/${date.year}';
    }
  }
}
