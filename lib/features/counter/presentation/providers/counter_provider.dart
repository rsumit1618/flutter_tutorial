import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../data/repositories/counter_repository_impl.dart';
import '../../data/datasources/counter_local_datasource.dart';
import '../../domain/usecases/decrement_counter_usecase.dart';
import '../../domain/usecases/get_counter_usecase.dart';
import '../../domain/usecases/increment_counter_usecase.dart';

// Data Source Provider
final counterLocalDataSourceProvider = Provider((ref) {
  return CounterLocalDataSource();
});

// Repository Provider
final counterRepositoryProvider = Provider((ref) {
  return CounterRepositoryImpl(
    ref.watch(counterLocalDataSourceProvider),
  );
});

// Use Cases
final getCounterUseCaseProvider = Provider((ref) {
  return GetCounterUseCase(ref.watch(counterRepositoryProvider));
});

final incrementCounterUseCaseProvider = Provider((ref) {
  return IncrementCounterUseCase(ref.watch(counterRepositoryProvider));
});

final decrementCounterUseCaseProvider = Provider((ref) {
  return DecrementCounterUseCase(ref.watch(counterRepositoryProvider));
});

// Counter State
class CounterState {
  final int value;
  final bool isLoading;
  final String? error;
  final String lastUpdated;

  const CounterState({
    required this.value,
    this.isLoading = false,
    this.error,
    required this.lastUpdated,
  });

  CounterState copyWith({
    int? value,
    bool? isLoading,
    String? error,
    String? lastUpdated,
  }) {
    return CounterState(
      value: value ?? this.value,
      isLoading: isLoading ?? this.isLoading,
      error: error ?? this.error,
      lastUpdated: lastUpdated ?? this.lastUpdated,
    );
  }

  factory CounterState.initial() {
    return const CounterState(
      value: 0,
      isLoading: false,
      lastUpdated: '',
    );
  }
}

class CounterNotifier extends StateNotifier<CounterState> {
  final GetCounterUseCase _getCounterUseCase;
  final IncrementCounterUseCase _incrementCounterUseCase;
  final DecrementCounterUseCase _decrementCounterUseCase;

  CounterNotifier({
    required GetCounterUseCase getCounterUseCase,
    required IncrementCounterUseCase incrementCounterUseCase,
    required DecrementCounterUseCase decrementCounterUseCase,
  })  : _getCounterUseCase = getCounterUseCase,
        _incrementCounterUseCase = incrementCounterUseCase,
        _decrementCounterUseCase = decrementCounterUseCase,
        super(CounterState.initial()) {
    loadCounter();
  }

  Future<void> loadCounter() async {
    state = state.copyWith(isLoading: true);
    try {
      final entity = await _getCounterUseCase();
      state = state.copyWith(
        value: entity.value,
        isLoading: false,
        lastUpdated: entity.timestamp,
        error: null,
      );
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        error: e.toString(),
      );
    }
  }

  Future<void> increment() async {
    try {
      final entity = await _incrementCounterUseCase();
      state = state.copyWith(
        value: entity.value,
        lastUpdated: entity.timestamp,
        error: null,
      );
    } catch (e) {
      state = state.copyWith(error: e.toString());
    }
  }

  Future<void> decrement() async {
    try {
      final entity = await _decrementCounterUseCase();
      state = state.copyWith(
        value: entity.value,
        lastUpdated: entity.timestamp,
        error: null,
      );
    } catch (e) {
      state = state.copyWith(error: e.toString());
    }
  }

  void resetCounter() {
    state = const CounterState(value: 0, lastUpdated: '');
  }
}

final counterProvider = StateNotifierProvider<CounterNotifier, CounterState>((ref) {
  return CounterNotifier(
    getCounterUseCase: ref.watch(getCounterUseCaseProvider),
    incrementCounterUseCase: ref.watch(incrementCounterUseCaseProvider),
    decrementCounterUseCase: ref.watch(decrementCounterUseCaseProvider),
  );
});