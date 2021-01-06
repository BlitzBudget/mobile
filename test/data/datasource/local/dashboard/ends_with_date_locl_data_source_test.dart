import 'package:flutter_test/flutter_test.dart';
import 'package:mobile_blitzbudget/core/error/generic-exception.dart';
import 'package:mobile_blitzbudget/core/persistence/key_value_store_impl.dart';
import 'package:mobile_blitzbudget/data/datasource/local/dashboard/ends_with_date_local_data_source.dart';
import 'package:mockito/mockito.dart';
import 'package:matcher/matcher.dart';

class MockKeyValueStoreImpl extends Mock implements KeyValueStoreImpl {}

void main() {
  EndsWithDateLocalDataSourceImpl dataSource;
  KeyValueStoreImpl mockKeyValueStoreImpl;
  final endsWithDateCacheName = 'ends_with_date';

  setUp(() {
    mockKeyValueStoreImpl = MockKeyValueStoreImpl();
    dataSource =
        EndsWithDateLocalDataSourceImpl(keyValueStore: mockKeyValueStoreImpl);
  });

  group('Fetch Ends With Date from Key Value Store', () {
    var now = DateTime.now();
    var endsWithDateModel = now.toIso8601String();

    test(
      'Should return Ends With Date from KeyValueStore when there is one in the SharedPreferences',
      () async {
        // arrange
        when(mockKeyValueStoreImpl.getString(key: endsWithDateCacheName))
            .thenAnswer((_) => Future.value(endsWithDateModel));
        // act
        final endsWithDateResult = await dataSource.readEndsWithDate();
        // assert
        verify(mockKeyValueStoreImpl.getString(key: endsWithDateCacheName));
        expect(endsWithDateResult, equals(endsWithDateModel));
      },
    );

    test(
      'Should throw a NoValueInCacheException when there is no value',
      () async {
        // arrange
        when(mockKeyValueStoreImpl.getString(key: endsWithDateCacheName))
            .thenThrow(NoValueInCacheException());
        // assert
        expect(() => dataSource.readEndsWithDate(),
            throwsA(TypeMatcher<NoValueInCacheException>()));
      },
    );
  });

  group('Set Ends with date to KeyValueStore', () {
    var now = DateTime.now();
    var endsWithDateModel = now.toIso8601String();

    test(
      'Should call KeyValueStore to store the data',
      () async {
        // act
        await dataSource.writeEndsWithDate(endsWithDateModel);
        // assert
        verify(mockKeyValueStoreImpl.setString(
            key: endsWithDateCacheName, value: endsWithDateModel));
      },
    );
  });
}
