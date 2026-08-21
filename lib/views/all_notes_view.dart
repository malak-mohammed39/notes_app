import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:notes_app/cubits/notes_cubit/notes_cubit.dart';
import 'package:notes_app/cubits/notes_cubit/notes_state.dart';
import 'package:notes_app/cubits/notes_cubit/theme_cubit.dart';
import 'package:notes_app/models/note_model.dart';
import 'package:notes_app/views/home_page.dart';
import 'package:notes_app/views/edit_note_page.dart';

class AllNotesView extends StatelessWidget {
  const AllNotesView({super.key});

  @override
  Widget build(BuildContext context) {
    final isDark = context.watch<ThemeCubit>().state;

    final background = isDark
        ? const Color(0xFF211D23)
        : HomePage.backgroundColor;
    final card = isDark ? const Color(0xFF332C36) : HomePage.cardColor;
    final text = isDark ? Colors.white : HomePage.textColor;
    final secondaryText = isDark ? Colors.white70 : Colors.black87;
    final iconColor = isDark ? Colors.white : HomePage.darkPurple;

    return Scaffold(
      backgroundColor: background,
      appBar: AppBar(
        backgroundColor: background,
        elevation: 0,
        centerTitle: true,
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios_new_rounded, color: text),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        title: Text(
          'All Notes',
          style: TextStyle(
            color: text,
            fontSize: 24,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: BlocBuilder<NotesCubit, NotesState>(
        builder: (context, state) {
          if (state is NotesSuccess) {
            final notes = state.notes;

            if (notes.isEmpty) {
              return Center(
                child: Text(
                  'No notes available',
                  style: TextStyle(
                    color: isDark ? Colors.white70 : Colors.grey,
                    fontSize: 16,
                  ),
                ),
              );
            }

            return ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: notes.length,
              itemBuilder: (context, index) {
                final NoteModel note = notes[index];
                return GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => EditNotePage(note: note),
                      ),
                    );
                  },
                  child: Container(
                    margin: const EdgeInsets.only(bottom: 12),
                    padding: const EdgeInsets.all(14),
                    decoration: BoxDecoration(
                      color: card,
                      borderRadius: BorderRadius.circular(12),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.08),
                          blurRadius: 4,
                          offset: const Offset(0, 2),
                        ),
                      ],
                    ),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                note.title,
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                  color: text,
                                ),
                              ),
                              const SizedBox(height: 6),
                              Text(
                                note.content,
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                                style: TextStyle(
                                  fontSize: 14,
                                  color: secondaryText,
                                ),
                              ),
                            ],
                          ),
                        ),
                        Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            IconButton(
                              icon: Icon(
                                note.isFav
                                    ? Icons.favorite
                                    : Icons.favorite_border,
                                color: iconColor,
                                size: 24,
                              ),
                              onPressed: () {
                                context.read<NotesCubit>().addFav(note);
                              },
                            ),
                            IconButton(
                              icon: Icon(
                                Icons.delete_outline_rounded,
                                color: iconColor,
                                size: 24,
                              ),
                              onPressed: () {
                                context.read<NotesCubit>().MoveToTrach(note);
                                context.read<NotesCubit>().fetchAllNotes();
                              },
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                );
              },
            );
          } else if (state is NotesFailure) {
            return Center(
              child: Text(state.errorMessage, style: TextStyle(color: text)),
            );
          }
          return const Center(child: CircularProgressIndicator());
        },
      ),
    );
  }
}
