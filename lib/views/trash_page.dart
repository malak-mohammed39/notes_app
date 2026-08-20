import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../cubits/notes_cubit/notes_cubit.dart';
import '../cubits/notes_cubit/notes_state.dart';

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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xffF8F5FC),
      appBar: AppBar(
        backgroundColor: const Color(0xffF8F5FC),
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          'Deleted Notes',
          style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
      ),
      body: BlocBuilder<NotesCubit, NotesState>(
        builder: (context, state) {
          if (state is NotesSuccess) {
            final deletedNotes = state.notes;

            if (deletedNotes.isEmpty) {
              return const Center(
                child: Text('No deleted notes'),
              );
            }

            return ListView.builder(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              itemCount: deletedNotes.length,
              itemBuilder: (context, index) {
                final note = deletedNotes[index];

                return Card(
                  color: const Color(0xffE2DCF2),
                  elevation: 1,
                  margin: const EdgeInsets.only(bottom: 12),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: ListTile(
                    title: Text(
                      note.title,
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),
                    subtitle: Text(
                      note.content,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        // زر الاسترجاع
                        IconButton(
                          icon: const Icon(Icons.restore, color:  Color(0xff5C4B7D)),
                          onPressed: () {
                            BlocProvider.of<NotesCubit>(context).Restoring(note);
                          },
                        ),
                        // زر الحذف النهائي
                        IconButton(
                          icon: const Icon(Icons.delete_forever, color:  Color(0xff5C4B7D)),
                          onPressed: () {
                            BlocProvider.of<NotesCubit>(context).Deletpermenant(note);
                          },
                        ),
                      ],
                    ),
                  ),
                );
              },
            );
          } else if (state is NotesFailure) {
            return Center(child: Text(state.errorMessage));
          } else {
            return const Center(child: CircularProgressIndicator());
          }
        },
      ),
    );
  }
}