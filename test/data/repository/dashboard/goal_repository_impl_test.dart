import 'package:flutter_test/flutter_test.dart';
import 'package:mobile_blitzbudget/core/error/api_exception.dart';
import 'package:mobile_blitzbudget/core/failure/api_failure.dart';
import 'package:mobile_blitzbudget/core/failure/failure.dart';
import 'package:mobile_blitzbudget/core/failure/generic_failure.dart';
import 'package:mobile_blitzbudget/data/datasource/remote/dashboard/goal_remote_data_source.dart';
import 'package:mobile_blitzbudget/data/model/goal/goal_model.dart';
import 'package:mobile_blitzbudget/data/repositories/dashboard/goal_repository_impl.dart';
import 'package:mobile_blitzbudget/domain/repositories/dashboard/goal_repository.dart';
import 'package:mocktail/mocktail.dart';

class MockGoalRemoteDataSource extends Mock implements GoalRemoteDataSource {}

void main() {
  MockGoalRemoteDataSource? mockGoalRemoteDataSource;
  GoalRepositoryImpl? goalRepositoryImpl;

  setUp(() {
    mockGoalRemoteDataSource = MockGoalRemoteDataSource();
    goalRepositoryImpl =
        GoalRepositoryImpl(goalRemoteDataSource: mockGoalRemoteDataSource);
  });
  test(
    'Should be a subclass of GoalRepository entity',
    () async {
      // assert
      expect(goalRepositoryImpl, isA<GoalRepository>());
    },
  );

  group('Update Goals', () {
    test('Should return FetchDataFailure ', () async {
      const goalModel = GoalModel();
      when(() => mockGoalRemoteDataSource!.update(goalModel))
          .thenThrow(EmptyAuthorizationTokenException());
      final goalReceived = await goalRepositoryImpl!.update(goalModel);

      /// Expect an exception to be thrown
      final f = goalReceived.fold<Failure>((f) => f, (_) => GenericFailure());
      verify(() => mockGoalRemoteDataSource!.update(goalModel));
      expect(goalReceived.isLeft(), equals(true));
      expect(f, equals(FetchDataFailure()));
    });
  });

  group('Fetch Goals', () {
    test('Should return FetchDataFailure ', () async {
      when(() => mockGoalRemoteDataSource!.fetch(
          defaultWallet: '',
          endsWithDate: '',
          startsWithDate: '',
          userId: '')).thenThrow(EmptyAuthorizationTokenException());
      final goalReceived = await goalRepositoryImpl!.fetch(
          defaultWallet: '', endsWithDate: '', startsWithDate: '', userId: '');

      /// Expect an exception to be thrown
      final f = goalReceived.fold<Failure>((f) => f, (_) => GenericFailure());
      verify(() => mockGoalRemoteDataSource!.fetch(
          defaultWallet: '', endsWithDate: '', startsWithDate: '', userId: ''));
      expect(goalReceived.isLeft(), equals(true));
      expect(f, equals(FetchDataFailure()));
    });
  });

  group('Add Goal', () {
    test('Should return FetchDataFailure ', () async {
      const addGoalModel = GoalModel();
      when(() => mockGoalRemoteDataSource!.add(addGoalModel))
          .thenThrow(EmptyAuthorizationTokenException());
      final goalReceived = await goalRepositoryImpl!.add(addGoalModel);

      /// Expect an exception to be thrown
      final f = goalReceived.fold<Failure>((f) => f, (_) => GenericFailure());
      verify(() => mockGoalRemoteDataSource!.add(addGoalModel));
      expect(goalReceived.isLeft(), equals(true));
      expect(f, equals(FetchDataFailure()));
    });
  });
}
