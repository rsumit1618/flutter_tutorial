import '../entities/counter_entity.dart';

abstract class CounterRepository {
  Future<CounterEntity> getCounter();
  Future<CounterEntity> incrementCounter();
  Future<CounterEntity> decrementCounter();
  Future<void> resetCounter();
}