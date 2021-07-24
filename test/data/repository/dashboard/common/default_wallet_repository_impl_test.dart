import 'package:flutter_test/flutter_test.dart';
import 'package:mobile_blitzbudget/core/error/generic_exception.dart';
import 'package:mobile_blitzbudget/core/failure/generic_failure.dart';
import 'package:mobile_blitzbudget/data/datasource/local/dashboard/default_wallet_local_data_source.dart';
import 'package:mobile_blitzbudget/data/repositories/dashboard/common/default_wallet_repository_impl.dart';
import 'package:mobile_blitzbudget/domain/repositories/dashboard/common/default_wallet_repository.dart';
import 'package:mocktail/mocktail.dart';

class MockDefaultWalletLocalDataSourceImpl extends Mock
    implements DefaultWalletLocalDataSourceImpl {}

void main() {
  late MockDefaultWalletLocalDataSourceImpl
      mockDefaultWalletLocalDataSourceImpl;
  late DefaultWalletRepositoryImpl defaultWalletRepositoryImpl;
  const walletId = 'Wallet#2020-12-21T20:35:49.295Z';

  setUp(() {
    mockDefaultWalletLocalDataSourceImpl =
        MockDefaultWalletLocalDataSourceImpl();
    defaultWalletRepositoryImpl = DefaultWalletRepositoryImpl(
        defaultWalletLocalDataSource: mockDefaultWalletLocalDataSourceImpl);
  });
  test(
    'Should be a subclass of DefaultWallet entity',
    () async {
      // assert
      expect(defaultWalletRepositoryImpl, isA<DefaultWalletRepository>());
    },
  );

  group('Read Default Wallet', () {
    test('Throw a Failure when no value is found', () async {
      when(() => mockDefaultWalletLocalDataSourceImpl.readDefaultWallet())
          .thenThrow(NoValueInCacheException());
      final defaultWallet =
          await defaultWalletRepositoryImpl.readDefaultWallet();
      verify(() => mockDefaultWalletLocalDataSourceImpl.readDefaultWallet());
      final f =
          defaultWallet.fold((failure) => failure, (_) => GenericFailure());
      expect(f, equals(EmptyResponseFailure()));
    });
  });

  group('Write Default Wallet', () {
    test('Throw a Failure when no value is found', () async {
      when(() =>
              mockDefaultWalletLocalDataSourceImpl.writeDefaultWallet(walletId))
          .thenAnswer((_) => Future.value());
      await defaultWalletRepositoryImpl.writeDefaultWallet(walletId);
      verify(() =>
          mockDefaultWalletLocalDataSourceImpl.writeDefaultWallet(walletId));
    });
  });
}
