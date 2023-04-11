import 'dart:async';

import 'package:firebase_remote_config/firebase_remote_config.dart';
import 'package:flutter/material.dart';
import 'package:isar_firebase_sync/data/api/firebase_helper.dart';
import 'package:provider/provider.dart';

import 'package:isar_firebase_sync/providers/connectivity.dart';
import 'package:isar_firebase_sync/providers/notes.dart';
import 'package:isar_firebase_sync/routes/navigation.dart';
import 'package:isar_firebase_sync/routes/paths.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  late NotesProvider controller;
  late FirebaseRemoteConfig remoteConfig;

  @override
  void initState() {
    super.initState();
    controller = Provider.of<NotesProvider>(context, listen: false);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      controller.getNotesList(showLoading: true);
    });
    remoteConfig = FirebaseHelper().remoteConfig;

    startDynamicSync(context);
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: CustomScrollView(
          slivers: [
            SliverAppBar(
              flexibleSpace: Center(
                  child: Text(
                remoteConfig.getString('name'),
                style: const TextStyle(
                  fontSize: 20,
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              )),
              centerTitle: true,
              expandedHeight: 80,
            ),
            SliverToBoxAdapter(
              child: Container(
                  padding: const EdgeInsets.all(15),
                  alignment: Alignment.center,
                  child: const Text('Create and view notes list')),
            ),
            const NotesListComponent()
          ],
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () => toPushNamed(context, Paths.addItem),
          child: const Icon(Icons.add),
        ),
      ),
    );
  }

  void startDynamicSync(BuildContext context) {
    Timer.periodic(const Duration(seconds: 30), (timer) {
      if (isDeviceConnected.value) {
        controller.syncNotes();
        // ScaffoldMessenger.of(context)
        //     .showSnackBar(const SnackBar(content: Text("Data synced!")));
      } else {
        controller.getNotesList();
      }
    });
  }
}

class NotesListComponent extends StatelessWidget {
  const NotesListComponent({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder(
      builder: (context, isConnected, child) {
        return Consumer<NotesProvider>(
            builder: (context, notesProvider, child) {
          return notesProvider.isLoading
              ? SliverFillRemaining(
                  child: Container(
                  alignment: Alignment.center,
                  padding: const EdgeInsets.all(15),
                  child: const LinearProgressIndicator(),
                ))
              : notesProvider.notesList.isEmpty
                  ? SliverFillRemaining(
                      child: Container(
                      alignment: Alignment.center,
                      padding: const EdgeInsets.all(15),
                      child: const Text('No items in notes'),
                    ))
                  : SliverList(
                      delegate: SliverChildBuilderDelegate(
                        (context, index) => ListTile(
                          onTap: () {},
                          onLongPress: () => notesProvider
                              .deleteNote(notesProvider.notesList[index]),
                          title: Text(
                            '${notesProvider.notesList[index].noteContent} ${isDeviceConnected.value}',
                          ),
                        ),
                        childCount: notesProvider.notesList.length,
                      ),
                    );
        });
      },
      valueListenable: isDeviceConnected,
    );
  }
}
