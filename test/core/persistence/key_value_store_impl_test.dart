import 'package:flutter_test/flutter_test.dart';
import 'package:mobile_blitzbudget/core/error/generic_exception.dart';
import 'package:mobile_blitzbudget/core/persistence/key_value_store_impl.dart';
import 'package:mocktail/mocktail.dart';
import 'package:shared_preferences/shared_preferences.dart';

class MockSharedPreferences extends Mock implements SharedPreferences {}

void main() {
  late KeyValueStoreImpl keyValueStoreImpl;
  MockSharedPreferences? mockSharedPreferences;

  setUp(() {
    mockSharedPreferences = MockSharedPreferences();
    keyValueStoreImpl =
        KeyValueStoreImpl(sharedPreferences: mockSharedPreferences);
  });

  group('GET: Key Value Store Impl', () {
    test('Should throw NoValueInCacheException if empty', () async {
      expect(() => keyValueStoreImpl.getString(key: 'sharedPreferences'),
          throwsA(const TypeMatcher<NoValueInCacheException>()));
    });

    test('Should return a string if not empty', () async {
      when(() => mockSharedPreferences!.getString('sharedPreferences'))
          .thenAnswer((_) => 'valueAsString');

      final valueAsString =
          await keyValueStoreImpl.getString(key: 'sharedPreferences');
      expect(valueAsString, equals('valueAsString'));
    });
  });

  group('WRITE: Key Value Store Impl', () {
    test('Should write a string', () async {
      when(() => mockSharedPreferences!
              .setString('sharedPreferences', 'valueAsString'))
          .thenAnswer((_) => Future.value(true));

      await keyValueStoreImpl.setString(
          key: 'sharedPreferences', value: 'valueAsString');

      verify(() => mockSharedPreferences!
          .setString('sharedPreferences', 'valueAsString'));
    });
  });
}
