class SqliteUserModel {
  final String id;
  final String name;
  final String email;
  final int age;
  final DateTime createdAt;

  SqliteUserModel({
    required this.id,
    required this.name,
    required this.email,
    required this.age,
    required this.createdAt,
  });

  // Convert from Map (Database result → Model)
  factory SqliteUserModel.fromMap(Map<String, dynamic> map) {
    return SqliteUserModel(
      id: map['id'] as String,
      name: map['name'] as String,
      email: map['email'] as String,
      age: map['age'] as int,
      createdAt: DateTime.parse(map['created_at'] as String),
    );
  }

  // Convert to Map (Model → Database)
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'email': email,
      'age': age,
      'created_at': createdAt.toIso8601String(),
    };
  }

  SqliteUserModel copyWith({
    String? id,
    String? name,
    String? email,
    int? age,
    DateTime? createdAt,
  }) {
    return SqliteUserModel(
      id: id ?? this.id,
      name: name ?? this.name,
      email: email ?? this.email,
      age: age ?? this.age,
      createdAt: createdAt ?? this.createdAt,
    );
  }

  @override
  String toString() {
    return 'SqliteUserModel(id: $id, name: $name, email: $email, age: $age)';
  }
}