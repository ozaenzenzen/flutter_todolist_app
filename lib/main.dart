import 'package:flutter/material.dart';
import 'package:flutter_todolist_app/app.dart';
import 'package:flutter_todolist_app/init_config.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await AppInitConfig().init();
  runApp(const MyApp());
}
