import 'package:flutter_test/flutter_test.dart';
import 'package:mobile_blitzbudget/core/error/api_exception.dart';
import 'package:mobile_blitzbudget/core/failure/api_failure.dart';
import 'package:mobile_blitzbudget/core/failure/failure.dart';
import 'package:mobile_blitzbudget/core/failure/generic_failure.dart';
import 'package:mobile_blitzbudget/data/datasource/remote/dashboard/budget_remote_data_source.dart';
import 'package:mobile_blitzbudget/data/model/budget/budget_model.dart';
import 'package:mobile_blitzbudget/data/repositories/dashboard/budget_repository_impl.dart';
import 'package:mobile_blitzbudget/domain/repositories/dashboard/budget_repository.dart';
import 'package:mocktail/mocktail.dart';

class MockBudgetRemoteDataSource extends Mock
    implements BudgetRemoteDataSource {}

void main() {
  MockBudgetRemoteDataSource? mockBudgetRemoteDataSource;
  BudgetRepositoryImpl? budgetRepositoryImpl;

  setUp(() {
    mockBudgetRemoteDataSource = MockBudgetRemoteDataSource();
    budgetRepositoryImpl = BudgetRepositoryImpl(
        budgetRemoteDataSource: mockBudgetRemoteDataSource);
  });
  test(
    'Should be a subclass of BudgetRepository entity',
    () async {
      // assert
      expect(budgetRepositoryImpl, isA<BudgetRepository>());
    },
  );

  group('Update Budgets', () {
    test('Should return FetchDataFailure ', () async {
      const budgetModel = BudgetModel();
      when(() => mockBudgetRemoteDataSource!.update(budgetModel))
          .thenThrow(EmptyAuthorizationTokenException());
      final budgetReceived = await budgetRepositoryImpl!.update(budgetModel);

      /// Expect an exception to be thrown
      final f = budgetReceived.fold<Failure>((f) => f, (_) => GenericFailure());
      verify(() => mockBudgetRemoteDataSource!.update(budgetModel));
      expect(budgetReceived.isLeft(), equals(true));
      expect(f, equals(FetchDataFailure()));
    });
  });

  group('Fetch Budgets', () {
    test('Should return FetchDataFailure ', () async {
      when(() => mockBudgetRemoteDataSource!.fetch(
          defaultWallet: '',
          endsWithDate: '',
          startsWithDate: '',
          userId: '')).thenThrow(EmptyAuthorizationTokenException());
      final budgetReceived = await budgetRepositoryImpl!.fetch(
          defaultWallet: '', endsWithDate: '', startsWithDate: '', userId: '');

      /// Expect an exception to be thrown
      final f = budgetReceived.fold<Failure>((f) => f, (_) => GenericFailure());
      verify(() => mockBudgetRemoteDataSource!.fetch(
          defaultWallet: '', endsWithDate: '', startsWithDate: '', userId: ''));
      expect(budgetReceived.isLeft(), equals(true));
      expect(f, equals(FetchDataFailure()));
    });
  });

  group('Add Budget', () {
    test('Should return FetchDataFailure ', () async {
      const addBudgetModel = BudgetModel();
      when(() => mockBudgetRemoteDataSource!.add(addBudgetModel))
          .thenThrow(EmptyAuthorizationTokenException());
      final budgetReceived = await budgetRepositoryImpl!.add(addBudgetModel);

      /// Expect an exception to be thrown
      final f = budgetReceived.fold<Failure>((f) => f, (_) => GenericFailure());
      verify(() => mockBudgetRemoteDataSource!.add(addBudgetModel));
      expect(budgetReceived.isLeft(), equals(true));
      expect(f, equals(FetchDataFailure()));
    });
  });
}
