class UserEntity {
  final String id;
  final String name;
  final String email;
  final int age;

  const UserEntity({
    required this.id,
    required this.name,
    required this.email,
    required this.age,
  });

  UserEntity copyWith({
    String? id,
    String? name,
    String? email,
    int? age,
  }) {
    return UserEntity(
      id: id ?? this.id,
      name: name ?? this.name,
      email: email ?? this.email,
      age: age ?? this.age,
    );
  }
}