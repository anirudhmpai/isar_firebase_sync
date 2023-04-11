import 'package:flutter/material.dart';
import 'package:isar_firebase_sync/screens/add_item.dart';
import 'package:isar_firebase_sync/screens/home.dart';

import 'paths.dart';

class AppRoutes {
  Route<dynamic> onGeneratedRoute(RouteSettings routeSettings) {
    return MaterialPageRoute(
      builder: (context) {
        switch (routeSettings.name) {
          case Paths.initial:
            return const HomeScreen();
          case Paths.home:
            return const HomeScreen();
          case Paths.addItem:
            return const AddItem();
          default:
            return const HomeScreen();
        }
      },
    );
  }
}
