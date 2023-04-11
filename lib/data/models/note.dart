import 'package:isar/isar.dart';

part 'note.g.dart';

@collection
class Note {
  Id id = Isar.autoIncrement;
  String? noteContent;
  bool isSynced;

  Note({
    this.noteContent,
    this.isSynced = true,
  });

  factory Note.fromJson(json) {
    return Note(
      noteContent: json['noteContent'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "id": id,
      'noteContent': noteContent,
    };
  }
}
