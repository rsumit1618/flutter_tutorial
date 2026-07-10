import 'package:shared_preferences/shared_preferences.dart';
import '../models/counter_model.dart';

class CounterLocalDataSource {
  static const String _counterKey = 'counter_value';
  static const String _timestampKey = 'counter_timestamp';

  Future<CounterModel> getCounter() async {
    final prefs = await SharedPreferences.getInstance();
    final value = prefs.getInt(_counterKey) ?? 0;
    final timestamp = prefs.getString(_timestampKey) ?? DateTime.now().toIso8601String();

    return CounterModel(
      value: value,
      timestamp: timestamp,
    );
  }

  Future<CounterModel> saveCounter(int value) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt(_counterKey, value);
    await prefs.setString(_timestampKey, DateTime.now().toIso8601String());

    return CounterModel(
      value: value,
      timestamp: DateTime.now().toIso8601String(),
    );
  }

  Future<void> resetCounter() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_counterKey);
    await prefs.remove(_timestampKey);
  }
}