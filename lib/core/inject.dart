import 'package:get_it/get_it.dart';

final serviceLocator = GetIt.instance;

class Inject {
  static init() {
    registerComponents();
  }

  static Future<void> registerComponents() async {}
}
