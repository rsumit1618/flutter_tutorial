import 'package:flutter/material.dart';
import '../../services/hive/hive_service.dart';
import '../../services/sqlite/sqlite_service.dart';
import '../../models/hive/hive_user_model.dart';
import '../../models/sqlite/sqlite_user_model.dart';

class ComparisonScreen extends StatefulWidget {
  const ComparisonScreen({super.key});

  @override
  State<ComparisonScreen> createState() => _ComparisonScreenState();
}

class _ComparisonScreenState extends State<ComparisonScreen> {
  final HiveService _hiveService = HiveService();
  final SqliteService _sqliteService = SqliteService();

  int _hiveCount = 0;
  int _sqliteCount = 0;
  bool _isLoading = false;
  Map<String, dynamic>? _comparisonResults;

  @override
  void initState() {
    super.initState();
    _loadStats();
  }

  Future<void> _loadStats() async {
    setState(() => _isLoading = true);
    try {
      _hiveCount = _hiveService.getUserCount();
      _sqliteCount = await _sqliteService.getUserCount();
    } catch (e) {
      print('Error loading stats: $e');
    } finally {
      setState(() => _isLoading = false);
    }
  }

  Future<void> _runPerformanceTest() async {
    setState(() => _isLoading = true);
    try {
      final results = await _performComparison();
      setState(() => _comparisonResults = results);
      _showResultsDialog(results);
    } catch (e) {
      _showError('Comparison failed: $e');
    } finally {
      setState(() => _isLoading = false);
    }
  }

  Future<Map<String, dynamic>> _performComparison() async {
    final results = <String, dynamic>{};
    final stopwatch = Stopwatch();

    // Test Hive Write
    stopwatch.start();
    for (int i = 1; i <= 50; i++) {
      final user = HiveUserModel(
        id: 'hive_test_$i',
        name: 'Test User $i',
        email: 'test$i@example.com',
        age: 20 + (i % 30),
        createdAt: DateTime.now(),
      );
      await _hiveService.addUser(user);
    }
    stopwatch.stop();
    results['hiveWrite'] = stopwatch.elapsedMilliseconds;

    // Test SQLite Write
    stopwatch.reset();
    stopwatch.start();
    for (int i = 1; i <= 50; i++) {
      final user = SqliteUserModel(
        id: 'sqlite_test_$i',
        name: 'Test User $i',
        email: 'test$i@example.com',
        age: 20 + (i % 30),
        createdAt: DateTime.now(),
      );
      await _sqliteService.addUser(user);
    }
    stopwatch.stop();
    results['sqliteWrite'] = stopwatch.elapsedMilliseconds;

    // Test Hive Read
    stopwatch.reset();
    stopwatch.start();
    final hiveUsers = _hiveService.getAllUsers();
    stopwatch.stop();
    results['hiveRead'] = stopwatch.elapsedMilliseconds;
    results['hiveCount'] = hiveUsers.length;

    // Test SQLite Read
    stopwatch.reset();
    stopwatch.start();
    final sqliteUsers = await _sqliteService.getAllUsers();
    stopwatch.stop();
    results['sqliteRead'] = stopwatch.elapsedMilliseconds;
    results['sqliteCount'] = sqliteUsers.length;

    // Clean up
    await _hiveService.deleteAllUsers();
    await _sqliteService.deleteAllUsers();

    await _loadStats();
    return results;
  }

  void _showResultsDialog(Map<String, dynamic> results) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('📊 Performance Comparison'),
        content: Container(
          width: double.maxFinite,
          constraints: const BoxConstraints(maxHeight: 400),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildResultRow('Write (50 records)', results['hiveWrite'], results['sqliteWrite']),
                const Divider(),
                _buildResultRow('Read (All records)', results['hiveRead'], results['sqliteRead']),
                const Divider(),
                _buildResultRow('Total Records', results['hiveCount'], results['sqliteCount']),
                const Divider(),
                const SizedBox(height: 16),
                _buildSummary(results),
              ],
            ),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Close'),
          ),
        ],
      ),
    );
  }

  Widget _buildResultRow(String label, int hiveValue, int sqliteValue) {
    final isHiveFaster = hiveValue < sqliteValue;

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(label, style: const TextStyle(fontWeight: FontWeight.bold)),
          const SizedBox(height: 4),
          Row(
            children: [
              Expanded(
                child: Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: isHiveFaster ? Colors.green.shade100 : Colors.grey.shade200,
                    borderRadius: BorderRadius.circular(4),
                  ),
                  child: Column(
                    children: [
                      const Text('Hive', style: TextStyle(fontSize: 12)),
                      Text('${hiveValue}ms', style: const TextStyle(fontWeight: FontWeight.bold)),
                    ],
                  ),
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: !isHiveFaster ? Colors.green.shade100 : Colors.grey.shade200,
                    borderRadius: BorderRadius.circular(4),
                  ),
                  child: Column(
                    children: [
                      const Text('SQLite', style: TextStyle(fontSize: 12)),
                      Text('${sqliteValue}ms', style: const TextStyle(fontWeight: FontWeight.bold)),
                    ],
                  ),
                ),
              ),
            ],
          ),
          if (hiveValue != sqliteValue)
            Padding(
              padding: const EdgeInsets.only(top: 4),
              child: Text(
                '🏆 ${isHiveFaster ? 'Hive' : 'SQLite'} is faster!',
                style: TextStyle(
                  color: isHiveFaster ? Colors.orange : Colors.blue,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildSummary(Map<String, dynamic> results) {
    final isHiveFaster = (results['hiveWrite'] + results['hiveRead']) <
        (results['sqliteWrite'] + results['sqliteRead']);

    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: isHiveFaster ? Colors.orange.shade50 : Colors.blue.shade50,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(
          color: isHiveFaster ? Colors.orange : Colors.blue,
        ),
      ),
      child: Column(
        children: [
          Text(
            '📌 Summary',
            style: TextStyle(
              fontWeight: FontWeight.bold,
              color: isHiveFaster ? Colors.orange.shade700 : Colors.blue.shade700,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            isHiveFaster
                ? 'Hive is faster for these operations!'
                : 'SQLite is faster for these operations!',
            style: const TextStyle(fontSize: 12),
          ),
        ],
      ),
    );
  }

  void _showError(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('❌ $message'), backgroundColor: Colors.red),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : Column(
        children: [
          // Stats
          Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                Expanded(
                  child: Card(
                    color: Colors.orange.shade100,
                    child: Padding(
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        children: [
                          const Text('Hive Users', style: TextStyle(fontWeight: FontWeight.bold)),
                          Text(
                            '$_hiveCount',
                            style: const TextStyle(
                              fontSize: 32,
                              fontWeight: FontWeight.bold,
                              color: Colors.orange,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: Card(
                    color: Colors.blue.shade100,
                    child: Padding(
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        children: [
                          const Text('SQLite Users', style: TextStyle(fontWeight: FontWeight.bold)),
                          Text(
                            '$_sqliteCount',
                            style: const TextStyle(
                              fontSize: 32,
                              fontWeight: FontWeight.bold,
                              color: Colors.blue,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),

          // Test Button
          Center(
            child: ElevatedButton.icon(
              onPressed: _runPerformanceTest,
              icon: const Icon(Icons.play_arrow),
              label: const Text('Run Performance Test (50 records)'),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.purple,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
              ),
            ),
          ),

          const SizedBox(height: 16),

          // Comparison Table
          const Expanded(
            child: Card(
              margin: EdgeInsets.all(16),
              child: Padding(
                padding: EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      '📊 Key Differences',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: 8),
                    _ComparisonRow(
                      feature: 'Type',
                      hive: 'NoSQL (Key-Value)',
                      sqlite: 'SQL (Relational)',
                    ),
                    _ComparisonRow(
                      feature: 'Schema',
                      hive: 'Schema-less',
                      sqlite: 'Fixed Schema',
                    ),
                    _ComparisonRow(
                      feature: 'Queries',
                      hive: 'Key-based',
                      sqlite: 'SQL Queries',
                    ),
                    _ComparisonRow(
                      feature: 'Relationships',
                      hive: 'No Relationships',
                      sqlite: 'Relationships (JOIN)',
                    ),
                    _ComparisonRow(
                      feature: 'Performance',
                      hive: 'Very Fast (NoSQL)',
                      sqlite: 'Fast (Optimized)',
                    ),
                    _ComparisonRow(
                      feature: 'Use Case',
                      hive: 'Local storage, Cache',
                      sqlite: 'Complex data, Reports',
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _ComparisonRow extends StatelessWidget {
  final String feature;
  final String hive;
  final String sqlite;

  const _ComparisonRow({
    required this.feature,
    required this.hive,
    required this.sqlite,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 80,
            child: Text(
              feature,
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
          ),
          Expanded(
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              decoration: BoxDecoration(
                color: Colors.orange.shade50,
                borderRadius: BorderRadius.circular(4),
              ),
              child: Text(hive, style: const TextStyle(fontSize: 12)),
            ),
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              decoration: BoxDecoration(
                color: Colors.blue.shade50,
                borderRadius: BorderRadius.circular(4),
              ),
              child: Text(sqlite, style: const TextStyle(fontSize: 12)),
            ),
          ),
        ],
      ),
    );
  }
}