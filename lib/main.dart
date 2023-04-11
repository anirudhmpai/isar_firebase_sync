import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:provider/single_child_widget.dart';

import 'package:isar_firebase_sync/core/inject.dart';
import 'package:isar_firebase_sync/data/api/firebase_helper.dart';
import 'package:isar_firebase_sync/data/database/isar_helper.dart';
import 'package:isar_firebase_sync/providers/connectivity.dart';
import 'package:isar_firebase_sync/routes/app_routes.dart';

import 'firebase_options.dart';
import 'providers/notes.dart';
import 'screens/home.dart';

main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await initFunctions();
  runApp(MultiProvider(
    providers: providers(),
    child: const MyApp(),
  ));
}

Future<void> initFunctions() async {
  Inject.init();
  IsarHelper.instance.init();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  await FirebaseHelper().initRemoteConfig();
}

List<SingleChildWidget> providers() {
  return [
    ChangeNotifierProvider(create: (context) => ConnectivityProvider()),
    ChangeNotifierProvider(create: (context) => NotesProvider()),
  ];
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Isar Firebase Sync',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      onGenerateRoute: AppRoutes().onGeneratedRoute,
      home: StreamBuilder<ConnectivityResult>(
          stream: Provider.of<ConnectivityProvider>(context, listen: false)
              .connectivityStream,
          builder: (context, snapshot) {
            return const HomeScreen();
          }),
    );
  }
}
