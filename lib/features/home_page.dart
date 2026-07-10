import 'package:flutter/material.dart';
import 'counter/presentation/screens/counter_screen.dart';
import 'user/presentation/screens/user_profile_screen.dart';
import 'database/presentation/screens/hive_screen.dart';
import 'database/presentation/screens/sqlite_screen.dart';
import 'database/presentation/screens/comparison_screen.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int _currentIndex = 0;

  final List<Widget> _screens = const [
    CounterScreen(),
    UserProfileScreen(),
    HiveScreen(),        
    SqliteScreen(),      
    ComparisonScreen(),  
  ];

  final List<String> _titles = [
    'Counter',
    'User Profile',
    'Hive (NoSQL)',
    'SQLite (RDBMS)',
    'Comparison',
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(_titles[_currentIndex]),
        elevation: 0,
        backgroundColor: Colors.blue.shade700,
        foregroundColor: Colors.white,
      ),
      body: _screens[_currentIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: (index) => setState(() => _currentIndex = index),
        selectedItemColor: Colors.blue.shade700,
        unselectedItemColor: Colors.grey,
        type: BottomNavigationBarType.fixed,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.exposure_plus_1),
            label: 'Counter',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: 'Profile',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.storage),
            label: 'Hive',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.data_object),
            label: 'SQLite',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.compare_arrows),
            label: 'Compare',
          ),
        ],
      ),
    );
  }
}