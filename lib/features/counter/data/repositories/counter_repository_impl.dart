import '../../domain/entities/counter_entity.dart';
import '../../domain/repositories/counter_repository.dart';
import '../datasources/counter_local_datasource.dart';
import '../models/counter_model.dart';

class CounterRepositoryImpl implements CounterRepository {
  final CounterLocalDataSource dataSource;

  CounterRepositoryImpl(this.dataSource);

  @override
  Future<CounterEntity> getCounter() async {
    try {
      final model = await dataSource.getCounter();
      return model;
    } catch (e) {
      // Return default counter if error
      return const CounterModel(value: 0, timestamp: '');
    }
  }

  @override
  Future<CounterEntity> incrementCounter() async {
    final current = await getCounter();
    final newValue = current.value + 1;
    final model = await dataSource.saveCounter(newValue);
    return model;
  }

  @override
  Future<CounterEntity> decrementCounter() async {
    final current = await getCounter();
    final newValue = current.value - 1;
    final model = await dataSource.saveCounter(newValue);
    return model;
  }

  @override
  Future<void> resetCounter() async {
    await dataSource.resetCounter();
  }
}