import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_tutorial/features/counter/presentation/screens/counter_screen.dart';
import 'package:flutter_tutorial/features/counter/presentation/providers/counter_provider.dart';
import 'package:flutter_tutorial/features/counter/domain/usecases/get_counter_usecase.dart';
import 'package:flutter_tutorial/features/counter/domain/usecases/increment_counter_usecase.dart';
import 'package:flutter_tutorial/features/counter/domain/usecases/decrement_counter_usecase.dart';

void main() {
  setUp(() {
    SharedPreferences.setMockInitialValues({});
  });

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
          await tester.pumpAndSettle();

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
          await tester.pumpAndSettle();

          // Get initial value
          final initialText = tester.widget<Text>(
            find.byKey(const Key('counterValue')),
          );
          final initialValue = int.parse(initialText.data!);

          // Act - Tap increment button
          await tester.tap(find.byKey(const Key('incrementButton')));
          await tester.pumpAndSettle();

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
          await tester.pumpAndSettle();

          // Get initial value
          final initialText = tester.widget<Text>(
            find.byKey(const Key('counterValue')),
          );
          final initialValue = int.parse(initialText.data!);

          // Act - Tap decrement button
          await tester.tap(find.byKey(const Key('decrementButton')));
          await tester.pumpAndSettle();

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
          await tester.pumpAndSettle();

          // Increment first
          await tester.tap(find.byKey(const Key('incrementButton')));
          await tester.pumpAndSettle();
          await tester.tap(find.byKey(const Key('incrementButton')));
          await tester.pumpAndSettle();

          // Act - Reset
          await tester.tap(find.byKey(const Key('resetButton')));
          await tester.pumpAndSettle();

          // Assert
          final resetText = tester.widget<Text>(
            find.byKey(const Key('counterValue')),
          );
          expect(resetText.data, '0');
        });

    testWidgets('shows error message when counter fails',
            (WidgetTester tester) async {
          // Arrange
          await tester.pumpWidget(
            ProviderScope(
              overrides: [
                counterProvider.overrideWith((ref) => ErrorCounterNotifier()),
              ],
              child: const MaterialApp(
                home: CounterScreen(),
              ),
            ),
          );
          await tester.pumpAndSettle();

          // Assert
          expect(find.textContaining('Error: Failed to load'), findsOneWidget);
        });
  });
}

// Helper mock notifier for error testing
class ErrorCounterNotifier extends CounterNotifier {
  ErrorCounterNotifier() : super(
    getCounterUseCase: _FakeGetCounterUseCase(),
    incrementCounterUseCase: _FakeIncrementCounterUseCase(),
    decrementCounterUseCase: _FakeDecrementCounterUseCase(),
  );

  @override
  Future<void> loadCounter() async {
    state = state.copyWith(isLoading: true);
    await Future.delayed(const Duration(milliseconds: 10));
    state = state.copyWith(
      isLoading: false,
      error: 'Failed to load counter data',
    );
  }
}

class _FakeGetCounterUseCase extends Fake implements GetCounterUseCase {}
class _FakeIncrementCounterUseCase extends Fake implements IncrementCounterUseCase {}
class _FakeDecrementCounterUseCase extends Fake implements DecrementCounterUseCase {}
