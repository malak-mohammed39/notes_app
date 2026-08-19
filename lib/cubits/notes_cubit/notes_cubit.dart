import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hive/hive.dart';
import '../../models/note_model.dart';
import 'notes_state.dart';

class NotesCubit extends Cubit<NotesState> {
  NotesCubit() : super(NotesInitial());

  static const String boxName = 'notes_box';

  List<NoteModel>? allNotes;

  void fetchAllNotes() {
    try {
      var box = Hive.box<NoteModel>(boxName);

      allNotes = box.values.where((note) => !note.isDeleted).toList();

      emit(NotesSuccess(allNotes!));
    } catch (e) {
      emit(NotesFailure(e.toString()));
    }
  }

  void fetchFavNotes() {
    try {
      var box = Hive.box<NoteModel>(boxName);

      final FavNotes = box.values
          .where((note) => !note.isDeleted && note.isFav)
          .toList();

      emit(NotesSuccess(FavNotes));
    } catch (e) {
      emit(NotesFailure(e.toString()));
    }
  }

  void fetchDeletedones() {
    try {
      var box = Hive.box<NoteModel>(boxName);

      final DeletedNotes = box.values.where((note) => note.isDeleted).toList();

      emit(NotesSuccess(DeletedNotes));
    } catch (e) {
      emit(NotesFailure(e.toString()));
    }
  }

  void AddNote(NoteModel note) async {
    try {
      var box = Hive.box<NoteModel>(boxName);

      await box.add(note);

      fetchAllNotes();
    } catch (e) {
      emit(NotesFailure(e.toString()));
    }
  }

  void MoveToTrach(NoteModel note) async {
    note.isDeleted = true;

    await note.save();

    fetchDeletedones();
  }

  void Restoring(NoteModel note) async {
    note.isDeleted = false;

    await note.save();

    fetchDeletedones();
  }

  void Deletpermenant(NoteModel note) async {
    await note.delete();
    fetchDeletedones();
  }

  void addFav(NoteModel note) async {
    note.isFav = !note.isFav;

    await note.save();

    fetchAllNotes();
  }

  void Searching(String q) {
    if (allNotes == null) return;

    if (q.isEmpty) {
      emit(NotesSuccess(allNotes!));
    } else {
      final filterList = allNotes!.where((note) {
        return note.title.toLowerCase().contains(q.toLowerCase()) ||
            note.content.toLowerCase().contains(q.toLowerCase());
      }).toList();
      emit(NotesSuccess(filterList));
    }
  }
}
