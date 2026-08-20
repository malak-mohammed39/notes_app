import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:notes_app/cubits/notes_cubit/notes_cubit.dart';
import 'package:notes_app/cubits/notes_cubit/notes_state.dart';
import 'package:notes_app/models/note_model.dart';
import 'package:notes_app/views/add_note_page.dart';
import 'package:notes_app/views/all_notes_view.dart';
import 'package:notes_app/views/first_page.dart';
import 'package:notes_app/views/trash_page.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  static const Color backgroundColor = Color(0xFFE8E2E8);
  static const Color cardColor = Color(0xFFC5B8C9);
  static const Color purple = Color(0xFF8B5FA8);
  static const Color darkPurple = Color(0xFF68447D);
  static const Color lightPurple = Color(0xFFD8CEDA);
  static const Color textColor = Color(0xFF29222B);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  void initState() {
    super.initState();
    context.read<NotesCubit>().fetchAllNotes();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: HomePage.backgroundColor,
      appBar: AppBar(
        backgroundColor: HomePage.backgroundColor,
        elevation: 0,
        centerTitle: true,
        title: const Text(
          'ALL NOTES',
          style: TextStyle(
            color: HomePage.textColor,
            fontSize: 27,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            // Search Bar
            Container(
              height: 50,
              width: double.infinity,
              decoration: BoxDecoration(
                color: HomePage.darkPurple,
                borderRadius: BorderRadius.circular(12),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.12),
                    blurRadius: 6,
                    offset: const Offset(0, 3),
                  ),
                ],
              ),
              child: TextField(
                onChanged: (value) {
                  context.read<NotesCubit>().Searching(value);
                },
                style: const TextStyle(color: Colors.white, fontSize: 16),
                decoration: const InputDecoration(
                  hintText: 'Search notes...',
                  hintStyle: TextStyle(color: Colors.white70, fontSize: 16),
                  prefixIcon: Icon(Icons.search, color: Colors.white),
                  border: InputBorder.none,
                  contentPadding: EdgeInsets.symmetric(vertical: 14),
                ),
              ),
            ),

            const SizedBox(height: 16),

            Expanded(
              child: BlocBuilder<NotesCubit, NotesState>(
                builder: (context, state) {
                  if (state is NotesSuccess) {
                    final notes = state.notes;

                    if (notes.isEmpty) {
                      return const Center(
                        child: Text(
                          'No notes yet! Click + to add one.',
                          style: TextStyle(color: Colors.grey, fontSize: 16),
                        ),
                      );
                    }

                    int displayCount = notes.length > 3 ? 3 : notes.length;

                    return ListView.builder(
                      itemCount: displayCount + (notes.length > 3 ? 1 : 0),
                      itemBuilder: (context, index) {
                        if (index == 3) {
                          return Padding(
                            padding: const EdgeInsets.symmetric(vertical: 8),
                            child: InkWell(
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => AllNotesView(),
                                  ),
                                );
                              },
                              child: const Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text(
                                    'Show All Notes',
                                    style: TextStyle(
                                      color: HomePage.darkPurple,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 16,
                                    ),
                                  ),
                                  SizedBox(width: 4),
                                  Icon(
                                    Icons.arrow_forward_ios,
                                    size: 14,
                                    color: HomePage.darkPurple,
                                  ),
                                ],
                              ),
                            ),
                          );
                        }

                        final note = notes[index];
                        return Container(
                          margin: const EdgeInsets.only(bottom: 12),
                          padding: const EdgeInsets.all(14),
                          decoration: BoxDecoration(
                            color: HomePage.cardColor,
                            borderRadius: BorderRadius.circular(12),
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
                                icon: Icon(
                                  Icons.delete_outline_rounded,
                                  color: HomePage.darkPurple,
                                  size: 24,
                                ),
                                onPressed: () {
                                  context.read<NotesCubit>().MoveToTrach(note);
                                },
                              ),
                            ],
                          ),
                        );
                      },
                    );
                  } else if (state is NotesFailure) {
                    return Center(child: Text(state.errorMessage));
                  }
                  return const Center(child: CircularProgressIndicator());
                },
              ),
            ),

            Material(
              color: Colors.transparent,
              borderRadius: BorderRadius.circular(12),
              child: InkWell(
                onTap: () async {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const TrashPage()),
                  );
                  if (context.mounted) {
                    context.read<NotesCubit>().fetchAllNotes();
                  }
                },

                borderRadius: BorderRadius.circular(12),
                child: Ink(
                  height: 50,
                  decoration: BoxDecoration(
                    color: HomePage.cardColor,
                    borderRadius: BorderRadius.circular(12),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.18),
                        blurRadius: 7,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  child: const Row(
                    children: [
                      SizedBox(width: 15),
                      Icon(Icons.delete, color: HomePage.darkPurple),
                      Expanded(
                        child: Center(
                          child: Text(
                            'SHOW DELETED NOTES',
                            style: TextStyle(
                              color: HomePage.textColor,
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                            ),
                          ),
                        ),
                      ),
                      SizedBox(width: 40),
                    ],
                  ),
                ),
              ),
            ),

            const SizedBox(height: 10),

            // زر Show Favourite Notes
            Material(
              color: Colors.transparent,
              borderRadius: BorderRadius.circular(12),
              child: InkWell(
                onTap: () {
                  context.read<NotesCubit>().fetchFavNotes();
                },
                borderRadius: BorderRadius.circular(12),
                child: Ink(
                  height: 50,
                  decoration: BoxDecoration(
                    color: HomePage.cardColor,
                    borderRadius: BorderRadius.circular(12),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.18),
                        blurRadius: 7,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  child: const Row(
                    children: [
                      SizedBox(width: 15),
                      Icon(Icons.favorite, color: HomePage.darkPurple),
                      Expanded(
                        child: Center(
                          child: Text(
                            'SHOW FAVOURITE NOTES',
                            style: TextStyle(
                              color: HomePage.textColor,
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                            ),
                          ),
                        ),
                      ),
                      SizedBox(width: 40),
                    ],
                  ),
                ),
              ),
            ),

            const SizedBox(height: 65),
          ],
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      floatingActionButton: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            InkWell(
              onTap: () {
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (context) => const FirstPage()),
                );
              },
              child: Container(
                height: 50,
                padding: const EdgeInsets.symmetric(horizontal: 16),
                decoration: BoxDecoration(
                  color: HomePage.darkPurple,
                  borderRadius: BorderRadius.circular(25),
                ),
                child: const Center(
                  child: Text(
                    "Back",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ),
            const Spacer(),
            FloatingActionButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const AddNotePage()),
                );
              },
              backgroundColor: HomePage.darkPurple,
              elevation: 8,
              child: const Icon(Icons.add, color: Colors.white, size: 30),
            ),
          ],
        ),
      ),
    );
  }
}
