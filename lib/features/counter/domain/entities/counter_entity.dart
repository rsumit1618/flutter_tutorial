class CounterEntity {
  final int value;
  final String timestamp;

  const CounterEntity({
    required this.value,
    required this.timestamp,
  });

  CounterEntity copyWith({int? value, String? timestamp}) {
    return CounterEntity(
      value: value ?? this.value,
      timestamp: timestamp ?? this.timestamp,
    );
  }
}