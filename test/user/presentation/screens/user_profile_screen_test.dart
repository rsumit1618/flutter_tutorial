import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_tutorial/features/user/presentation/screens/user_profile_screen.dart';

void main() {
  group('UserProfileScreen', () {
    testWidgets('displays login form when user is not logged in',
            (WidgetTester tester) async {
          // Arrange
          await tester.pumpWidget(
            const ProviderScope(
              child: MaterialApp(
                home: UserProfileScreen(),
              ),
            ),
          );

          // Assert
          expect(find.byKey(const Key('nameField')), findsOneWidget);
          expect(find.byKey(const Key('ageField')), findsOneWidget);
          expect(find.byKey(const Key('loginButton')), findsOneWidget);
          expect(find.byKey(const Key('logoutButton')), findsNothing);
          expect(find.byKey(const Key('userCard')), findsOneWidget);
        });

    testWidgets('login button logs in user with valid input',
            (WidgetTester tester) async {
          // Arrange
          await tester.pumpWidget(
            const ProviderScope(
              child: MaterialApp(
                home: UserProfileScreen(),
              ),
            ),
          );

          // Act
          await tester.enterText(find.byKey(const Key('nameField')), 'John Doe');
          await tester.enterText(find.byKey(const Key('ageField')), '30');
          await tester.tap(find.byKey(const Key('loginButton')));
          await tester.pump();

          // Assert
          expect(find.text('Name: John Doe'), findsOneWidget);
          expect(find.text('Age: 30'), findsOneWidget);
          expect(find.text('✅ Logged In'), findsOneWidget);
          expect(find.byKey(const Key('logoutButton')), findsOneWidget);
          expect(find.byKey(const Key('nameField')), findsNothing);
        });

    testWidgets('does not login with empty fields',
            (WidgetTester tester) async {
          // Arrange
          await tester.pumpWidget(
            const ProviderScope(
              child: MaterialApp(
                home: UserProfileScreen(),
              ),
            ),
          );

          // Act
          await tester.tap(find.byKey(const Key('loginButton')));
          await tester.pump();

          // Assert
          expect(find.text('❌ Logged Out'), findsOneWidget);
          expect(find.byKey(const Key('nameField')), findsOneWidget);
          expect(find.byKey(const Key('ageField')), findsOneWidget);
        });

    testWidgets('logout button logs out user',
            (WidgetTester tester) async {
          // Arrange
          await tester.pumpWidget(
            const ProviderScope(
              child: MaterialApp(
                home: UserProfileScreen(),
              ),
            ),
          );

          // Login first
          await tester.enterText(find.byKey(const Key('nameField')), 'Test User');
          await tester.enterText(find.byKey(const Key('ageField')), '25');
          await tester.tap(find.byKey(const Key('loginButton')));
          await tester.pump();

          // Act - Logout
          await tester.tap(find.byKey(const Key('logoutButton')));
          await tester.pump();

          // Assert
          expect(find.text('❌ Logged Out'), findsOneWidget);
          expect(find.byKey(const Key('loginButton')), findsOneWidget);
          expect(find.byKey(const Key('logoutButton')), findsNothing);
        });

    testWidgets('age buttons update age when logged in',
            (WidgetTester tester) async {
          // Arrange
          await tester.pumpWidget(
            const ProviderScope(
              child: MaterialApp(
                home: UserProfileScreen(),
              ),
            ),
          );

          // Login first
          await tester.enterText(find.byKey(const Key('nameField')), 'Test User');
          await tester.enterText(find.byKey(const Key('ageField')), '25');
          await tester.tap(find.byKey(const Key('loginButton')));
          await tester.pump();

          // Act - Increase age
          await tester.tap(find.byKey(const Key('increaseAge')));
          await tester.pump();

          // Assert
          expect(find.text('Age: 26'), findsOneWidget);

          // Act - Decrease age
          await tester.tap(find.byKey(const Key('decreaseAge')));
          await tester.pump();

          // Assert
          expect(find.text('Age: 25'), findsOneWidget);
        });
  });
}