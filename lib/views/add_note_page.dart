import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:notes_app/cubits/notes_cubit/theme_cubit.dart';
import 'package:notes_app/views/home_page.dart';

import '../cubits/notes_cubit/notes_cubit.dart';
import '../models/note_model.dart';

class AddNotePage extends StatefulWidget {
  const AddNotePage({super.key});

  @override
  State<AddNotePage> createState() => _AddNotePageState();
}

class _AddNotePageState extends State<AddNotePage> {
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();

  final TextEditingController titleController = TextEditingController();
  final TextEditingController contentController = TextEditingController();

  final List<Color> colors = const [
    Color(0xFFC5B8C9),
    Color(0xFFFFAB91),
    Color(0xFFFFCC80),
    Color(0xFFE6EE9C),
    Color(0xFF80CBC4),
    Color(0xFF90CAF9),
    Color(0xFFF48FB1),
    Color(0xFFD7CCC8),
  ];

  late Color selectedColor;

  @override
  void initState() {
    super.initState();
    selectedColor = colors[0];
  }

  @override
  void dispose() {
    titleController.dispose();
    contentController.dispose();
    super.dispose();
  }

  void saveNote() {
    if (!formKey.currentState!.validate()) {
      return;
    }

    final note = NoteModel(
      title: titleController.text.trim(),
      content: contentController.text.trim(),
      date: DateTime.now().toString(),
      color: selectedColor.value,
      isFav: false,
      isDeleted: false,
    );

    context.read<NotesCubit>().AddNote(note);
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    final isDark = context.watch<ThemeCubit>().state;

    final background = isDark
        ? const Color(0xFF211D23)
        : HomePage.backgroundColor;
    final text = isDark ? Colors.white : HomePage.textColor;
    final secondaryText = Colors.black87;
    final buttonColor = isDark ? const Color(0xFF4B3158) : HomePage.darkPurple;

    return Scaffold(
      backgroundColor: background,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20.0),
          child: Form(
            key: formKey,
            child: Column(
              children: [
                const SizedBox(height: 12),

                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    _buildIconButton(
                      icon: Icons.arrow_back_ios_new_rounded,
                      color: buttonColor,
                      onTap: () {
                        Navigator.pop(context);
                      },
                    ),
                    Text(
                      'Add Note',
                      style: TextStyle(
                        fontSize: 25,
                        fontWeight: FontWeight.bold,
                        color: text,
                      ),
                    ),
                    _buildIconButton(
                      icon: Icons.delete_outline,
                      color: buttonColor,
                      onTap: () {
                        titleController.clear();
                        contentController.clear();
                      },
                    ),
                  ],
                ),

                const SizedBox(height: 16),

                // حقل العنوان مزاح إلى اليمين
                Container(
                  decoration: BoxDecoration(
                    color: selectedColor,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: TextFormField(
                    controller: titleController,
                    textAlign: TextAlign.right,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Colors.black87,
                    ),
                    decoration: const InputDecoration(
                      hintText: 'Enter Title Here',
                      hintStyle: TextStyle(
                        color: Colors.black54,
                        fontWeight: FontWeight.bold,
                      ),
                      border: InputBorder.none,
                      contentPadding: EdgeInsets.symmetric(
                        vertical: 14,
                        horizontal: 16,
                      ),
                      errorStyle: TextStyle(
                        color: Color(0xFF8B0000),
                        fontWeight: FontWeight.bold,
                        fontSize: 13,
                      ),
                    ),
                    validator: (value) {
                      if (value == null || value.trim().isEmpty) {
                        return 'Please enter a title';
                      }
                      return null;
                    },
                  ),
                ),

                const SizedBox(height: 16),

                Expanded(
                  child: Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: selectedColor,
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: TextFormField(
                      controller: contentController,
                      maxLines: null,
                      expands: true,
                      textAlignVertical: TextAlignVertical.top,
                      style: TextStyle(color: secondaryText, fontSize: 16),
                      decoration: const InputDecoration(
                        hintText: 'Start writing your note here!',
                        hintStyle: TextStyle(color: Colors.black45),
                        border: InputBorder.none,
                        errorStyle: TextStyle(
                          color: Color(0xFF8B0000),
                          fontWeight: FontWeight.bold,
                          fontSize: 13,
                        ),
                      ),
                      validator: (value) {
                        if (value == null || value.trim().isEmpty) {
                          return 'Please enter some content';
                        }
                        return null;
                      },
                    ),
                  ),
                ),

                const SizedBox(height: 12),

                // شريط الألوان
                SizedBox(
                  height: 44,
                  child: ListView.builder(
                    scrollDirection: Axis.horizontal,
                    itemCount: colors.length,
                    itemBuilder: (context, index) {
                      final itemColor = colors[index];
                      final isSelected = selectedColor.value == itemColor.value;

                      return GestureDetector(
                        onTap: () {
                          setState(() {
                            selectedColor = itemColor;
                          });
                        },
                        child: Container(
                          margin: const EdgeInsets.symmetric(horizontal: 5),
                          width: 40,
                          decoration: BoxDecoration(
                            color: itemColor,
                            shape: BoxShape.circle,
                            border: Border.all(
                              color: isSelected
                                  ? (isDark ? Colors.white : Colors.black87)
                                  : Colors.transparent,
                              width: 2.5,
                            ),
                          ),
                          child: isSelected
                              ? const Icon(
                                  Icons.check,
                                  size: 20,
                                  color: Colors.black87,
                                )
                              : null,
                        ),
                      );
                    },
                  ),
                ),

                const SizedBox(height: 12),

                SizedBox(
                  width: double.infinity,
                  height: 48,
                  child: ElevatedButton(
                    onPressed: saveNote,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: buttonColor,
                      elevation: 4,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(24),
                      ),
                    ),
                    child: const Text(
                      'Save Note!',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),

                const SizedBox(height: 16),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildIconButton({
    required IconData icon,
    required Color color,
    required VoidCallback onTap,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(8),
      ),
      child: IconButton(
        icon: Icon(icon, color: Colors.white, size: 18),
        onPressed: onTap,
        constraints: const BoxConstraints(minWidth: 36, minHeight: 36),
        padding: EdgeInsets.zero,
      ),
    );
  }
}
