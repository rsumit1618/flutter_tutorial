import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../providers/user_provider.dart';
import '../widgets/user_card.dart';

class UserProfileScreen extends ConsumerStatefulWidget {
  const UserProfileScreen({super.key});

  @override
  ConsumerState<UserProfileScreen> createState() => _UserProfileScreenState();
}

class _UserProfileScreenState extends ConsumerState<UserProfileScreen> {
  final TextEditingController nameController = TextEditingController();
  final TextEditingController ageController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final userState = ref.watch(userProvider);
    final userNotifier = ref.read(userProvider.notifier);

    return Scaffold(
      appBar: AppBar(
        title: const Text('User Profile'),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            // User Card
            UserCard(
              name: userState.name,
              age: userState.age,
              isLoggedIn: userState.isLoggedIn,
            ),

            const SizedBox(height: 20),

            // Login Form
            if (!userState.isLoggedIn) ...[
              TextField(
                key: const Key('nameField'),
                controller: nameController,
                decoration: const InputDecoration(
                  labelText: 'Enter Name',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 10),
              TextField(
                key: const Key('ageField'),
                controller: ageController,
                decoration: const InputDecoration(
                  labelText: 'Enter Age',
                  border: OutlineInputBorder(),
                ),
                keyboardType: TextInputType.number,
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                key: const Key('loginButton'),
                onPressed: () {
                  if (nameController.text.isNotEmpty &&
                      ageController.text.isNotEmpty) {
                    userNotifier.login(
                      nameController.text,
                      int.parse(ageController.text),
                    );
                    nameController.clear();
                    ageController.clear();
                  }
                },
                child: const Text('Login'),
              ),
            ] else ...[
              // Update Age
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  IconButton(
                    key: const Key('decreaseAge'),
                    icon: const Icon(Icons.remove_circle),
                    onPressed: () {
                      if (userState.age > 0) {
                        userNotifier.updateAge(userState.age - 1);
                      }
                    },
                  ),
                  Text(
                    'Age: ${userState.age}',
                    style: const TextStyle(fontSize: 18),
                  ),
                  IconButton(
                    key: const Key('increaseAge'),
                    icon: const Icon(Icons.add_circle),
                    onPressed: () {
                      userNotifier.updateAge(userState.age + 1);
                    },
                  ),
                ],
              ),
              const SizedBox(height: 10),
              ElevatedButton(
                key: const Key('logoutButton'),
                onPressed: userNotifier.logout,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.red,
                ),
                child: const Text('Logout', style: TextStyle(color: Colors.white)),
              ),
            ],
          ],
        ),
      ),
    );
  }
}