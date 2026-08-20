import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:notes_app/models/note_model.dart';
import 'package:notes_app/views/home_page.dart';

class TrashPage extends StatelessWidget {
  const TrashPage({super.key});

  @override
  Widget build(BuildContext context) {
    var notesBox = Hive.box<NoteModel>('notes_box');

    return Scaffold(
      backgroundColor: HomePage.backgroundColor,
      appBar: AppBar(
        backgroundColor: HomePage.backgroundColor,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(
            Icons.arrow_back_ios_new_rounded,
            color: Colors.black,
          ),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          'Deleted Notes',
          style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
      ),
      body: ValueListenableBuilder<Box<NoteModel>>(
        valueListenable: notesBox.listenable(),
        builder: (context, box, _) {
          final deletedNotes = box.values
              .where((note) => note.isDeleted)
              .toList();

          if (deletedNotes.isEmpty) {
            return const Center(child: Text('No deleted notes'));
          }

          return ListView.builder(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            itemCount: deletedNotes.length,
            itemBuilder: (context, index) {
              final note = deletedNotes[index];

              return Card(
                color: const Color.fromARGB(255, 215, 214, 217),
                elevation: 1,
                margin: const EdgeInsets.only(bottom: 12),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
                child: ListTile(
                  title: Text(
                    note.title,
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF29222B),
                    ),
                  ),
                  subtitle: Text(
                    note.content,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      IconButton(
                        icon: const Icon(
                          Icons.restore,
                          color: Color(0xff5C4B7D),
                        ),
                        onPressed: () async {
                          note.isDeleted = false;
                          await note.save();
                        },
                      ),

                      IconButton(
                        icon: const Icon(
                          Icons.delete_forever,
                          color: Color(0xff5C4B7D),
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
    );
  }
}
