import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'features/database/services/hive/hive_service.dart';
import 'features/database/services/sqlite/sqlite_service.dart';
import 'features/home_page.dart';

void main() async {
  // ALWAYS initialize binding first(when firebase initialize, Sqlite, Hive, or Platform Channel)
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize Hive
  await HiveService().init();

  // Initialize SQLite
  await SqliteService().database;

  runApp(const ProviderScope(child: MyApp()));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Tutorial',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        useMaterial3: true,
      ),
      home: const MainScreen(),
      debugShowCheckedModeBanner: false,
    );
  }
}