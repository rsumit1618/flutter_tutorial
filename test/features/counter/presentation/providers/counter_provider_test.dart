import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:flutter_tutorial/features/counter/domain/entities/counter_entity.dart';
import 'package:flutter_tutorial/features/counter/domain/usecases/decrement_counter_usecase.dart';
import 'package:flutter_tutorial/features/counter/domain/usecases/get_counter_usecase.dart';
import 'package:flutter_tutorial/features/counter/domain/usecases/increment_counter_usecase.dart';
import 'package:flutter_tutorial/features/counter/presentation/providers/counter_provider.dart';

import 'counter_provider_test.mocks.dart';

@GenerateMocks([
  GetCounterUseCase,
  IncrementCounterUseCase,
  DecrementCounterUseCase,
])
void main() {
  late ProviderContainer container;
  late MockGetCounterUseCase mockGetCounterUseCase;
  late MockIncrementCounterUseCase mockIncrementCounterUseCase;
  late MockDecrementCounterUseCase mockDecrementCounterUseCase;

  setUp(() {
    mockGetCounterUseCase = MockGetCounterUseCase();
    mockIncrementCounterUseCase = MockIncrementCounterUseCase();
    mockDecrementCounterUseCase = MockDecrementCounterUseCase();

    container = ProviderContainer(
      overrides: [
        getCounterUseCaseProvider.overrideWithValue(mockGetCounterUseCase),
        incrementCounterUseCaseProvider.overrideWithValue(
          mockIncrementCounterUseCase,
        ),
        decrementCounterUseCaseProvider.overrideWithValue(
          mockDecrementCounterUseCase,
        ),
      ],
    );
  });

  tearDown(() {
    container.dispose();
  });

  group('CounterProvider', () {
    test('Initial state should load counter on creation', () async {
      // Arrange
      const expectedEntity = CounterEntity(
        value: 10,
        timestamp: '2024-01-01T00:00:00.000',
      );
      when(mockGetCounterUseCase()).thenAnswer((_) async => expectedEntity);

      // Act
      final state = container.read(counterProvider);

      // Wait for async operation to complete
      await Future.delayed(Duration.zero);

      // Assert
      expect(state.value, equals(10));
      expect(state.isLoading, isFalse);
      expect(state.error, isNull);
      verify(mockGetCounterUseCase()).called(1);
    });

    test('increment should increase counter value', () async {
      // Arrange
      const initialEntity = CounterEntity(
        value: 10,
        timestamp: '2024-01-01T00:00:00.000',
      );
      const incrementedEntity = CounterEntity(
        value: 11,
        timestamp: '2024-01-01T00:00:01.000',
      );

      when(mockGetCounterUseCase()).thenAnswer((_) async => initialEntity);
      when(mockIncrementCounterUseCase()).thenAnswer((_) async => incrementedEntity);

      // Act
      final notifier = container.read(counterProvider.notifier);
      await notifier.increment();

      // Wait for async operation to complete
      await Future.delayed(Duration.zero);

      final state = container.read(counterProvider);

      // Assert
      expect(state.value, equals(11));
      expect(state.error, isNull);
      verify(mockIncrementCounterUseCase()).called(1);
    });

    test('decrement should decrease counter value', () async {
      // Arrange
      const initialEntity = CounterEntity(
        value: 10,
        timestamp: '2024-01-01T00:00:00.000',
      );
      const decrementedEntity = CounterEntity(
        value: 9,
        timestamp: '2024-01-01T00:00:01.000',
      );

      when(mockGetCounterUseCase()).thenAnswer((_) async => initialEntity);
      when(mockDecrementCounterUseCase()).thenAnswer((_) async => decrementedEntity);

      // Act
      final notifier = container.read(counterProvider.notifier);
      await notifier.decrement();

      // Wait for async operation to complete
      await Future.delayed(Duration.zero);

      final state = container.read(counterProvider);

      // Assert
      expect(state.value, equals(9));
      expect(state.error, isNull);
      verify(mockDecrementCounterUseCase()).called(1);
    });

    test('resetCounter should set value to 0', () async {
      // Arrange
      const initialEntity = CounterEntity(
        value: 10,
        timestamp: '2024-01-01T00:00:00.000',
      );
      when(mockGetCounterUseCase()).thenAnswer((_) async => initialEntity);

      // Act
      final notifier = container.read(counterProvider.notifier);
      notifier.resetCounter();

      // Wait for async operation to complete
      await Future.delayed(Duration.zero);

      final state = container.read(counterProvider);

      // Assert
      expect(state.value, equals(0));
      expect(state.lastUpdated, equals(''));
    });

    test('should handle error when increment fails', () async {
      // Arrange
      const initialEntity = CounterEntity(
        value: 10,
        timestamp: '2024-01-01T00:00:00.000',
      );
      when(mockGetCounterUseCase()).thenAnswer((_) async => initialEntity);
      when(mockIncrementCounterUseCase()).thenThrow(Exception('Increment failed'));

      // Act
      final notifier = container.read(counterProvider.notifier);
      await notifier.increment();

      // Wait for async operation to complete
      await Future.delayed(Duration.zero);

      final state = container.read(counterProvider);

      // Assert
      expect(state.error, contains('Increment failed'));
      expect(state.value, equals(10)); // Value should not change
    });

    test('should handle error when decrement fails', () async {
      // Arrange
      const initialEntity = CounterEntity(
        value: 10,
        timestamp: '2024-01-01T00:00:00.000',
      );
      when(mockGetCounterUseCase()).thenAnswer((_) async => initialEntity);
      when(mockDecrementCounterUseCase()).thenThrow(Exception('Decrement failed'));

      // Act
      final notifier = container.read(counterProvider.notifier);
      await notifier.decrement();

      // Wait for async operation to complete
      await Future.delayed(Duration.zero);

      final state = container.read(counterProvider);

      // Assert
      expect(state.error, contains('Decrement failed'));
      expect(state.value, equals(10));
    });

    test('should handle multiple increments in sequence', () async {
      // Arrange
      int currentValue = 0;
      when(mockGetCounterUseCase()).thenAnswer((_) async =>
      const CounterEntity(value: 0, timestamp: ''),
      );
      when(mockIncrementCounterUseCase()).thenAnswer((_) async {
        currentValue++;
        return CounterEntity(value: currentValue, timestamp: '');
      });

      // Act
      final notifier = container.read(counterProvider.notifier);
      await notifier.increment();
      await notifier.increment();
      await notifier.increment();

      // Wait for async operations to complete
      await Future.delayed(Duration.zero);

      final state = container.read(counterProvider);

      // Assert
      expect(state.value, equals(3));
      verify(mockIncrementCounterUseCase()).called(3);
    });

    test('should handle loading state during increment', () async {
      // Arrange
      const initialEntity = CounterEntity(
        value: 5,
        timestamp: '2024-01-01',
      );
      when(mockGetCounterUseCase()).thenAnswer((_) async => initialEntity);

      // Create a delayed response to test loading state
      when(mockIncrementCounterUseCase()).thenAnswer((_) async {
        await Future.delayed(const Duration(milliseconds: 100));
        return const CounterEntity(value: 6, timestamp: '2024-01-01');
      });

      // Act
      final notifier = container.read(counterProvider.notifier);
      final future = notifier.increment();

      // Check loading state
      expect(container.read(counterProvider).isLoading, isTrue);

      await future;
      await Future.delayed(Duration.zero);

      // Check final state
      final state = container.read(counterProvider);
      expect(state.value, equals(6));
      expect(state.isLoading, isFalse);
    });

    test('should handle error when loading counter fails', () async {
      // Arrange
      when(mockGetCounterUseCase()).thenThrow(Exception('Load failed'));

      // Create a new provider with error scenario
      final errorContainer = ProviderContainer(
        overrides: [
          getCounterUseCaseProvider.overrideWithValue(mockGetCounterUseCase),
          incrementCounterUseCaseProvider.overrideWithValue(
            mockIncrementCounterUseCase,
          ),
          decrementCounterUseCaseProvider.overrideWithValue(
            mockDecrementCounterUseCase,
          ),
        ],
      );

      // Act
      final state = errorContainer.read(counterProvider);

      // Wait for async operation to complete
      await Future.delayed(Duration.zero);

      // Assert
      expect(state.error, contains('Load failed'));
      expect(state.value, equals(0));

      errorContainer.dispose();
    });
  });
}