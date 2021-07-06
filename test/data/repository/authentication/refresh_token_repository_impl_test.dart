import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import 'package:mobile_blitzbudget/core/error/generic_exception.dart';
import 'package:mobile_blitzbudget/core/failure/failure.dart';
import 'package:mobile_blitzbudget/core/failure/generic_failure.dart';
import 'package:mobile_blitzbudget/data/datasource/local/authentication/refresh_token_local_data_source.dart';
import 'package:mobile_blitzbudget/data/repositories/authentication/refresh_token_repository_impl.dart';
import 'package:mobile_blitzbudget/domain/entities/response/user_response.dart';
import 'package:mobile_blitzbudget/domain/repositories/authentication/refresh_token_repository.dart';

import 'package:mockito/mockito.dart';

import '../../../fixtures/fixture_reader.dart';

class MockRefreshTokenLocalDataSource extends Mock
    implements RefreshTokenLocalDataSource {}

void main() {
  MockRefreshTokenLocalDataSource mockRefreshTokenLocalDataSource;
  RefreshTokenRepositoryImpl refreshTokenRepositoryImpl;

  final userModelAsString = fixture('responses/authentication/login_info.json');
  final userModelAsJSON = jsonDecode(userModelAsString);
  final refreshToken = userModelAsJSON['AuthenticationResult']['RefreshToken'];
  final userModel = UserResponse(refreshToken: refreshToken);

  setUp(() {
    mockRefreshTokenLocalDataSource = MockRefreshTokenLocalDataSource();
    refreshTokenRepositoryImpl = RefreshTokenRepositoryImpl(
        refreshTokenLocalDataSource: mockRefreshTokenLocalDataSource);
  });
  test(
    'Should be a subclass of RefreshTokenRepository entity',
    () async {
      // assert
      expect(refreshTokenRepositoryImpl, isA<RefreshTokenRepository>());
    },
  );

  group('Read Refresh Token', () {
    test('Should return No Value in Cache Exception', () async {
      when(mockRefreshTokenLocalDataSource.readRefreshToken())
          .thenThrow(NoValueInCacheException());
      final refreshTokenReceived =
          await refreshTokenRepositoryImpl.readRefreshToken();

      /// Expect an exception to be thrown
      final f =
          refreshTokenReceived.fold<Failure>((f) => f, (_) => GenericFailure());
      verify(mockRefreshTokenLocalDataSource.readRefreshToken());
      expect(refreshTokenReceived.isLeft(), equals(true));
      expect(f, equals(EmptyResponseFailure()));
    });

    test('Should read Refresh token', () async {
      when(mockRefreshTokenLocalDataSource.readRefreshToken())
          .thenAnswer((_) => Future.value(refreshToken));
      final refreshTokenRead =
          await refreshTokenRepositoryImpl.readRefreshToken();

      verify(mockRefreshTokenLocalDataSource.readRefreshToken());
      expect(refreshTokenRead.getOrElse(() => null), equals(refreshToken));
      expect(refreshTokenRead.isRight(), equals(true));
    });
  });

  group('Write Refresh Token', () {
    test('Should write Refresh token', () async {
      await refreshTokenRepositoryImpl.writeRefreshToken(userModel);
      verify(mockRefreshTokenLocalDataSource.writeRefreshToken(refreshToken));
    });
  });
}
