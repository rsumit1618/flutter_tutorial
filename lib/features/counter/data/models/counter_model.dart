
import '../../domain/entities/counter_entity.dart';

class CounterModel extends CounterEntity {
  const CounterModel({
    required super.value,
    required super.timestamp,
  });

  factory CounterModel.fromEntity(CounterEntity entity) {
    return CounterModel(
      value: entity.value,
      timestamp: entity.timestamp,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'value': value,
      'timestamp': timestamp,
    };
  }

  factory CounterModel.fromJson(Map<String, dynamic> json) {
    return CounterModel(
      value: json['value'] ?? 0,
      timestamp: json['timestamp'] ?? DateTime.now().toIso8601String(),
    );
  }

  CounterModel copyWith({int? value, String? timestamp}) {
    return CounterModel(
      value: value ?? this.value,
      timestamp: timestamp ?? this.timestamp,
    );
  }
}