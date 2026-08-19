import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hive_flutter/hive_flutter.dart';
<<<<<<< HEAD
import 'cubits/notes_cubit/notes_cubit.dart';
import 'models/note_model.dart';
=======
import 'package:notes_app/views/add_note_page.dart';
import 'models/note_model.dart';
import 'cubits/notes_cubit/notes_cubit.dart';
>>>>>>> 6d721a4 (Resolved merge cinflicts)
import 'views/first_page.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Hive.initFlutter();
  Hive.registerAdapter(NoteModelAdapter());
  await Hive.openBox<NoteModel>('notes_box');

  runApp(const NotesApp());
}

class NotesApp extends StatelessWidget {
  const NotesApp({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => NotesCubit(),
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          pageTransitionsTheme: const PageTransitionsTheme(
            builders: {
              TargetPlatform.windows: ZoomPageTransitionsBuilder(),
              TargetPlatform.android: ZoomPageTransitionsBuilder(),
            },
          ),
        ),
        home: const FirstPage(),
      ),
    );
  }
}