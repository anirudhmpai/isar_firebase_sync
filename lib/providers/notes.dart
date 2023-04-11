import 'package:isar/isar.dart';
import 'package:isar_firebase_sync/core/base_controller.dart';
import 'package:isar_firebase_sync/data/api/firebase_helper.dart';
import 'package:isar_firebase_sync/data/database/isar_helper.dart';
import 'package:isar_firebase_sync/data/models/note.dart';

import 'connectivity.dart';

class NotesProvider extends BaseController {
  late Isar database;

  List<Note> _notesList = [];
  List<Note> get notesList => _notesList;
  List<Note> deletedNotes = [];
  bool isSynced = true;

  final FirebaseHelper _firebaseHelper = FirebaseHelper();
  final IsarHelper _isarHelper = IsarHelper.instance;

  addNotes(Note notes) async {
    notes.isSynced = isDeviceConnected.value;
    int id = await _isarHelper.insertNotesItem(notes);
    notes.id = id;
    _notesList.add(notes);
    if (isDeviceConnected.value) {
      _firebaseHelper.addNote(notes.toJson());
    }
    notifyListeners();
  }

  getNotesList({bool? showLoading}) async {
    isLoading ? startLoading() : null;
    _notesList = [];

    await Future.delayed(const Duration(seconds: 1)).then((value) async {
      if (isDeviceConnected.value) {
        _notesList = await _firebaseHelper.getAllNotes();
        await _isarHelper.insertLatestNotesItems(_notesList);
      } else {
        _notesList = await _isarHelper.getNotesItems();
      }
    });

    stopLoading();
    notifyListeners();
  }

  syncNotes() async {
    List<Note> unSyncedNotes = await _isarHelper.getUnSyncedData();
    if (deletedNotes.isNotEmpty) {
      for (Note element in deletedNotes) {
        _firebaseHelper.removeNote(element);
      }
      deletedNotes.clear();
    }
    if (unSyncedNotes.isNotEmpty) {
      for (Note element in unSyncedNotes) {
        element.isSynced = true;
        await _firebaseHelper.updateNote(element);
        await _isarHelper.updateSync(element);
      }
    }
    getNotesList(showLoading: false);
  }

  updateMedicine(int index) async {
    _notesList[index].noteContent = '${_notesList[index].noteContent!}123#';
    _notesList[index].isSynced = isDeviceConnected.value;
    int id = _isarHelper.insertNotesItem(_notesList[index]);
    _notesList[index].id = id;
    if (isDeviceConnected.value) {
      _firebaseHelper.updateNote(_notesList[index]);
    }
    notifyListeners();
  }

  deleteNote(Note note) async {
    note.isSynced = false;
    _isarHelper.removeNoteItem(note);
    _notesList.removeWhere((element) => element.id == note.id);
    if (isDeviceConnected.value) {
      _firebaseHelper.removeNote(note);
    } else {
      deletedNotes.add(note);
    }
    notifyListeners();
  }
}
