import 'package:flutter_test/flutter_test.dart';
import 'package:mobile_blitzbudget/core/error/api-exception.dart';
import 'package:mobile_blitzbudget/core/failure/api-failure.dart';
import 'package:mobile_blitzbudget/core/failure/failure.dart';
import 'package:mobile_blitzbudget/core/failure/generic-failure.dart';
import 'package:mobile_blitzbudget/data/datasource/remote/dashboard/bank_account_remote_data_source.dart';
import 'package:mobile_blitzbudget/data/model/bank-account/bank_account_model.dart';
import 'package:mobile_blitzbudget/data/repositories/dashboard/bank_account_repository_impl.dart';
import 'package:mobile_blitzbudget/domain/repositories/dashboard/bank_account_repository.dart';
import 'package:mockito/mockito.dart';

class MockBankAccountRemoteDataSource extends Mock
    implements BankAccountRemoteDataSource {}

void main() {
  MockBankAccountRemoteDataSource mockBankAccountRemoteDataSource;
  BankAccountRepositoryImpl bankAccountRepositoryImpl;

  setUp(() {
    mockBankAccountRemoteDataSource = MockBankAccountRemoteDataSource();
    bankAccountRepositoryImpl = BankAccountRepositoryImpl(
        bankAccountRemoteDataSource: mockBankAccountRemoteDataSource);
  });
  test(
    'Should be a subclass of BankAccountRepository entity',
    () async {
      // assert
      expect(bankAccountRepositoryImpl, isA<BankAccountRepository>());
    },
  );

  group('Update BankAccounts', () {
    test('Should return FetchDataFailure ', () async {
      var bankAccountModel = BankAccountModel();
      when(mockBankAccountRemoteDataSource.update(bankAccountModel))
          .thenThrow(EmptyAuthorizationTokenException());
      var bankAccountReceived =
          await bankAccountRepositoryImpl.update(bankAccountModel);

      /// Expect an exception to be thrown
      var f =
          bankAccountReceived.fold<Failure>((f) => f, (_) => GenericFailure());
      verify(mockBankAccountRemoteDataSource.update(bankAccountModel));
      expect(bankAccountReceived.isLeft(), equals(true));
      expect(f, equals(FetchDataFailure()));
    });
  });

  group('Delete Bank Account', () {
    test('Should return FetchDataFailure ', () async {
      when(mockBankAccountRemoteDataSource.delete(account: '', walletId: ''))
          .thenThrow(EmptyAuthorizationTokenException());
      var bankAccountReceived =
          await bankAccountRepositoryImpl.delete(account: '', walletId: '');

      /// Expect an exception to be thrown
      var f =
          bankAccountReceived.fold<Failure>((f) => f, (_) => GenericFailure());
      verify(mockBankAccountRemoteDataSource.delete(account: '', walletId: ''));
      expect(bankAccountReceived.isLeft(), equals(true));
      expect(f, equals(FetchDataFailure()));
    });
  });

  group('Add Bank Account', () {
    test('Should return FetchDataFailure ', () async {
      var addBankAccountModel = BankAccountModel();
      when(mockBankAccountRemoteDataSource.add(addBankAccountModel))
          .thenThrow(EmptyAuthorizationTokenException());
      var bankAccountReceived =
          await bankAccountRepositoryImpl.add(addBankAccountModel);

      /// Expect an exception to be thrown
      var f =
          bankAccountReceived.fold<Failure>((f) => f, (_) => GenericFailure());
      verify(mockBankAccountRemoteDataSource.add(addBankAccountModel));
      expect(bankAccountReceived.isLeft(), equals(true));
      expect(f, equals(FetchDataFailure()));
    });
  });
}
