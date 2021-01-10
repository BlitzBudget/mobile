import 'package:flutter_test/flutter_test.dart';
import 'package:mobile_blitzbudget/core/error/api_exception.dart';
import 'package:mobile_blitzbudget/core/failure/api_failure.dart';
import 'package:mobile_blitzbudget/core/failure/failure.dart';
import 'package:mobile_blitzbudget/core/failure/generic_failure.dart';
import 'package:mobile_blitzbudget/data/datasource/remote/dashboard/wallet_remote_data_source.dart';
import 'package:mobile_blitzbudget/data/model/wallet/wallet_model.dart';
import 'package:mobile_blitzbudget/data/repositories/dashboard/wallet_repository_impl.dart';
import 'package:mobile_blitzbudget/domain/repositories/dashboard/wallet_repository.dart';
import 'package:mockito/mockito.dart';

class MockWalletRemoteDataSource extends Mock
    implements WalletRemoteDataSource {}

void main() {
  MockWalletRemoteDataSource mockWalletRemoteDataSource;
  WalletRepositoryImpl walletRepositoryImpl;

  setUp(() {
    mockWalletRemoteDataSource = MockWalletRemoteDataSource();
    walletRepositoryImpl = WalletRepositoryImpl(
        walletRemoteDataSource: mockWalletRemoteDataSource);
  });
  test(
    'Should be a subclass of WalletRepository entity',
    () async {
      // assert
      expect(walletRepositoryImpl, isA<WalletRepository>());
    },
  );

  group('Fetch Wallets', () {
    test('Should return FetchDataFailure ', () async {
      when(mockWalletRemoteDataSource.fetch(
              defaultWallet: '',
              endsWithDate: '',
              startsWithDate: '',
              userId: ''))
          .thenThrow(EmptyAuthorizationTokenException());
      var walletReceived = await walletRepositoryImpl.fetch(
          defaultWallet: '', endsWithDate: '', startsWithDate: '', userId: '');

      /// Expect an exception to be thrown
      var f = walletReceived.fold<Failure>((f) => f, (_) => GenericFailure());
      verify(mockWalletRemoteDataSource.fetch(
          defaultWallet: '', endsWithDate: '', startsWithDate: '', userId: ''));
      expect(walletReceived.isLeft(), equals(true));
      expect(f, equals(FetchDataFailure()));
    });
  });

  group('Add Wallet', () {
    test('Should return FetchDataFailure ', () async {
      when(mockWalletRemoteDataSource.add(currency: '', userId: ''))
          .thenThrow(EmptyAuthorizationTokenException());
      var walletReceived =
          await walletRepositoryImpl.add(currency: '', userId: '');

      /// Expect an exception to be thrown
      var f = walletReceived.fold<Failure>((f) => f, (_) => GenericFailure());
      verify(mockWalletRemoteDataSource.add(currency: '', userId: ''));
      expect(walletReceived.isLeft(), equals(true));
      expect(f, equals(FetchDataFailure()));
    });
  });

  group('Delete Wallet', () {
    test('Should return FetchDataFailure ', () async {
      when(mockWalletRemoteDataSource.delete(userId: '', walletId: ''))
          .thenThrow(EmptyAuthorizationTokenException());
      var walletReceived =
          await walletRepositoryImpl.delete(userId: '', walletId: '');

      /// Expect an exception to be thrown
      var f = walletReceived.fold<Failure>((f) => f, (_) => GenericFailure());
      verify(mockWalletRemoteDataSource.delete(userId: '', walletId: ''));
      expect(walletReceived.isLeft(), equals(true));
      expect(f, equals(FetchDataFailure()));
    });
  });
}
