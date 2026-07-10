import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_tutorial/features/user/presentation/widgets/user_card.dart';

void main() {
  group('UserCard Widget Tests', () {
    testWidgets('displays logged in user correctly',
            (WidgetTester tester) async {
          // Arrange
          const testName = 'John Doe';
          const testAge = 30;

          // Act
          await tester.pumpWidget(
            const MaterialApp(
              home: Scaffold(
                body: UserCard(
                  name: testName,
                  age: testAge,
                  isLoggedIn: true,
                ),
              ),
            ),
          );

          // Assert
          expect(find.byKey(const Key('userCard')), findsOneWidget);
          expect(find.text('Name: $testName'), findsOneWidget);
          expect(find.text('Age: $testAge'), findsOneWidget);
          expect(find.text('✅ Logged In'), findsOneWidget);

          // Check avatar color (green for logged in)
          final avatar = tester.widget<CircleAvatar>(find.byKey(const Key('userAvatar')));
          expect(avatar.backgroundColor, Colors.green);
        });

    testWidgets('displays logged out user correctly',
            (WidgetTester tester) async {
          // Arrange
          const testName = 'Guest';
          const testAge = 0;

          // Act
          await tester.pumpWidget(
            const MaterialApp(
              home: Scaffold(
                body: UserCard(
                  name: testName,
                  age: testAge,
                  isLoggedIn: false,
                ),
              ),
            ),
          );

          // Assert
          expect(find.text('❌ Logged Out'), findsOneWidget);

          // Check avatar color (grey for logged out)
          final avatar = tester.widget<CircleAvatar>(find.byKey(const Key('userAvatar')));
          expect(avatar.backgroundColor, Colors.grey);
        });

    testWidgets('shows first letter of name in avatar',
            (WidgetTester tester) async {
          // Arrange
          const testName = 'Alice';

          // Act
          await tester.pumpWidget(
            const MaterialApp(
              home: Scaffold(
                body: UserCard(
                  name: testName,
                  age: 25,
                  isLoggedIn: true,
                ),
              ),
            ),
          );

          // Assert
          final avatarText = tester.widget<Text>(
            find.descendant(
              of: find.byKey(const Key('userAvatar')),
              matching: find.byType(Text),
            ),
          );
          expect(avatarText.data, 'A');
        });

    testWidgets('shows ? when name is empty',
            (WidgetTester tester) async {
          // Arrange
          const testName = '';

          // Act
          await tester.pumpWidget(
            const MaterialApp(
              home: Scaffold(
                body: UserCard(
                  name: testName,
                  age: 0,
                  isLoggedIn: false,
                ),
              ),
            ),
          );

          // Assert
          final avatarText = tester.widget<Text>(
            find.descendant(
              of: find.byKey(const Key('userAvatar')),
              matching: find.byType(Text),
            ),
          );
          expect(avatarText.data, '?');
        });
  });
}