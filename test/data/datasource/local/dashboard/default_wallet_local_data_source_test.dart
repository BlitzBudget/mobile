import 'package:flutter_test/flutter_test.dart';
import 'package:mobile_blitzbudget/core/error/generic-exception.dart';
import 'package:mobile_blitzbudget/core/persistence/key_value_store_impl.dart';
import 'package:mobile_blitzbudget/data/datasource/local/dashboard/default_wallet_local_data_source.dart';
import 'package:mockito/mockito.dart';
import 'package:matcher/matcher.dart';

class MockKeyValueStoreImpl extends Mock implements KeyValueStoreImpl {}

void main() {
  DefaultWalletLocalDataSourceImpl dataSource;
  KeyValueStoreImpl mockKeyValueStoreImpl;
  final defaultWalletCacheName = 'default_wallet';

  setUp(() {
    mockKeyValueStoreImpl = MockKeyValueStoreImpl();
    dataSource =
        DefaultWalletLocalDataSourceImpl(keyValueStore: mockKeyValueStoreImpl);
  });

  group('Fetch Ends With Date from Key Value Store', () {
    var now = DateTime.now();
    var defaultWalletModel = now.toIso8601String();

    test(
      'Should return Ends With Date from KeyValueStore when there is one in the SharedPreferences',
      () async {
        // arrange
        when(mockKeyValueStoreImpl.getString(key: defaultWalletCacheName))
            .thenAnswer((_) => Future.value(defaultWalletModel));
        // act
        final defaultWalletResult = await dataSource.readDefaultWallet();
        // assert
        verify(mockKeyValueStoreImpl.getString(key: defaultWalletCacheName));
        expect(defaultWalletResult, equals(defaultWalletModel));
      },
    );

    test(
      'Should throw a NoValueInCacheException when there is no value',
      () async {
        // arrange
        when(mockKeyValueStoreImpl.getString(key: defaultWalletCacheName))
            .thenThrow(NoValueInCacheException());
        // assert
        expect(() => dataSource.readDefaultWallet(),
            throwsA(TypeMatcher<NoValueInCacheException>()));
      },
    );
  });

  group('Set Ends with date to KeyValueStore', () {
    var now = DateTime.now();
    var defaultWalletModel = now.toIso8601String();

    test(
      'Should call KeyValueStore to store the data',
      () async {
        // act
        await dataSource.writeDefaultWallet(defaultWalletModel);
        // assert
        verify(mockKeyValueStoreImpl.setString(
            key: defaultWalletCacheName, value: defaultWalletModel));
      },
    );
  });
}
