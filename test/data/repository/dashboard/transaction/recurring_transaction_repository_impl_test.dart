import 'package:flutter_test/flutter_test.dart';
import 'package:mobile_blitzbudget/core/error/api-exception.dart';
import 'package:mobile_blitzbudget/core/failure/api-failure.dart';
import 'package:mobile_blitzbudget/core/failure/failure.dart';
import 'package:mobile_blitzbudget/core/failure/generic-failure.dart';
import 'package:mobile_blitzbudget/data/datasource/remote/dashboard/transaction/recurring_transaction_remote_data_source.dart';
import 'package:mobile_blitzbudget/data/model/recurring-transaction/recurring_transaction_model.dart';
import 'package:mobile_blitzbudget/data/repositories/dashboard/transaction/recurring_transaction_repository_impl.dart';
import 'package:mobile_blitzbudget/domain/repositories/dashboard/transaction/recurring_transaction_repository.dart';
import 'package:mockito/mockito.dart';

class MockRecurringTransactionRemoteDataSource extends Mock
    implements RecurringTransactionRemoteDataSource {}

void main() {
  MockRecurringTransactionRemoteDataSource
      mockRecurringTransactionRemoteDataSource;
  RecurringTransactionRepositoryImpl recurringTransactionRepositoryImpl;

  setUp(() {
    mockRecurringTransactionRemoteDataSource =
        MockRecurringTransactionRemoteDataSource();
    recurringTransactionRepositoryImpl = RecurringTransactionRepositoryImpl(
        recurringTransactionRemoteDataSource:
            mockRecurringTransactionRemoteDataSource);
  });
  test(
    'Should be a subclass of RecurringTransactionRepository entity',
    () async {
      // assert
      expect(recurringTransactionRepositoryImpl,
          isA<RecurringTransactionRepository>());
    },
  );

  group('Update Recurring Transactions', () {
    test('Should return FetchDataFailure ', () async {
      var recurringTransactionModel = RecurringTransactionModel();
      when(mockRecurringTransactionRemoteDataSource
              .update(recurringTransactionModel))
          .thenThrow(EmptyAuthorizationTokenException());
      var recurringTransactionReceived =
          await recurringTransactionRepositoryImpl
              .update(recurringTransactionModel);

      /// Expect an exception to be thrown
      var f = recurringTransactionReceived.fold<Failure>(
          (f) => f, (_) => GenericFailure());
      verify(mockRecurringTransactionRemoteDataSource
          .update(recurringTransactionModel));
      expect(recurringTransactionReceived.isLeft(), equals(true));
      expect(f, equals(FetchDataFailure()));
    });
  });
}
