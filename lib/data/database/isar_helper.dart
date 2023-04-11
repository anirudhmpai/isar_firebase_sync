import 'package:isar/isar.dart';
import 'package:isar_firebase_sync/data/models/note.dart';

class IsarHelper {
  IsarHelper._privateConstructor();
  static final IsarHelper _instance = IsarHelper._privateConstructor();
  static IsarHelper get instance => _instance;

  late Isar isarInstance;

  init() async {
    isarInstance = await Isar.open([NoteSchema]);
  }

  insertNotesItem(Note noteItem) async {
    late int id;
    await isarInstance.writeTxn(() async {
      id = await isarInstance.notes.put(noteItem);
    });
    return id;
  }

  insertLatestNotesItems(List<Note> notesList) async {
    await isarInstance.writeTxn(() async {
      await isarInstance.clear();
      for (Note element in notesList) {
        await isarInstance.notes.put(element);
      }
    });
  }

  getNotesItems() async {
    return await isarInstance.collection<Note>().where().findAll();
  }

  removeNoteItem(Note note) async {
    await isarInstance.writeTxn(() async {
      await isarInstance.notes.delete(note.id);
    });
  }

  updateSync(Note note) async {
    note.isSynced = true;
    await isarInstance.writeTxn(() async {
      await isarInstance.notes.put(note);
    });
  }

  getUnSyncedData() async {
    return await isarInstance
        .collection<Note>()
        .filter()
        .isSyncedEqualTo(false)
        .findAll();
  }
}
