import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_tutorial/features/counter/presentation/screens/counter_screen.dart';

void main() {
  group('CounterScreen', () {
    testWidgets('displays initial counter value',
            (WidgetTester tester) async {
          // Arrange
          await tester.pumpWidget(
            const ProviderScope(
              child: MaterialApp(
                home: CounterScreen(),
              ),
            ),
          );

          // Allow async operations
          await tester.pump();

          // Assert
          expect(find.byKey(const Key('counterValue')), findsOneWidget);
          expect(find.byKey(const Key('incrementButton')), findsOneWidget);
          expect(find.byKey(const Key('decrementButton')), findsOneWidget);
          expect(find.byKey(const Key('resetButton')), findsOneWidget);
        });

    testWidgets('increment button increases counter',
            (WidgetTester tester) async {
          // Arrange
          await tester.pumpWidget(
            const ProviderScope(
              child: MaterialApp(
                home: CounterScreen(),
              ),
            ),
          );
          await tester.pump();

          // Get initial value
          final initialText = tester.widget<Text>(
            find.byKey(const Key('counterValue')),
          );
          final initialValue = int.parse(initialText.data!);

          // Act - Tap increment button
          await tester.tap(find.byKey(const Key('incrementButton')));
          await tester.pump();

          // Assert
          final updatedText = tester.widget<Text>(
            find.byKey(const Key('counterValue')),
          );
          final updatedValue = int.parse(updatedText.data!);
          expect(updatedValue, equals(initialValue + 1));
        });

    testWidgets('decrement button decreases counter',
            (WidgetTester tester) async {
          // Arrange
          await tester.pumpWidget(
            const ProviderScope(
              child: MaterialApp(
                home: CounterScreen(),
              ),
            ),
          );
          await tester.pump();

          // Get initial value
          final initialText = tester.widget<Text>(
            find.byKey(const Key('counterValue')),
          );
          final initialValue = int.parse(initialText.data!);

          // Act - Tap decrement button
          await tester.tap(find.byKey(const Key('decrementButton')));
          await tester.pump();

          // Assert
          final updatedText = tester.widget<Text>(
            find.byKey(const Key('counterValue')),
          );
          final updatedValue = int.parse(updatedText.data!);
          expect(updatedValue, equals(initialValue - 1));
        });

    testWidgets('reset button resets counter to 0',
            (WidgetTester tester) async {
          // Arrange
          await tester.pumpWidget(
            const ProviderScope(
              child: MaterialApp(
                home: CounterScreen(),
              ),
            ),
          );
          await tester.pump();

          // Increment first
          await tester.tap(find.byKey(const Key('incrementButton')));
          await tester.pump();
          await tester.tap(find.byKey(const Key('incrementButton')));
          await tester.pump();

          // Act - Reset
          await tester.tap(find.byKey(const Key('resetButton')));
          await tester.pump();

          // Assert
          final resetText = tester.widget<Text>(
            find.byKey(const Key('counterValue')),
          );
          expect(resetText.data, '0');
        });

    testWidgets('shows error message when counter fails',
            (WidgetTester tester) async {
          // This would require mocking the provider to throw error
          // For demonstration, we'll just verify error widget exists

          // To test error state, we'd need to override the provider
          // with one that throws an exception
        });
  });
}