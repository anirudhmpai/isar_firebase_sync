import 'package:flutter/material.dart';

Future<Object?> toPushNamed(BuildContext context, String path) =>
    Navigator.of(context).pushNamed(path);

Future<Object?> toPushReplaceNamed(BuildContext context, String path) =>
    Navigator.of(context).pushReplacementNamed(path);

void toPop(BuildContext context, {dynamic result}) =>
    Navigator.of(context).pop([result]);
