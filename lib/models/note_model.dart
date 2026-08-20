import 'package:hive/hive.dart'; //To Get The Package

part 'note_model.g.dart';

@HiveType(typeId: 0) //Type id is uniqe to each class
class NoteModel extends HiveObject {
  // index uniq to each elemnt
  @HiveField(0)
  String title;

  @HiveField(1)
  String content;

  @HiveField(2)
  final String date;

  @HiveField(3)
  bool isFav;

  @HiveField(4)
  bool isDeleted;

  @HiveField(5)
  int color;

  NoteModel({
    // req means has to be exist in each class
    required this.title,
    required this.content,
    required this.isFav,
    required this.date,
    required this.isDeleted,
    required this.color,
  });
}
