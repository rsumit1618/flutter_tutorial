import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:flutter_tutorial/main.dart' as app;

void main() {
      IntegrationTestWidgetsFlutterBinding.ensureInitialized();

      group('End-to-End App Tests', () {
            testWidgets('Full app flow - counter and user profile', (WidgetTester tester) async {
                  // Start app
                  app.main();
                  await tester.pumpAndSettle();

                  // ===== Test 1: Counter Screen =====
                  expect(find.text('Counter Demo'), findsOneWidget);

                  // Get initial counter value
                  final initialCounter = tester.widget<Text>(
                        find.byKey(const Key('counterValue')),
                  );
                  final initialValue = int.parse(initialCounter.data!);

                  // Increment counter
                  await tester.tap(find.byKey(const Key('incrementButton')));
                  await tester.pumpAndSettle();

                  // Verify increment
                  final afterIncrement = tester.widget<Text>(
                        find.byKey(const Key('counterValue')),
                  );
                  expect(int.parse(afterIncrement.data!), equals(initialValue + 1));

                  // Decrement counter
                  await tester.tap(find.byKey(const Key('decrementButton')));
                  await tester.pumpAndSettle();

                  // Verify decrement
                  final afterDecrement = tester.widget<Text>(
                        find.byKey(const Key('counterValue')),
                  );
                  expect(int.parse(afterDecrement.data!), equals(initialValue));

                  // Reset counter
                  await tester.tap(find.byKey(const Key('resetButton')));
                  await tester.pumpAndSettle();

                  // Verify reset
                  final afterReset = tester.widget<Text>(
                        find.byKey(const Key('counterValue')),
                  );
                  expect(int.parse(afterReset.data!), equals(0));

                  // ===== Test 2: Navigate to User Profile =====
                  await tester.tap(find.byIcon(Icons.person));
                  await tester.pumpAndSettle();

                  expect(find.text('User Profile'), findsOneWidget);
                  expect(find.text('❌ Logged Out'), findsOneWidget);

                  // Login with valid credentials
                  await tester.enterText(find.byKey(const Key('nameField')), 'Integration Test');
                  await tester.enterText(find.byKey(const Key('ageField')), '28');
                  await tester.tap(find.byKey(const Key('loginButton')));
                  await tester.pumpAndSettle();

                  // Verify login success
                  expect(find.text('Name: Integration Test'), findsOneWidget);
                  expect(find.text('Age: 28'), findsOneWidget);
                  expect(find.text('✅ Logged In'), findsOneWidget);

                  // Update age
                  await tester.tap(find.byKey(const Key('increaseAge')));
                  await tester.pumpAndSettle();
                  expect(find.text('Age: 29'), findsOneWidget);

                  // Logout
                  await tester.tap(find.byKey(const Key('logoutButton')));
                  await tester.pumpAndSettle();
                  expect(find.text('❌ Logged Out'), findsOneWidget);

                  // ===== Test 3: Navigate back to Counter =====
                  await tester.tap(find.byIcon(Icons.exposure_plus_1));
                  await tester.pumpAndSettle();

                  expect(find.text('Counter Demo'), findsOneWidget);
                  final counterValue = tester.widget<Text>(
                        find.byKey(const Key('counterValue')),
                  );
                  expect(int.parse(counterValue.data!), equals(0));
            });

            testWidgets('Counter persists between navigation', (WidgetTester tester) async {
                  // Start app
                  app.main();
                  await tester.pumpAndSettle();

                  // Set counter to specific value
                  await tester.tap(find.byKey(const Key('incrementButton')));
                  await tester.pumpAndSettle();
                  await tester.tap(find.byKey(const Key('incrementButton')));
                  await tester.pumpAndSettle();

                  // Verify counter value
                  final counterValue1 = tester.widget<Text>(
                        find.byKey(const Key('counterValue')),
                  );
                  expect(int.parse(counterValue1.data!), equals(2));

                  // Navigate to profile
                  await tester.tap(find.byIcon(Icons.person));
                  await tester.pumpAndSettle();

                  // Navigate back to counter
                  await tester.tap(find.byIcon(Icons.exposure_plus_1));
                  await tester.pumpAndSettle();

                  // Verify counter still has same value
                  final counterValue2 = tester.widget<Text>(
                        find.byKey(const Key('counterValue')),
                  );
                  expect(int.parse(counterValue2.data!), equals(2));
            });
      });
}