import 'package:flutter_test/flutter_test.dart';
import 'package:mobile_blitzbudget/core/error/generic_exception.dart';
import 'package:mobile_blitzbudget/core/persistence/key_value_store_impl.dart';
import 'package:mobile_blitzbudget/data/datasource/local/dashboard/starts_with_date_local_data_source.dart';
import 'package:mocktail/mocktail.dart';
import 'package:matcher/matcher.dart';

class MockKeyValueStoreImpl extends Mock implements KeyValueStoreImpl {}

void main() {
  late StartsWithDateLocalDataSourceImpl dataSource;
  KeyValueStoreImpl? mockKeyValueStoreImpl;
  const startsWithDateCacheName = 'starts_with_date';

  setUp(() {
    mockKeyValueStoreImpl = MockKeyValueStoreImpl();
    dataSource =
        StartsWithDateLocalDataSourceImpl(keyValueStore: mockKeyValueStoreImpl);
  });

  group('Fetch Starts With Date from Key Value Store', () {
    final now = DateTime.now();
    final startsWithDateModel = now.toIso8601String();

    test(
      'Should return Starts With Date from KeyValueStore when there is one in the SharedPreferences',
      () async {
        // arrange
        when(() =>
                mockKeyValueStoreImpl!.getString(key: startsWithDateCacheName))
            .thenAnswer((_) => Future.value(startsWithDateModel));
        // act
        final startsWithDateResult = await dataSource.readStartsWithDate();
        // assert
        verify(() =>
            mockKeyValueStoreImpl!.getString(key: startsWithDateCacheName));
        expect(startsWithDateResult, equals(startsWithDateModel));
      },
    );

    test(
      'Should throw a NoValueInCacheException when there is no value',
      () async {
        // arrange
        when(() =>
                mockKeyValueStoreImpl!.getString(key: startsWithDateCacheName))
            .thenThrow(NoValueInCacheException());
        // assert
        expect(() => dataSource.readStartsWithDate(),
            throwsA(const TypeMatcher<NoValueInCacheException>()));
        // Verify
        verify(() =>
            mockKeyValueStoreImpl!.getString(key: startsWithDateCacheName));
      },
    );
  });

  group('Set Starts with date to KeyValueStore', () {
    final now = DateTime.now();
    final startsWithDateModel = now.toIso8601String();

    test(
      'Should call KeyValueStore to store the data',
      () async {
        // when
        when(() => mockKeyValueStoreImpl!.setString(
            key: startsWithDateCacheName,
            value: startsWithDateModel)).thenAnswer((_) => Future.value());
        // act
        await dataSource.writeStartsWithDate(startsWithDateModel);
        // assert
        verify(() => mockKeyValueStoreImpl!.setString(
            key: startsWithDateCacheName, value: startsWithDateModel));
      },
    );
  });
}
