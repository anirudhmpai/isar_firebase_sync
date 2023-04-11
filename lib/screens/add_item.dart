import 'package:flutter/material.dart';
import 'package:isar_firebase_sync/data/models/note.dart';
import 'package:isar_firebase_sync/providers/notes.dart';
import 'package:isar_firebase_sync/routes/navigation.dart';
import 'package:provider/provider.dart';

class AddItem extends StatelessWidget {
  const AddItem({super.key});

  @override
  Widget build(BuildContext context) {
    var noteTextController = TextEditingController();
    var notesProvider = Provider.of<NotesProvider>(context, listen: false);
    return SafeArea(
        child: Scaffold(
      appBar: AppBar(),
      body: Form(
        child: Column(
          children: [
            TextFormField(
              controller: noteTextController,
              keyboardType: TextInputType.multiline,
              maxLines: 5,
              decoration: const InputDecoration(
                hintText: 'Enter a note',
              ),
            ),
            const SizedBox(height: 15),
            ElevatedButton(
              onPressed: () {
                notesProvider
                    .addNotes(Note(noteContent: noteTextController.text));
                toPop(context);
                // if (widget.thoughtId != -1) {
                //   thoughtProvider
                //       .updateThought(
                //         widget.thoughtId,
                //         thought: thoughtController.text,
                //       )
                //       .then((value) => Navigator.of(context).pop());
                // } else {
                //   thoughtProvider
                //       .createThought(
                //         thought: thoughtController.text,
                //       )
                //       .then((value) => Navigator.of(context).pop());
                // }
              },
              child: const Text('Add Note'),
            )
          ],
        ),
      ),
    ));
  }
}
