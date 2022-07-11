import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import 'package:mobile_blitzbudget/core/error/generic_exception.dart';
import 'package:mobile_blitzbudget/core/persistence/secure_key_value_store_impl.dart';
import 'package:mobile_blitzbudget/data/datasource/local/authentication/user_attributes_local_data_source.dart';
import 'package:mocktail/mocktail.dart';

import '../../../../fixtures/fixture_reader.dart';

class MockSecureKeyValueStoreImpl extends Mock
    implements SecureKeyValueStoreImpl {}

void main() {
  late UserAttributesLocalDataSourceImpl dataSource;
  SecureKeyValueStoreImpl? mockSecureKeyValueStoreImpl;
  const userAttributesCacheName = 'user_attributes';
  final loginResponseAsString =
      fixture('responses/authentication/login_info.json');
  final userAttributesAsMap =
      jsonDecode(loginResponseAsString)['UserAttributes'];
  final userAttributeAsString = jsonEncode(userAttributesAsMap);

  setUp(() {
    mockSecureKeyValueStoreImpl = MockSecureKeyValueStoreImpl();
    dataSource = UserAttributesLocalDataSourceImpl(
        secureKeyValueStore: mockSecureKeyValueStoreImpl);
  });

  group('Fetch UserAttributes from Key Value Store', () {
    test(
      'Should return UserAttributes from SecureKeyValueStore when there is one in the SharedPreferences',
      () async {
        // arrange
        when(() => mockSecureKeyValueStoreImpl!
                .getString(key: userAttributesCacheName))
            .thenAnswer((_) => Future.value(userAttributeAsString));
        // act
        final userAttributesResult = await dataSource.readUserAttributes();
        // assert
        verify(() => mockSecureKeyValueStoreImpl!
            .getString(key: userAttributesCacheName));
        expect(userAttributesResult, equals(userAttributeAsString));
      },
    );

    test(
      'Should throw a NoValueInCacheException when there is no value',
      () async {
        // arrange
        when(() => mockSecureKeyValueStoreImpl!.getString(
            key: userAttributesCacheName)).thenThrow(NoValueInCacheException());
        // assert
        expect(() => dataSource.readUserAttributes(),
            throwsA(const TypeMatcher<NoValueInCacheException>()));
      },
    );
  });

  group('Set UserAttributes to SecureKeyValueStore', () {
    test(
      'Should call SecureKeyValueStore to store the data',
      () async {
        // when
        when(() => mockSecureKeyValueStoreImpl!.setString(
            key: userAttributesCacheName,
            value: userAttributeAsString)).thenAnswer((_) => Future.value());
        // act
        await dataSource.writeUserAttributes(userAttributeAsString);
        // assert
        verify(() => mockSecureKeyValueStoreImpl!.setString(
            key: userAttributesCacheName, value: userAttributeAsString));
      },
    );
  });
}
