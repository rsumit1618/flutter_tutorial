import 'package:flutter/material.dart';

class UserCard extends StatelessWidget {
  final String name;
  final int age;
  final bool isLoggedIn;

  const UserCard({
    super.key,
    required this.name,
    required this.age,
    required this.isLoggedIn,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      key: const Key('userCard'),
      elevation: 4,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Row(
          children: [
            CircleAvatar(
              key: const Key('userAvatar'),
              backgroundColor: isLoggedIn ? Colors.green : Colors.grey,
              radius: 30,
              child: Text(
                name.isNotEmpty ? name[0].toUpperCase() : '?',
                style: const TextStyle(
                  fontSize: 24,
                  color: Colors.white,
                ),
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Name: $name',
                    key: const Key('userName'),
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(
                    'Age: $age',
                    key: const Key('userAge'),
                    style: const TextStyle(
                      fontSize: 16,
                      color: Colors.grey,
                    ),
                  ),
                  Text(
                    isLoggedIn ? '✅ Logged In' : '❌ Logged Out',
                    key: const Key('userStatus'),
                    style: TextStyle(
                      color: isLoggedIn ? Colors.green : Colors.red,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}