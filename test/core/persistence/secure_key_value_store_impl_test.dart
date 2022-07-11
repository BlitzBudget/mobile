import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mobile_blitzbudget/core/error/generic_exception.dart';
import 'package:mobile_blitzbudget/core/persistence/secure_key_value_store_impl.dart';
import 'package:mocktail/mocktail.dart';

class MockFlutterSecureStorage extends Mock implements FlutterSecureStorage {}

void main() {
  late SecureKeyValueStoreImpl secureKeyValueStoreImpl;
  MockFlutterSecureStorage? mockFlutterSecureStorage;

  setUp(() {
    mockFlutterSecureStorage = MockFlutterSecureStorage();
    secureKeyValueStoreImpl =
        SecureKeyValueStoreImpl(flutterSecureStorage: mockFlutterSecureStorage);
  });

  group('GET: Key Value Store Impl', () {
    test('Should throw NoValueInCacheException if empty', () async {
      when(() => mockFlutterSecureStorage!.read(key: 'sharedPreferences'))
          .thenAnswer((_) => Future.value());

      expect(() => secureKeyValueStoreImpl.getString(key: 'sharedPreferences'),
          throwsA(const TypeMatcher<NoValueInCacheException>()));
    });

    test('Should return a string if not empty', () async {
      when(() => mockFlutterSecureStorage!.read(key: 'sharedPreferences'))
          .thenAnswer((_) => Future.value('valueAsString'));

      final valueAsString =
          await secureKeyValueStoreImpl.getString(key: 'sharedPreferences');
      expect(valueAsString, equals('valueAsString'));
    });
  });

  group('WRITE: Key Value Store Impl', () {
    test('Should write a string', () async {
      when(() => mockFlutterSecureStorage!.write(
          key: 'sharedPreferences',
          value: 'valueAsString')).thenAnswer((_) => Future.value());

      await secureKeyValueStoreImpl.setString(
          key: 'sharedPreferences', value: 'valueAsString');

      verify(() => mockFlutterSecureStorage!
          .write(key: 'sharedPreferences', value: 'valueAsString'));
    });
  });
}
