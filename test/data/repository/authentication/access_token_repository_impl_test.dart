import 'package:flutter_test/flutter_test.dart';
import 'package:mobile_blitzbudget/core/error/generic-exception.dart';
import 'package:mobile_blitzbudget/core/failure/failure.dart';
import 'package:mobile_blitzbudget/core/failure/generic-failure.dart';
import 'package:mobile_blitzbudget/data/datasource/local/authentication/access_token_local_data_source.dart';
import 'package:mobile_blitzbudget/data/repositories/authentication/access_token_repository_impl.dart';
import 'package:mobile_blitzbudget/domain/repositories/authentication/access_token_repository.dart';
import 'package:mockito/mockito.dart';

class MockAccessTokenLocalDataSource extends Mock
    implements AccessTokenLocalDataSource {}

void main() {
  MockAccessTokenLocalDataSource mockAccessTokenLocalDataSource;
  AccessTokenRepositoryImpl accessTokenRepositoryImpl;

  setUp(() {
    mockAccessTokenLocalDataSource = MockAccessTokenLocalDataSource();
    accessTokenRepositoryImpl = AccessTokenRepositoryImpl(
        accessTokenLocalDataSource: mockAccessTokenLocalDataSource);
  });
  test(
    'Should be a subclass of AccessTokenRepository entity',
    () async {
      // assert
      expect(accessTokenRepositoryImpl, isA<AccessTokenRepository>());
    },
  );

  group('Read Access Token', () {
    test('Should return No Value in Cache Exception', () async {
      when(mockAccessTokenLocalDataSource.readAccessToken())
          .thenThrow(NoValueInCacheException());
      var accessTokenReceived =
          await accessTokenRepositoryImpl.readAccessToken();

      /// Expect an exception to be thrown
      var f =
          accessTokenReceived.fold<Failure>((f) => f, (_) => GenericFailure());
      verify(mockAccessTokenLocalDataSource.readAccessToken());
      expect(accessTokenReceived.isLeft(), equals(true));
      expect(f, equals(EmptyResponseFailure()));
    });
  });
}
