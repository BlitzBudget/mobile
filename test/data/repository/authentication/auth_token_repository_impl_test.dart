import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import 'package:mobile_blitzbudget/core/error/generic_exception.dart';
import 'package:mobile_blitzbudget/core/failure/failure.dart';
import 'package:mobile_blitzbudget/core/failure/generic_failure.dart';
import 'package:mobile_blitzbudget/data/datasource/local/authentication/auth_token_local_data_source.dart';
import 'package:mobile_blitzbudget/data/repositories/authentication/auth_token_repository_impl.dart';
import 'package:mobile_blitzbudget/domain/entities/response/user_response.dart';
import 'package:mobile_blitzbudget/domain/repositories/authentication/auth_token_repository.dart';
import 'package:mocktail/mocktail.dart';

import '../../../fixtures/fixture_reader.dart';

class MockAuthTokenLocalDataSource extends Mock
    implements AuthTokenLocalDataSource {}

void main() {
  MockAuthTokenLocalDataSource? mockAuthTokenLocalDataSource;
  AuthTokenRepositoryImpl? authTokenRepositoryImpl;

  setUp(() {
    mockAuthTokenLocalDataSource = MockAuthTokenLocalDataSource();
    authTokenRepositoryImpl = AuthTokenRepositoryImpl(
        authTokenLocalDataSource: mockAuthTokenLocalDataSource);
  });
  test(
    'Should be a subclass of AuthTokenRepository entity',
    () async {
      // assert
      expect(authTokenRepositoryImpl, isA<AuthTokenRepository>());
    },
  );

  group('Read Auth Token', () {
    test('Should return No Value in Cache Exception', () async {
      when(() => mockAuthTokenLocalDataSource!.readAuthToken())
          .thenThrow(NoValueInCacheException());
      final authTokenReceived = await authTokenRepositoryImpl!.readAuthToken();

      /// Expect an exception to be thrown
      final f =
          authTokenReceived.fold<Failure>((f) => f, (_) => GenericFailure());
      verify(() => mockAuthTokenLocalDataSource!.readAuthToken());
      expect(authTokenReceived.isLeft(), equals(true));
      expect(f, equals(EmptyResponseFailure()));
    });
  });

  group('Write Auth Token', () {
    test('Should write auth token', () async {
      final userModelAsString =
          fixture('responses/authentication/login_info.json');
      final userModelAsJSON = jsonDecode(userModelAsString);
      final authToken = userModelAsJSON['AuthenticationResult']['IdToken'];
      final userModel = UserResponse(authenticationToken: authToken);
      await authTokenRepositoryImpl!.writeAuthToken(userModel);

      verify(() => mockAuthTokenLocalDataSource!.writeAuthToken(authToken));
    });
  });
}
