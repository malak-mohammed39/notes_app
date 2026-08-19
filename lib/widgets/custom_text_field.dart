import 'package:flutter/material.dart' show BorderRadius, BorderSide, BuildContext, Colors, EdgeInsets, InputDecoration, OutlineInputBorder, StatelessWidget, TextEditingController, TextFormField, Widget;
class CustomTextField extends StatelessWidget {
  final String hintText;
  final String labelText;
  final TextEditingController controller;
  final int maxLines;
    final TextEditingController titleController;
    final String Function(String?) ? validator;

  const CustomTextField({super.key,
  required this.hintText,
  required this.labelText,
  required this.controller,
  required this.titleController,
  this.validator,
   this.maxLines=1,
  });

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      maxLines: maxLines,
      decoration: InputDecoration(
        hintText: hintText,
        labelText: labelText,
        filled: true,
        fillColor: Colors.grey.shade100,
        border:OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: BorderSide.none,
        ),
        enabledBorder: OutlineInputBorder(   
            borderRadius: BorderRadius.circular(16),
          borderSide: BorderSide.none,),
          focusedBorder: OutlineInputBorder(
     borderRadius: BorderRadius.circular(16),
          borderSide: const BorderSide(color: Colors.deepPurple,
          width: 2,
          ),
          ),
          contentPadding: EdgeInsets.symmetric(horizontal: 18,vertical: 16
          ),
      ),
    );
  }
}