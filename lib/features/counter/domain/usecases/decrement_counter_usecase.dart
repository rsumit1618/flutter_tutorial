import '../entities/counter_entity.dart';
import '../repositories/counter_repository.dart';

class DecrementCounterUseCase {
  final CounterRepository repository;

  DecrementCounterUseCase(this.repository);

  Future<CounterEntity> call() async {
    return await repository.decrementCounter();
  }
}