import 'package:flutter_riverpod/flutter_riverpod.dart';

// Simple User State
class UserState {
  final String name;
  final int age;
  final bool isLoggedIn;

  const UserState({
    required this.name,
    required this.age,
    this.isLoggedIn = false,
  });

  UserState copyWith({
    String? name,
    int? age,
    bool? isLoggedIn,
  }) {
    return UserState(
      name: name ?? this.name,
      age: age ?? this.age,
      isLoggedIn: isLoggedIn ?? this.isLoggedIn,
    );
  }
}

class UserNotifier extends StateNotifier<UserState> {
  UserNotifier() : super(const UserState(name: 'Guest', age: 0));

  void login(String name, int age) {
    state = state.copyWith(
      name: name,
      age: age,
      isLoggedIn: true,
    );
  }

  void logout() {
    state = const UserState(name: 'Guest', age: 0, isLoggedIn: false);
  }

  void updateAge(int age) {
    state = state.copyWith(age: age);
  }
}

final userProvider = StateNotifierProvider<UserNotifier, UserState>((ref) {
  return UserNotifier();
});