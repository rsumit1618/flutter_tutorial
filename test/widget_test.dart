import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';
import 'package:flutter_tutorial/main.dart';
import 'package:flutter_tutorial/features/database/services/sqlite/sqlite_service.dart';

void main() {
  setUp(() async {
    sqfliteFfiInit();
    databaseFactory = databaseFactoryFfi;
    
    // Initialize a mock database for SqliteService to avoid hangs in test environment
    final db = await databaseFactory.openDatabase(inMemoryDatabasePath);
    // Create the table so the service doesn't fail
    await db.execute('''
      CREATE TABLE IF NOT EXISTS users(
        id TEXT PRIMARY KEY,
        name TEXT NOT NULL,
        email TEXT UNIQUE NOT NULL,
        age INTEGER NOT NULL,
        created_at TEXT NOT NULL
      )
    ''');
    SqliteService.setTestDatabase(db);

    SharedPreferences.setMockInitialValues({});
  });

  testWidgets('App starts with Counter screen', (WidgetTester tester) async {
    // Build our app
    await tester.pumpWidget(const ProviderScope(child: MyApp()));

    // Wait for any async operations
    await tester.pumpAndSettle();

    // Use find.byType or specific keys instead of text
    expect(find.byIcon(Icons.exposure_plus_1), findsOneWidget);
    expect(find.byIcon(Icons.person), findsOneWidget);
    expect(find.byIcon(Icons.storage), findsOneWidget);
    expect(find.byIcon(Icons.data_object), findsOneWidget);
    expect(find.byIcon(Icons.compare_arrows), findsOneWidget);
  });

  testWidgets('Counter screen has buttons', (WidgetTester tester) async {
    await tester.pumpWidget(const ProviderScope(child: MyApp()));
    await tester.pumpAndSettle();

    // Check for counter buttons by key
    expect(find.byKey(const Key('incrementButton')), findsOneWidget);
    expect(find.byKey(const Key('decrementButton')), findsOneWidget);
    expect(find.byKey(const Key('resetButton')), findsOneWidget);
  });

  testWidgets('Counter increments when + button is tapped', (WidgetTester tester) async {
    await tester.pumpWidget(const ProviderScope(child: MyApp()));
    await tester.pumpAndSettle();

    // Find counter value
    expect(find.byKey(const Key('counterValue')), findsOneWidget);
    expect(find.text('0'), findsOneWidget);

    // Tap increment button
    await tester.tap(find.byKey(const Key('incrementButton')));
    await tester.pumpAndSettle();

    // Verify counter incremented
    expect(find.text('0'), findsNothing);
    expect(find.text('1'), findsOneWidget);
  });

  testWidgets('Navigation to profile works', (WidgetTester tester) async {
    await tester.pumpWidget(const ProviderScope(child: MyApp()));
    await tester.pumpAndSettle();

    // Verify profile tab exists
    final profileTab = find.byIcon(Icons.person);
    expect(profileTab, findsOneWidget);

    // Tap on Profile tab
    await tester.tap(profileTab);
    await tester.pumpAndSettle();

    // Verify UserCard appears (unique to profile screen)
    expect(find.byKey(const Key('userCard')), findsOneWidget);
  });

  testWidgets('Navigation to Hive screen works', (WidgetTester tester) async {
    await tester.pumpWidget(const ProviderScope(child: MyApp()));
    await tester.pumpAndSettle();

    // Tap on Hive tab
    await tester.tap(find.byIcon(Icons.storage));
    await tester.pumpAndSettle();

    // Verify Hive screen appears
    expect(find.text('Total Hive Users: 0'), findsOneWidget);
  });

  testWidgets('Navigation to SQLite screen works', (WidgetTester tester) async {
    await tester.pumpWidget(const ProviderScope(child: MyApp()));
    await tester.pumpAndSettle();

    // Tap on SQLite tab
    await tester.tap(find.byIcon(Icons.data_object));
    
    // Use pump instead of pumpAndSettle because CircularProgressIndicator 
    // in SqliteScreen has an infinite animation that causes timeouts.
    await tester.pump();
    await tester.pump(const Duration(seconds: 1));

    // Verify SQLite screen title in AppBar (part of MainScreen, so it should be there)
    expect(find.text('SQLite (RDBMS)'), findsOneWidget);
  });
}
