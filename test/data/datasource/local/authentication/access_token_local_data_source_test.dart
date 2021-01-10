import 'package:flutter_test/flutter_test.dart';
import 'package:mobile_blitzbudget/core/error/generic_exception.dart';
import 'package:mobile_blitzbudget/core/persistence/secure_key_value_store_impl.dart';
import 'package:mobile_blitzbudget/data/datasource/local/authentication/access_token_local_data_source.dart';
import 'package:mockito/mockito.dart';
import 'package:matcher/matcher.dart';

class MockSecureKeyValueStoreImpl extends Mock
    implements SecureKeyValueStoreImpl {}

void main() {
  AccessTokenLocalDataSourceImpl dataSource;
  SecureKeyValueStoreImpl mockSecureKeyValueStoreImpl;
  final accessTokenCacheName = 'access_token';
  final accessTokenValue =
      'eyJraWQiOiJ5UG14MUFmdzFZa0U4ZHZ3YlgxcjUwMitmOTM1NGM1ZURZUmlcL3RxQ296VT0iLCJhbGciOiJSUzI1NiJ9.eyJzdWIiOiI1OTMxMmUyYS00OGQ1LTQyOTctYWJiOC1lOGI1M2E0M2EyZGUiLCJldmVudF9pZCI6IjdlMTRmZGViLWMyODEtNDZlMC1hM2EwLTU4ZTM1ZDY0NzQyZCIsInRva2VuX3VzZSI6ImFjY2VzcyIsInNjb3BlIjoiYXdzLmNvZ25pdG8uc2lnbmluLnVzZXIuYWRtaW4iLCJhdXRoX3RpbWUiOjE2MDk3NzM0MjAsImlzcyI6Imh0dHBzOlwvXC9jb2duaXRvLWlkcC5ldS13ZXN0LTEuYW1hem9uYXdzLmNvbVwvZXUtd2VzdC0xX2NqZkM4cU5pQiIsImV4cCI6MTYwOTc3NzAyMCwiaWF0IjoxNjA5NzczNDIwLCJqdGkiOiIxN2EzMjM0Yy0xMWZkLTRhNDItYWIzYi05MGVhM2VhOWI3M2IiLCJjbGllbnRfaWQiOiIyZnRsYnMxa2ZtcjJ1YjBlNHAxNXRzYWc4ZyIsInVzZXJuYW1lIjoibmFnYXJqdW5fbmFnZXNoQG91dGxvb2suY29tIn0.npmtjthQi53SSX9R2xRzuOEcsXXyD-YuQsdGwOoscbfg-f1HJ7-4SJH7KZFzUTTerQXli-82nlr9OeCoG7gWf0SSXim1O7pw2HiT5zLkmNETY-AH2uuTfJheqx85QHl55qiFfK9PfrP7JBoxb0YPYkGoquD1vR1rtEjXtXasYNknM8FyKxfr35fCW1CBFLdwPdp-5QKYh_ahIf3EVsDB7qD9-j3AvkYTAwSAhwuPAFRAcRTXRNc8XdX7sfIvFRcul4tVENdqNF5Im0bUPfWkuvaINbaRRL6gX_0Syjlfe4tzTNKXT3Xz4_CxqH5lSJOHwivcYecv7XQrDljewjNBCQ';

  setUp(() {
    mockSecureKeyValueStoreImpl = MockSecureKeyValueStoreImpl();
    dataSource = AccessTokenLocalDataSourceImpl(
        secureKeyValueStore: mockSecureKeyValueStoreImpl);
  });

  group('Fetch AccessToken from Key Value Store', () {
    test(
      'Should return AccessToken from SecureKeyValueStore when there is one in the SharedPreferences',
      () async {
        // arrange
        when(mockSecureKeyValueStoreImpl.getString(key: accessTokenCacheName))
            .thenAnswer((_) => Future.value(accessTokenValue));
        // act
        final accessTokenResult = await dataSource.readAccessToken();
        // assert
        verify(
            mockSecureKeyValueStoreImpl.getString(key: accessTokenCacheName));
        expect(accessTokenResult, equals(accessTokenValue));
      },
    );

    test(
      'Should throw a NoValueInCacheException when there is no value',
      () async {
        // arrange
        when(mockSecureKeyValueStoreImpl.getString(key: accessTokenCacheName))
            .thenThrow(NoValueInCacheException());
        // assert
        expect(() => dataSource.readAccessToken(),
            throwsA(TypeMatcher<NoValueInCacheException>()));
      },
    );
  });

  group('Set AccessToken to SecureKeyValueStore', () {
    test(
      'Should call SecureKeyValueStore to store the data',
      () async {
        // act
        await dataSource.writeAccessToken(accessTokenValue);
        // assert
        verify(mockSecureKeyValueStoreImpl.setString(
            key: accessTokenCacheName, value: accessTokenValue));
      },
    );
  });
}
