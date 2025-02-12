import 'package:flutter/material.dart';
import 'package:flutter_todolist_app/app.dart';
import 'package:flutter_todolist_app/init_config.dart';

// Status
// 1: saved/ongoing
// 2: completed/done
// 3: deleted
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await AppInitConfig().init();
  runApp(const MyApp());
}
