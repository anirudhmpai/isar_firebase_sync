import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_remote_config/firebase_remote_config.dart';
import 'package:flutter/material.dart';
import 'package:isar_firebase_sync/data/models/note.dart';

class FirebaseHelper {
  static final firestore = FirebaseFirestore.instance;
  final remoteConfig = FirebaseRemoteConfig.instance;

  static final CollectionReference users =
      FirebaseFirestore.instance.collection('users');

  static final CollectionReference notes =
      FirebaseFirestore.instance.collection('notes');
  initRemoteConfig() async {
    await remoteConfig.setDefaults({
      "name": "notes",
    });
    await remoteConfig.setConfigSettings(RemoteConfigSettings(
      fetchTimeout: const Duration(minutes: 1),
      minimumFetchInterval: const Duration(hours: 1),
    ));
    await remoteConfig.fetchAndActivate();
  }

  Future getAllNotes() async {
    List data = [];
    List<Note> allNote = [];

    await notes.get().then((QuerySnapshot value) {
      for (var element in value.docs) {
        data.add(element.data());
      }
    });

    for (var document in data) {
      allNote.add(Note.fromJson(document));
    }

    return allNote;
  }

  addNote(Map data) async {
    await notes.add(data).then((value) {
      debugPrint(value.toString());
      // Get.showSnackbar(GetBar(
      //   title: "Note added",
      //   message: "successful",
      //   duration: const Duration(seconds: 1),
      // ));
    }).catchError((error) {
      debugPrint(error.toString());
      // Get.showSnackbar(GetBar(
      //   title: "Error adding note",
      //   message: error.toString(),
      //   duration: const Duration(seconds: 1),
      // ));
    });
  }

  addNoteToList(String name) {
    notes.doc("note").get().then(
      (value) {
        List data = value['note_list'] ?? [];
        data.add(name);
        notes.doc("note").set({'note_list': data}).then(
          (value) {
            // Get.showSnackbar(
            //   GetBar(
            //     title: "Note list updated",
            //     message: "successful",
            //     duration: const Duration(seconds: 1),
            //   ),
            // );
          },
        );
      },
    );
  }

  removeNote(Note noteItem) async {
    await notes.where("id", isEqualTo: noteItem.id).get().then((value) async {
      DocumentSnapshot doc = value.docs.first;
      await notes.doc(doc.id).delete();
    });
  }

  updateNote(Note note) async {
    await notes.where("id", isEqualTo: note.id).get().then((value) async {
      if (value.docs.isEmpty) {
        addNote(note.toJson());
      } else {
        DocumentSnapshot doc = value.docs.first;
        await notes.doc(doc.id).update(note.toJson());
      }
    });
  }
}
