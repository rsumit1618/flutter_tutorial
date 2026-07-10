import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import '../../models/sqlite/sqlite_user_model.dart';

class SqliteService {
  static final SqliteService _instance = SqliteService._internal();
  factory SqliteService() => _instance;
  SqliteService._internal();

  static Database? _database;

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDatabase();
    return _database!;
  }

  Future<Database> _initDatabase() async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, 'users_database.db');

    return await openDatabase(
      path,
      version: 2,
      onCreate: _onCreate,
      onUpgrade: _onUpgrade,
    );
  }

  Future<void> _onCreate(Database db, int version) async {
    await db.execute('''
      CREATE TABLE users(
        id TEXT PRIMARY KEY,
        name TEXT NOT NULL,
        email TEXT UNIQUE NOT NULL,
        age INTEGER NOT NULL,
        created_at TEXT NOT NULL
      )
    ''');

    await db.execute('CREATE INDEX idx_users_name ON users(name)');
    await db.execute('CREATE INDEX idx_users_age ON users(age)');
    print('✅ SQLite tables created');
  }

  Future<void> _onUpgrade(Database db, int oldVersion, int newVersion) async {
    if (oldVersion < 2) {
      await db.execute('ALTER TABLE users ADD COLUMN updated_at TEXT');
    }
  }

  // CREATE: Add user
  Future<void> addUser(SqliteUserModel user) async {
    final db = await database;
    await db.insert('users', user.toMap());
  }

  // CREATE: Add multiple users
  Future<void> addUsers(List<SqliteUserModel> users) async {
    final db = await database;
    final batch = db.batch();
    for (final user in users) {
      batch.insert('users', user.toMap());
    }
    await batch.commit();
  }

  // READ: Get all users
  Future<List<SqliteUserModel>> getAllUsers() async {
    final db = await database;
    final result = await db.query(
      'users',
      orderBy: 'created_at DESC',
    );
    return result.map((map) => SqliteUserModel.fromMap(map)).toList();
  }

  // READ: Get single user
  Future<SqliteUserModel?> getUser(String id) async {
    final db = await database;
    final result = await db.query(
      'users',
      where: 'id = ?',
      whereArgs: [id],
    );
    if (result.isNotEmpty) {
      return SqliteUserModel.fromMap(result.first);
    }
    return null;
  }

  // UPDATE: Update user
  Future<void> updateUser(SqliteUserModel user) async {
    final db = await database;
    final result = await db.update(
      'users',
      user.toMap(),
      where: 'id = ?',
      whereArgs: [user.id],
    );
    if (result == 0) {
      throw Exception('User not found: ${user.id}');
    }
  }

  // DELETE: Delete user
  Future<void> deleteUser(String id) async {
    final db = await database;
    final result = await db.delete(
      'users',
      where: 'id = ?',
      whereArgs: [id],
    );
    if (result == 0) {
      throw Exception('User not found: $id');
    }
  }

  // DELETE: Delete all users
  Future<void> deleteAllUsers() async {
    final db = await database;
    await db.delete('users');
  }

  // Get user count
  Future<int> getUserCount() async {
    final db = await database;
    final result = await db.query('users', columns: ['COUNT(*) as count']);
    return Sqflite.firstIntValue(result) ?? 0;
  }

  // Search users by name
  Future<List<SqliteUserModel>> searchUsersByName(String query) async {
    final db = await database;
    final result = await db.query(
      'users',
      where: 'name LIKE ?',
      whereArgs: ['%$query%'],
      orderBy: 'name ASC',
    );
    return result.map((map) => SqliteUserModel.fromMap(map)).toList();
  }

  // Get users by age range
  Future<List<SqliteUserModel>> getUsersByAgeRange(int minAge, int maxAge) async {
    final db = await database;
    final result = await db.query(
      'users',
      where: 'age >= ? AND age <= ?',
      whereArgs: [minAge, maxAge],
      orderBy: 'age ASC',
    );
    return result.map((map) => SqliteUserModel.fromMap(map)).toList();
  }

  // Close database
  Future<void> close() async {
    if (_database != null) {
      await _database!.close();
    }
  }
}