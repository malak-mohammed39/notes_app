import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../cubits/notes_cubit/notes_cubit.dart';
import '../cubits/notes_cubit/notes_state.dart';
import '../cubits/notes_cubit/theme_cubit.dart';
import 'package:notes_app/models/note_model.dart';
import 'package:notes_app/views/home_page.dart';

class TrashPage extends StatefulWidget {
  const TrashPage({super.key});

  @override
  State<TrashPage> createState() => _TrashPageState();
}

class _TrashPageState extends State<TrashPage> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      BlocProvider.of<NotesCubit>(context).fetchDeletedones();
    });
  }

  Future<bool?> _showDeleteConfirmationDialog(BuildContext context) {
    return showDialog<bool>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: const Color.fromARGB(255, 138, 128, 168),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          title: const Text(
            'Confirm final deletion',
            style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
          ),
          content: const Text(
            'Item/s will be permanently deleted from the cloud and all your devices.',
            style: TextStyle(color: Colors.white),
          ),
          actions: [
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color.fromARGB(255, 138, 128, 168),
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              onPressed: () => Navigator.of(context).pop(false),
              child: const Text('Cancel'),
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color.fromARGB(255, 138, 128, 168),
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              onPressed: () => Navigator.of(context).pop(true),
              child: const Text('Delete'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
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

          // ================= LIST OF DELETED NOTES =================
          Expanded(
            child: BlocBuilder<NotesCubit, NotesState>(
              builder: (context, state) {
                if (state is NotesSuccess) {
                  final deletedNotes = state.notes;

                  if (deletedNotes.isEmpty) {
                    return Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.delete_outline_rounded,
                            size: 80,
                            color: isDark
                                ? Colors.white38
                                : const Color(0xffA095C1),
                          ),
                          const SizedBox(height: 16),
                          Text(
                            'The trash is empty',
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: isDark ? Colors.white70 : Colors.grey,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            'No notes or folders',
                            style: TextStyle(
                              fontSize: 14,
                              color: isDark ? Colors.white38 : Colors.grey,
                            ),
                          ),
                        ],
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

                      return Dismissible(
                        key: Key(note.key.toString()),
                        // سحب لليمين -> استرجاع
                        background: Container(
                          margin: const EdgeInsets.only(bottom: 12),
                          decoration: BoxDecoration(
                            color: Colors.green.shade400,
                            borderRadius: BorderRadius.circular(16),
                          ),
                          alignment: Alignment.centerLeft,
                          padding: const EdgeInsets.symmetric(horizontal: 20),
                          child: const Row(
                            children: [
                              Icon(Icons.restore, color: Colors.white),
                              SizedBox(width: 8),
                              Text(
                                'Restore',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                        ),
                        // سحب لليسار -> حذف نهائي
                        secondaryBackground: Container(
                          margin: const EdgeInsets.only(bottom: 12),
                          decoration: BoxDecoration(
                            color: Colors.red.shade400,
                            borderRadius: BorderRadius.circular(16),
                          ),
                          alignment: Alignment.centerRight,
                          padding: const EdgeInsets.symmetric(horizontal: 20),
                          child: const Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              Text(
                                'Delete forever',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              SizedBox(width: 8),
                              Icon(Icons.delete_forever, color: Colors.white),
                            ],
                          ),
                        ),
                        confirmDismiss: (direction) async {
                          if (direction == DismissDirection.endToStart) {
                            return await _showDeleteConfirmationDialog(context);
                          } else {
                            return true;
                          }
                        },
                        onDismissed: (direction) {
                          if (direction == DismissDirection.endToStart) {
                            BlocProvider.of<NotesCubit>(
                              context,
                            ).Deletpermenant(note);
                          } else {
                            BlocProvider.of<NotesCubit>(
                              context,
                            ).Restoring(note);
                          }
                        },
                        child: Card(
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
                                  icon: const Icon(
                                    Icons.restore,
                                    color: Colors.green,
                                  ),
                                  onPressed: () {
                                    BlocProvider.of<NotesCubit>(
                                      context,
                                    ).Restoring(note);
                                  },
                                ),
                                IconButton(
                                  icon: const Icon(
                                    Icons.delete_forever,
                                    color: Colors.red,
                                  ),
                                  onPressed: () async {
                                    final shouldDelete =
                                        await _showDeleteConfirmationDialog(
                                          context,
                                        );
                                    if (shouldDelete == true) {
                                      if (context.mounted) {
                                        BlocProvider.of<NotesCubit>(
                                          context,
                                        ).Deletpermenant(note);
                                      }
                                    }
                                  },
                                ),
                              ],
                            ),
                          ),
                        ),
                      );
                    },
                  );
                } else if (state is NotesFailure) {
                  return Center(
                    child: Text(
                      state.errorMessage,
                      style: TextStyle(color: text),
                    ),
                  );
                } else {
                  return const Center(child: CircularProgressIndicator());
                }
              },
            ),
          ),
        ],
      ),
    );
  }
}
