import 'package:flutter/foundation.dart';
import 'package:hive_flutter/hive_flutter.dart';
import '../../models/hive/hive_user_model.dart';

class HiveService {
  static const String _userBoxName = 'users_box';
  late Box<HiveUserModel> _userBox;

  // Singleton pattern
  static final HiveService _instance = HiveService._internal();
  factory HiveService() => _instance;
  HiveService._internal();

  /// Initialize Hive
  Future<void> init() async {
    await Hive.initFlutter();
    Hive.registerAdapter(HiveUserModelAdapter());
    _userBox = await Hive.openBox<HiveUserModel>(_userBoxName);
    if (kDebugMode) {
      print('✅ Hive initialized. Users: ${_userBox.length}');
    }
  }

  // CREATE: Add user
  Future<void> addUser(HiveUserModel user) async {
    await _userBox.put(user.id, user);
  }

  // READ: Get all users
  List<HiveUserModel> getAllUsers() {
    return _userBox.values.toList();
  }

  // READ: Get single user
  HiveUserModel? getUser(String id) {
    return _userBox.get(id);
  }

  // UPDATE: Update user
  Future<void> updateUser(HiveUserModel user) async {
    if (_userBox.containsKey(user.id)) {
      await _userBox.put(user.id, user);
    } else {
      throw Exception('User not found: ${user.id}');
    }
  }

  // DELETE: Delete user
  Future<void> deleteUser(String id) async {
    if (_userBox.containsKey(id)) {
      await _userBox.delete(id);
    } else {
      throw Exception('User not found: $id');
    }
  }

  // DELETE: Delete all users
  Future<void> deleteAllUsers() async {
    await _userBox.clear();
  }

  // Get user count
  int getUserCount() {
    return _userBox.length;
  }

  // Search users by name
  List<HiveUserModel> searchUsersByName(String query) {
    return _userBox.values
        .where((user) => user.name.toLowerCase().contains(query.toLowerCase()))
        .toList();
  }

  // Get users by age range
  List<HiveUserModel> getUsersByAgeRange(int minAge, int maxAge) {
    return _userBox.values
        .where((user) => user.age >= minAge && user.age <= maxAge)
        .toList();
  }

  // Check if user exists
  bool userExists(String id) {
    return _userBox.containsKey(id);
  }

  // Listen to changes
  Stream<BoxEvent> listenToChanges() {
    return _userBox.watch();
  }

  // Close box
  Future<void> close() async {
    await _userBox.close();
    await Hive.close();
  }
}