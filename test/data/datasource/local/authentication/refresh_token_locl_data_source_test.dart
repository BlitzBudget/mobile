import 'package:flutter_test/flutter_test.dart';
import 'package:mobile_blitzbudget/core/error/generic-exception.dart';
import 'package:mobile_blitzbudget/core/persistence/secure_key_value_store_impl.dart';
import 'package:mobile_blitzbudget/data/datasource/local/authentication/refresh_token_local_data_source.dart';
import 'package:mockito/mockito.dart';
import 'package:matcher/matcher.dart';

class MockSecureKeyValueStoreImpl extends Mock
    implements SecureKeyValueStoreImpl {}

void main() {
  RefreshTokenLocalDataSourceImpl dataSource;
  SecureKeyValueStoreImpl mockSecureKeyValueStoreImpl;
  final refreshTokenCacheName = 'refresh_token';
  final refreshTokenValue =
      'eyJraWQiOiJ5UG14MUFmdzFZa0U4ZHZ3YlgxcjUwMitmOTM1NGM1ZURZUmlcL3RxQ296VT0iLCJhbGciOiJSUzI1NiJ9.eyJzdWIiOiI1OTMxMmUyYS00OGQ1LTQyOTctYWJiOC1lOGI1M2E0M2EyZGUiLCJldmVudF9pZCI6IjdlMTRmZGViLWMyODEtNDZlMC1hM2EwLTU4ZTM1ZDY0NzQyZCIsInRva2VuX3VzZSI6ImFjY2VzcyIsInNjb3BlIjoiYXdzLmNvZ25pdG8uc2lnbmluLnVzZXIuYWRtaW4iLCJhdXRoX3RpbWUiOjE2MDk3NzM0MjAsImlzcyI6Imh0dHBzOlwvXC9jb2duaXRvLWlkcC5ldS13ZXN0LTEuYW1hem9uYXdzLmNvbVwvZXUtd2VzdC0xX2NqZkM4cU5pQiIsImV4cCI6MTYwOTc3NzAyMCwiaWF0IjoxNjA5NzczNDIwLCJqdGkiOiIxN2EzMjM0Yy0xMWZkLTRhNDItYWIzYi05MGVhM2VhOWI3M2IiLCJjbGllbnRfaWQiOiIyZnRsYnMxa2ZtcjJ1YjBlNHAxNXRzYWc4ZyIsInVzZXJuYW1lIjoibmFnYXJqdW5fbmFnZXNoQG91dGxvb2suY29tIn0.npmtjthQi53SSX9R2xRzuOEcsXXyD-YuQsdGwOoscbfg-f1HJ7-4SJH7KZFzUTTerQXli-82nlr9OeCoG7gWf0SSXim1O7pw2HiT5zLkmNETY-AH2uuTfJheqx85QHl55qiFfK9PfrP7JBoxb0YPYkGoquD1vR1rtEjXtXasYNknM8FyKxfr35fCW1CBFLdwPdp-5QKYh_ahIf3EVsDB7qD9-j3AvkYTAwSAhwuPAFRAcRTXRNc8XdX7sfIvFRcul4tVENdqNF5Im0bUPfWkuvaINbaRRL6gX_0Syjlfe4tzTNKXT3Xz4_CxqH5lSJOHwivcYecv7XQrDljewjNBCQ';

  setUp(() {
    mockSecureKeyValueStoreImpl = MockSecureKeyValueStoreImpl();
    dataSource = RefreshTokenLocalDataSourceImpl(
        secureKeyValueStore: mockSecureKeyValueStoreImpl);
  });

  group('Fetch RefreshToken from Key Value Store', () {
    test(
      'Should return RefreshToken from SecureKeyValueStore when there is one in the SharedPreferences',
      () async {
        // arrange
        when(mockSecureKeyValueStoreImpl.getString(key: refreshTokenCacheName))
            .thenAnswer((_) => Future.value(refreshTokenValue));
        // act
        final refreshTokenResult = await dataSource.readRefreshToken();
        // assert
        verify(
            mockSecureKeyValueStoreImpl.getString(key: refreshTokenCacheName));
        expect(refreshTokenResult, equals(refreshTokenValue));
      },
    );

    test(
      'Should throw a NoValueInCacheException when there is no value',
      () async {
        // arrange
        when(mockSecureKeyValueStoreImpl.getString(key: refreshTokenCacheName))
            .thenThrow(NoValueInCacheException());
        // assert
        expect(() => dataSource.readRefreshToken(),
            throwsA(TypeMatcher<NoValueInCacheException>()));
      },
    );
  });

  group('Set RefreshToken to SecureKeyValueStore', () {
    test(
      'Should call SecureKeyValueStore to store the data',
      () async {
        // act
        await dataSource.writeRefreshToken(refreshTokenValue);
        // assert
        verify(mockSecureKeyValueStoreImpl.setString(
            key: refreshTokenCacheName, value: refreshTokenValue));
      },
    );
  });
}
