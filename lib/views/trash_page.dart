import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hive_flutter/hive_flutter.dart';
import '../cubits/notes_cubit/theme_cubit.dart';
import 'package:notes_app/models/note_model.dart';
import 'package:notes_app/views/home_page.dart';

class TrashPage extends StatelessWidget {
  const TrashPage({super.key});

  @override
  Widget build(BuildContext context) {
    var notesBox = Hive.box<NoteModel>('notes_box');
    final isDark = context.watch<ThemeCubit>().state;

    final background = isDark
        ? const Color(0xFF211D23)
        : HomePage.backgroundColor;
    final card = isDark ? const Color(0xFF332C36) : HomePage.cardColor;
    final text = isDark ? Colors.white : HomePage.textColor;
    final iconColor = isDark ? Colors.white : HomePage.darkPurple;

    return Scaffold(
      backgroundColor: background,
      appBar: AppBar(
        backgroundColor: background,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios_new_rounded, color: text),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          'Deleted Notes',
          style: TextStyle(color: text, fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
      ),
      body: Column(
        children: [
          // ================= BANNER =================
          Container(
            width: double.infinity,
            margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 14),
            decoration: BoxDecoration(
              color: isDark ? const Color(0xFF332C36) : const Color(0xFFD8CEDA),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Row(
              children: [
                Icon(
                  Icons.info_outline,
                  size: 20,
                  color: isDark ? Colors.white70 : HomePage.darkPurple,
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    'Items in Trash will be permanently deleted after 30 days.',
                    style: TextStyle(
                      fontSize: 13,
                      color: isDark ? Colors.white70 : HomePage.textColor,
                    ),
                  ),
                ),
              ],
            ),
          ),

          // ================= DELETED NOTES LIST =================
          Expanded(
            child: ValueListenableBuilder<Box<NoteModel>>(
              valueListenable: notesBox.listenable(),
              builder: (context, box, _) {
                final deletedNotes = box.values
                    .where((note) => note.isDeleted)
                    .toList();

                if (deletedNotes.isEmpty) {
                  return Center(
                    child: Text(
                      'No deleted notes',
                      style: TextStyle(
                        color: isDark ? Colors.white70 : Colors.grey,
                      ),
                    ),
                  );
                }

                return ListView.builder(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 8,
                  ),
                  itemCount: deletedNotes.length,
                  itemBuilder: (context, index) {
                    final note = deletedNotes[index];

                    return Card(
                      color: card,
                      elevation: 1,
                      margin: const EdgeInsets.only(bottom: 12),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: ListTile(
                        title: Text(
                          note.title,
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: text,
                          ),
                        ),
                        subtitle: Text(
                          note.content,
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                            color: isDark ? Colors.white70 : Colors.black87,
                          ),
                        ),
                        trailing: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            IconButton(
                              icon: Icon(Icons.restore, color: iconColor),
                              onPressed: () async {
                                note.isDeleted = false;
                                await note.save();
                              },
                            ),
                            IconButton(
                              icon: Icon(
                                Icons.delete_forever,
                                color: iconColor,
                              ),
                              onPressed: () async {
                                await note.delete();
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
          ),
        ],
      ),
    );
  }
}
