import 'package:flutter/material.dart';
import '../../models/hive/hive_user_model.dart';
import '../../services/hive/hive_service.dart';

class HiveScreen extends StatefulWidget {
  const HiveScreen({super.key});

  @override
  State<HiveScreen> createState() => _HiveScreenState();
}

class _HiveScreenState extends State<HiveScreen> {
  final HiveService _hiveService = HiveService();
  List<HiveUserModel> _users = [];
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _loadUsers();
  }

  Future<void> _loadUsers() async {
    setState(() => _isLoading = true);
    try {
      _users = _hiveService.getAllUsers();
    } catch (e) {
      _showError('Failed to load users: $e');
    } finally {
      setState(() => _isLoading = false);
    }
  }

  Future<void> _addSampleUsers() async {
    setState(() => _isLoading = true);
    try {
      for (int i = 1; i <= 5; i++) {
        final user = HiveUserModel(
          id: 'hive_user_$i',
          name: 'Hive User $i',
          email: 'hive$i@example.com',
          age: 20 + i,
          createdAt: DateTime.now(),
        );
        await _hiveService.addUser(user);
      }
      await _loadUsers();
      _showSuccess('Added 5 sample users to Hive!');
    } catch (e) {
      _showError('Failed to add users: $e');
    } finally {
      setState(() => _isLoading = false);
    }
  }

  Future<void> _clearAllUsers() async {
    setState(() => _isLoading = true);
    try {
      await _hiveService.deleteAllUsers();
      await _loadUsers();
      _showSuccess('All Hive users deleted!');
    } catch (e) {
      _showError('Failed to delete users: $e');
    } finally {
      setState(() => _isLoading = false);
    }
  }

  void _showError(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('❌ $message'), backgroundColor: Colors.red),
    );
  }

  void _showSuccess(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('✅ $message'), backgroundColor: Colors.green),
    );
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
            color: Colors.orange.shade50,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(Icons.storage, color: Colors.orange),
                const SizedBox(width: 8),
                Text(
                  'Total Hive Users: ${_users.length}',
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
                  Icon(Icons.storage, size: 64, color: Colors.grey),
                  SizedBox(height: 16),
                  Text('No Hive Users Found'),
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
                      backgroundColor: Colors.orange,
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