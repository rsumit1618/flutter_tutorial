import 'package:hive/hive.dart';

// This tells Hive to generate code for this model
part 'hive_user_model.g.dart';

@HiveType(typeId: 0) // Unique ID for this model
class HiveUserModel {
  @HiveField(0)
  final String id;

  @HiveField(1)
  final String name;

  @HiveField(2)
  final String email;

  @HiveField(3)
  final int age;

  @HiveField(4)
  final DateTime createdAt;

  HiveUserModel({
    required this.id,
    required this.name,
    required this.email,
    required this.age,
    required this.createdAt,
  });

  HiveUserModel copyWith({
    String? id,
    String? name,
    String? email,
    int? age,
    DateTime? createdAt,
  }) {
    return HiveUserModel(
      id: id ?? this.id,
      name: name ?? this.name,
      email: email ?? this.email,
      age: age ?? this.age,
      createdAt: createdAt ?? this.createdAt,
    );
  }

  @override
  String toString() {
    return 'HiveUserModel(id: $id, name: $name, email: $email, age: $age)';
  }
}