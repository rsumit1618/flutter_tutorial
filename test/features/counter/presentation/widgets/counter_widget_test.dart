import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_tutorial/features/counter/presentation/widgets/counter_widget.dart';

void main() {
  group('CounterWidget', () {
    testWidgets('displays counter value correctly', (WidgetTester tester) async {
      // Arrange
      const testValue = 42;
      const testTimestamp = '2024-01-01T00:00:00.000';

      // Act
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: CounterWidget(
              value: testValue,
              lastUpdated: testTimestamp,
            ),
          ),
        ),
      );

      // Assert
      expect(find.text('42'), findsOneWidget);
      expect(find.text('Last Updated: $testTimestamp'), findsOneWidget);
      expect(find.text('Counter Value'), findsOneWidget);
    });

    testWidgets('shows only counter value when timestamp is empty', (WidgetTester tester) async {
      // Arrange
      const testValue = 100;

      // Act
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: CounterWidget(
              value: testValue,
              lastUpdated: '',
            ),
          ),
        ),
      );

      // Assert
      expect(find.text('100'), findsOneWidget);
      expect(find.byKey(const Key('lastUpdated')), findsNothing);
    });

    testWidgets('has correct styling', (WidgetTester tester) async {
      // Arrange
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: CounterWidget(
              value: 5,
              lastUpdated: '2024-01-01',
            ),
          ),
        ),
      );

      // Assert
      final container = tester.widget<Container>(
        find.byType(Container).first,
      );
      expect(container.decoration, isA<BoxDecoration>());

      final decoration = container.decoration as BoxDecoration;
      expect(decoration.color, Colors.blue.shade50);
      expect(decoration.borderRadius, BorderRadius.circular(16));
    });
  });
}