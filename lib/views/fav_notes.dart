import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:notes_app/models/note_model.dart';
import 'package:notes_app/views/edit_note_page.dart';
import '../cubits/notes_cubit/theme_cubit.dart';

class FavNotesView extends StatelessWidget {
  const FavNotesView({super.key});

  @override
  Widget build(BuildContext context) {
    var notesBox = Hive.box<NoteModel>('notes_box');
    final isDark = context.watch<ThemeCubit>().state;

    final background = isDark
        ? const Color(0xFF211D23)
        : const Color(0xFFE8E2E8);
    final text = isDark ? Colors.white : const Color(0xFF29222B);
    final iconColor = isDark ? Colors.white : const Color(0xFF68447D);

    return Scaffold(
      backgroundColor: background,
      appBar: AppBar(
        backgroundColor: background,
        elevation: 0,
        centerTitle: true,
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios_new_rounded, color: text),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          'FAVOURITE NOTES',
          style: TextStyle(
            color: text,
            fontSize: 24,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: ValueListenableBuilder<Box<NoteModel>>(
        valueListenable: notesBox.listenable(),
        builder: (context, box, _) {
          final favNotes = box.values
              .where((note) => note.isFav && !note.isDeleted)
              .toList();

          if (favNotes.isEmpty) {
            return Center(
              child: Text(
                'No favourite notes yet!',
                style: TextStyle(
                  color: isDark ? Colors.white70 : Colors.grey,
                  fontSize: 16,
                ),
              ),
            );
          }

          return ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: favNotes.length,
            itemBuilder: (context, index) {
              final NoteModel note = favNotes[index];

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
                    // تطبيق اللون المخصص للنوت
                    color: Color(note.color),
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
                              style: const TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                color: Colors.black87,
                              ),
                            ),
                            const SizedBox(height: 6),
                            Text(
                              note.content,
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                              style: const TextStyle(
                                fontSize: 14,
                                color: Colors.black54,
                              ),
                            ),
                          ],
                        ),
                      ),
                      IconButton(
                        icon: const Icon(
                          Icons.favorite,
                          color: Color(0xFF68447D),
                          size: 24,
                        ),
                        onPressed: () async {
                          note.isFav = false;
                          await note.save();
                        },
                      ),
                    ],
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
