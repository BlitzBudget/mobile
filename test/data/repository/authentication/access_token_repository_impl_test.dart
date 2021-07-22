import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import 'package:mobile_blitzbudget/core/error/generic_exception.dart';
import 'package:mobile_blitzbudget/core/failure/failure.dart';
import 'package:mobile_blitzbudget/core/failure/generic_failure.dart';
import 'package:mobile_blitzbudget/data/datasource/local/authentication/access_token_local_data_source.dart';
import 'package:mobile_blitzbudget/data/repositories/authentication/access_token_repository_impl.dart';
import 'package:mobile_blitzbudget/domain/entities/response/user_response.dart';
import 'package:mobile_blitzbudget/domain/repositories/authentication/access_token_repository.dart';
import 'package:mocktail/mocktail.dart';

import '../../../fixtures/fixture_reader.dart';

class MockAccessTokenLocalDataSource extends Mock
    implements AccessTokenLocalDataSource {}

void main() {
  MockAccessTokenLocalDataSource? mockAccessTokenLocalDataSource;
  AccessTokenRepositoryImpl? accessTokenRepositoryImpl;

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
      when(() => mockAccessTokenLocalDataSource!.readAccessToken())
          .thenThrow(NoValueInCacheException());
      final accessTokenReceived =
          await accessTokenRepositoryImpl!.readAccessToken();

      /// Expect an exception to be thrown
      final f =
          accessTokenReceived.fold<Failure>((f) => f, (_) => GenericFailure());
      verify(() => mockAccessTokenLocalDataSource!.readAccessToken());
      expect(accessTokenReceived.isLeft(), equals(true));
      expect(f, equals(EmptyResponseFailure()));
    });
  });

  group('Write Access Token', () {
    test('Should write access token', () async {
      final userModelAsString =
          fixture('responses/authentication/login_info.json');
      final userModelAsJSON = jsonDecode(userModelAsString);
      final accessToken =
          userModelAsJSON['AuthenticationResult']['AccessToken'];
      final userModel = UserResponse(
          accessToken: userModelAsJSON['AuthenticationResult']['AccessToken']);

      when(() => mockAccessTokenLocalDataSource!.writeAccessToken(accessToken))
          .thenAnswer((_) => Future.value());

      await accessTokenRepositoryImpl!.writeAccessToken(userModel);

      verify(
          () => mockAccessTokenLocalDataSource!.writeAccessToken(accessToken));
    });
  });
}
