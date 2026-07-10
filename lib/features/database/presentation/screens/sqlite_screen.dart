import 'package:flutter/material.dart';
import '../../models/sqlite/sqlite_user_model.dart';
import '../../services/sqlite/sqlite_service.dart';

class SqliteScreen extends StatefulWidget {
  const SqliteScreen({super.key});

  @override
  State<SqliteScreen> createState() => _SqliteScreenState();
}

class _SqliteScreenState extends State<SqliteScreen> {
  final SqliteService _sqliteService = SqliteService();
  List<SqliteUserModel> _users = [];
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _loadUsers();
  }

  Future<void> _loadUsers() async {
    if (!mounted) return;
    setState(() => _isLoading = true);
    try {
      _users = await _sqliteService.getAllUsers();
    } catch (e) {
      _showError('Failed to load users: $e');
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  Future<void> _addSampleUsers() async {
    if (!mounted) return;
    setState(() => _isLoading = true);
    try {
      for (int i = 1; i <= 5; i++) {
        final user = SqliteUserModel(
          id: 'sqlite_user_$i',
          name: 'SQLite User $i',
          email: 'sqlite$i@example.com',
          age: 20 + i,
          createdAt: DateTime.now(),
        );
        await _sqliteService.addUser(user);
      }
      await _loadUsers();
      _showSuccess('Added 5 sample users to SQLite!');
    } catch (e) {
      _showError('Failed to add users: $e');
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  Future<void> _clearAllUsers() async {
    if (!mounted) return;
    setState(() => _isLoading = true);
    try {
      await _sqliteService.deleteAllUsers();
      await _loadUsers();
      _showSuccess('All SQLite users deleted!');
    } catch (e) {
      _showError('Failed to delete users: $e');
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  void _showError(String message) {
    if (!mounted) return;
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('❌ $message'), backgroundColor: Colors.red),
        );
      }
    });
  }

  void _showSuccess(String message) {
    if (!mounted) return;
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('✅ $message'), backgroundColor: Colors.green),
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : Column(
        children: [
          // Action Buttons
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: [
                Expanded(
                  child: ElevatedButton.icon(
                    onPressed: _addSampleUsers,
                    icon: const Icon(Icons.add),
                    label: const Text('Add Sample'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.green,
                      foregroundColor: Colors.white,
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: ElevatedButton.icon(
                    onPressed: _clearAllUsers,
                    icon: const Icon(Icons.clear_all),
                    label: const Text('Clear All'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.red,
                      foregroundColor: Colors.white,
                    ),
                  ),
                ),
              ],
            ),
          ),

          // Stats
          Container(
            padding: const EdgeInsets.all(12),
            color: Colors.blue.shade50,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(Icons.data_object, color: Colors.blue),
                const SizedBox(width: 8),
                Text(
                  'Total SQLite Users: ${_users.length}',
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
              ],
            ),
          ),

          // User List
          Expanded(
            child: _users.isEmpty
                ? const Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.data_object, size: 64, color: Colors.grey),
                  SizedBox(height: 16),
                  Text('No SQLite Users Found'),
                  Text(
                    'Tap "Add Sample" to populate',
                    style: TextStyle(color: Colors.grey, fontSize: 12),
                  ),
                ],
              ),
            )
                : ListView.builder(
              itemCount: _users.length,
              padding: const EdgeInsets.all(8),
              itemBuilder: (context, index) {
                final user = _users[index];
                return Card(
                  child: ListTile(
                    leading: CircleAvatar(
                      backgroundColor: Colors.blue,
                      child: Text(user.name[0].toUpperCase()),
                    ),
                    title: Text(user.name),
                    subtitle: Text(user.email),
                    trailing: Text('Age: ${user.age}'),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}