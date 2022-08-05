import 'package:flutter_test/flutter_test.dart';
import 'package:mobile_blitzbudget/core/error/api_exception.dart';
import 'package:mobile_blitzbudget/core/failure/api_failure.dart';
import 'package:mobile_blitzbudget/core/failure/failure.dart';
import 'package:mobile_blitzbudget/core/failure/generic_failure.dart';
import 'package:mobile_blitzbudget/data/datasource/remote/dashboard/transaction/transaction_remote_data_source.dart';
import 'package:mobile_blitzbudget/data/model/transaction/transaction_model.dart';
import 'package:mobile_blitzbudget/data/repositories/dashboard/transaction/transaction_repository_impl.dart';
import 'package:mobile_blitzbudget/domain/entities/transaction/transaction.dart';
import 'package:mobile_blitzbudget/domain/repositories/dashboard/transaction/transaction_repository.dart';
import 'package:mocktail/mocktail.dart';

class MockTransactionRemoteDataSource extends Mock
    implements TransactionRemoteDataSource {}

void main() {
  MockTransactionRemoteDataSource? mockTransactionRemoteDataSource;
  TransactionRepositoryImpl? transactionRepositoryImpl;

  setUp(() {
    // Fallback value for Transaction
    registerFallbackValue(const Transaction());
    registerFallbackValue(const TransactionModel());
    mockTransactionRemoteDataSource = MockTransactionRemoteDataSource();
    transactionRepositoryImpl = TransactionRepositoryImpl(
        transactionRemoteDataSource: mockTransactionRemoteDataSource);
  });
  test(
    'Should be a subclass of TransactionRepository entity',
    () async {
      // assert
      expect(transactionRepositoryImpl, isA<TransactionRepository>());
    },
  );

  group('Update Transactions', () {
    test('Should return FetchDataFailure ', () async {
      const transactionModel = TransactionModel();
      when(() => mockTransactionRemoteDataSource!.update(transactionModel))
          .thenThrow(EmptyAuthorizationTokenException());
      final transactionReceived =
          await transactionRepositoryImpl!.update(transactionModel);

      /// Expect an exception to be thrown
      final f =
          transactionReceived.fold<Failure>((f) => f, (_) => GenericFailure());
      verify(() => mockTransactionRemoteDataSource!.update(transactionModel));
      expect(transactionReceived.isLeft(), equals(true));
      expect(f, equals(FetchDataFailure()));
    });
  });

  group('Fetch Transactions', () {
    test('Should return FetchDataFailure ', () async {
      when(() => mockTransactionRemoteDataSource!.fetch(
          defaultWallet: '',
          endsWithDate: '',
          startsWithDate: '',
          userId: '')).thenThrow(EmptyAuthorizationTokenException());
      final transactionReceived = await transactionRepositoryImpl!.fetch(
          defaultWallet: '', endsWithDate: '', startsWithDate: '', userId: '');

      /// Expect an exception to be thrown
      final f =
          transactionReceived.fold<Failure>((f) => f, (_) => GenericFailure());
      verify(() => mockTransactionRemoteDataSource!.fetch(
          defaultWallet: '', endsWithDate: '', startsWithDate: '', userId: ''));
      expect(transactionReceived.isLeft(), equals(true));
      expect(f, equals(FetchDataFailure()));
    });
  });

  group('Add Transactions', () {
    test('Should return FetchDataFailure ', () async {
      const transactionModel = Transaction();
      when(() => mockTransactionRemoteDataSource!.add(any()))
          .thenThrow(EmptyAuthorizationTokenException());
      final transactionReceived =
          await transactionRepositoryImpl!.add(transactionModel);

      /// Expect an exception to be thrown
      final f =
          transactionReceived.fold<Failure>((f) => f, (_) => GenericFailure());
      verify(() => mockTransactionRemoteDataSource!.add(any()));
      expect(transactionReceived.isLeft(), equals(true));
      expect(f, equals(FetchDataFailure()));
    });
  });
}
