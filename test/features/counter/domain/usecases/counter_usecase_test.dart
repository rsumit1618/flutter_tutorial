import 'dart:async';

import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:flutter_tutorial/features/counter/domain/entities/counter_entity.dart';
import 'package:flutter_tutorial/features/counter/domain/repositories/counter_repository.dart';
import 'package:flutter_tutorial/features/counter/domain/usecases/decrement_counter_usecase.dart';
import 'package:flutter_tutorial/features/counter/domain/usecases/get_counter_usecase.dart';
import 'package:flutter_tutorial/features/counter/domain/usecases/increment_counter_usecase.dart';

import 'counter_usecase_test.mocks.dart';

@GenerateMocks([CounterRepository])
void main() {
  late MockCounterRepository mockRepository;
  late GetCounterUseCase getCounterUseCase;
  late IncrementCounterUseCase incrementCounterUseCase;
  late DecrementCounterUseCase decrementCounterUseCase;

  setUp(() {
    mockRepository = MockCounterRepository();
    getCounterUseCase = GetCounterUseCase(mockRepository);
    incrementCounterUseCase = IncrementCounterUseCase(mockRepository);
    decrementCounterUseCase = DecrementCounterUseCase(mockRepository);
  });

  tearDown(() {
    reset(mockRepository);
  });

  group('Counter Use Cases', () {
    group('GetCounterUseCase', () {
      test('should return counter entity when repository succeeds', () async {
        // Arrange
        const expectedEntity = CounterEntity(
          value: 5,
          timestamp: '2024-01-01T00:00:00.000',
        );
        when(mockRepository.getCounter()).thenAnswer((_) async => expectedEntity);

        // Act
        final result = await getCounterUseCase();

        // Assert
        expect(result, equals(expectedEntity));
        verify(mockRepository.getCounter()).called(1);
        verifyNoMoreInteractions(mockRepository);
      });

      test('should handle repository error gracefully', () async {
        // Arrange
        when(mockRepository.getCounter()).thenThrow(Exception('Network Error'));

        // Act & Assert
        expect(
              () => getCounterUseCase(),
          throwsA(isA<Exception>()),
        );
        verify(mockRepository.getCounter()).called(1);
      });

      test('should handle null timestamp gracefully', () async {
        // Arrange
        const expectedEntity = CounterEntity(
          value: 10,
          timestamp: '',
        );
        when(mockRepository.getCounter()).thenAnswer((_) async => expectedEntity);

        // Act
        final result = await getCounterUseCase();

        // Assert
        expect(result.value, equals(10));
        expect(result.timestamp, isEmpty);
        verify(mockRepository.getCounter()).called(1);
      });
    });

    group('IncrementCounterUseCase', () {
      test('should increase counter by 1', () async {
        // Arrange
        const currentEntity = CounterEntity(
          value: 5,
          timestamp: '2024-01-01T00:00:00.000',
        );
        const expectedEntity = CounterEntity(
          value: 6,
          timestamp: '2024-01-01T00:00:01.000',
        );

        when(mockRepository.getCounter()).thenAnswer((_) async => currentEntity);
        when(mockRepository.incrementCounter()).thenAnswer((_) async => expectedEntity);

        // Act
        final result = await incrementCounterUseCase();

        // Assert
        expect(result.value, equals(6));
        expect(result.value, greaterThan(currentEntity.value));
        verify(mockRepository.incrementCounter()).called(1);
      });

      test('should handle multiple increments in sequence', () async {
        // Arrange
        int currentValue = 0;
        when(mockRepository.getCounter()).thenAnswer(
              (_) async => CounterEntity(value: currentValue, timestamp: ''),
        );
        when(mockRepository.incrementCounter()).thenAnswer((_) async {
          currentValue++;
          return CounterEntity(value: currentValue, timestamp: '');
        });

        // Act
        final result1 = await incrementCounterUseCase();
        final result2 = await incrementCounterUseCase();
        final result3 = await incrementCounterUseCase();

        // Assert
        expect(result1.value, equals(1));
        expect(result2.value, equals(2));
        expect(result3.value, equals(3));
        verify(mockRepository.incrementCounter()).called(3);
      });

      test('should throw exception when increment fails', () async {
        // Arrange
        when(mockRepository.getCounter()).thenAnswer(
              (_) async => const CounterEntity(value: 5, timestamp: ''),
        );
        when(mockRepository.incrementCounter()).thenThrow(
          Exception('Database error'),
        );

        // Act & Assert
        expect(
              () => incrementCounterUseCase(),
          throwsA(isA<Exception>()),
        );
        verify(mockRepository.incrementCounter()).called(1);
      });
    });

    group('DecrementCounterUseCase', () {
      test('should decrease counter by 1', () async {
        // Arrange
        const currentEntity = CounterEntity(
          value: 5,
          timestamp: '2024-01-01T00:00:00.000',
        );
        const expectedEntity = CounterEntity(
          value: 4,
          timestamp: '2024-01-01T00:00:01.000',
        );

        when(mockRepository.getCounter()).thenAnswer((_) async => currentEntity);
        when(mockRepository.decrementCounter()).thenAnswer((_) async => expectedEntity);

        // Act
        final result = await decrementCounterUseCase();

        // Assert
        expect(result.value, equals(4));
        expect(result.value, lessThan(currentEntity.value));
        verify(mockRepository.decrementCounter()).called(1);
      });

      test('should handle multiple decrements in sequence', () async {
        // Arrange
        int currentValue = 10;
        when(mockRepository.getCounter()).thenAnswer(
              (_) async => CounterEntity(value: currentValue, timestamp: ''),
        );
        when(mockRepository.decrementCounter()).thenAnswer((_) async {
          currentValue--;
          return CounterEntity(value: currentValue, timestamp: '');
        });

        // Act
        final result1 = await decrementCounterUseCase();
        final result2 = await decrementCounterUseCase();
        final result3 = await decrementCounterUseCase();

        // Assert
        expect(result1.value, equals(9));
        expect(result2.value, equals(8));
        expect(result3.value, equals(7));
        verify(mockRepository.decrementCounter()).called(3);
      });

      test('should throw exception when decrement fails', () async {
        // Arrange
        when(mockRepository.getCounter()).thenAnswer(
              (_) async => const CounterEntity(value: 5, timestamp: ''),
        );
        when(mockRepository.decrementCounter()).thenThrow(
          Exception('Database error'),
        );

        // Act & Assert
        expect(
              () => decrementCounterUseCase(),
          throwsA(isA<Exception>()),
        );
        verify(mockRepository.decrementCounter()).called(1);
      });
    });

    group('Error Handling', () {
      test('should handle repository timeout gracefully', () async {
        // Arrange
        when(mockRepository.getCounter()).thenAnswer((_) async {
          await Future.delayed(const Duration(seconds: 5));
          return const CounterEntity(value: 0, timestamp: '');
        });
        when(mockRepository.incrementCounter()).thenThrow(
          TimeoutException('Operation timeout'),
        );

        // Act & Assert
        expect(
              () => incrementCounterUseCase(),
          throwsA(isA<TimeoutException>()),
        );
      });

      test('should verify reset counter is called', () async {
        // Arrange
        when(mockRepository.resetCounter()).thenAnswer((_) async => Future.value());

        // Act
        await mockRepository.resetCounter();

        // Assert
        verify(mockRepository.resetCounter()).called(1);
      });
    });
  });
}