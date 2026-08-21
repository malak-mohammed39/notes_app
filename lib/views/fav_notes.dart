import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:notes_app/models/note_model.dart';
import 'package:notes_app/views/home_page.dart';
import 'package:notes_app/views/edit_note_page.dart';

class FavNotesView extends StatelessWidget {
  const FavNotesView({super.key});

  @override
  Widget build(BuildContext context) {
    var notesBox = Hive.box<NoteModel>('notes_box');

    return Scaffold(
      backgroundColor: HomePage.backgroundColor,
      appBar: AppBar(
        backgroundColor: HomePage.backgroundColor,
        elevation: 0,
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(
            Icons.arrow_back_ios_new_rounded,
            color: HomePage.textColor,
          ),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          'FAVOURITE NOTES',
          style: TextStyle(
            color: HomePage.textColor,
            fontSize: 24,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: ValueListenableBuilder<Box<NoteModel>>(
        valueListenable: notesBox.listenable(),
        builder: (context, box, _) {
          // جلب الملاحظات المفضلة وغير المحذوفة فقط
          final favNotes = box.values
              .where((note) => note.isFav && !note.isDeleted)
              .toList();

          if (favNotes.isEmpty) {
            return const Center(
              child: Text(
                'No favourite notes yet!',
                style: TextStyle(color: Colors.grey, fontSize: 16),
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
                    color: HomePage.cardColor,
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
                                color: HomePage.textColor,
                              ),
                            ),
                            const SizedBox(height: 6),
                            Text(
                              note.content,
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                              style: const TextStyle(
                                fontSize: 14,
                                color: Colors.black87,
                              ),
                            ),
                          ],
                        ),
                      ),

                      IconButton(
                        icon: const Icon(
                          Icons.favorite,
                          color: HomePage.darkPurple,
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
