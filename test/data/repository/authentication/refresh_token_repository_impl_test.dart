import 'package:flutter_test/flutter_test.dart';
import 'package:mobile_blitzbudget/core/error/generic-exception.dart';
import 'package:mobile_blitzbudget/core/failure/failure.dart';
import 'package:mobile_blitzbudget/core/failure/generic-failure.dart';
import 'package:mobile_blitzbudget/data/datasource/local/authentication/refresh_token_local_data_source.dart';
import 'package:mobile_blitzbudget/data/repositories/authentication/refresh_token_repository_impl.dart';
import 'package:mobile_blitzbudget/domain/repositories/authentication/refresh_token_repository.dart';

import 'package:mockito/mockito.dart';

class MockRefreshTokenLocalDataSource extends Mock
    implements RefreshTokenLocalDataSource {}

void main() {
  MockRefreshTokenLocalDataSource mockRefreshTokenLocalDataSource;
  RefreshTokenRepositoryImpl refreshTokenRepositoryImpl;

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
      var refreshTokenReceived =
          await refreshTokenRepositoryImpl.readRefreshToken();

      /// Expect an exception to be thrown
      var f =
          refreshTokenReceived.fold<Failure>((f) => f, (_) => GenericFailure());
      verify(mockRefreshTokenLocalDataSource.readRefreshToken());
      expect(refreshTokenReceived.isLeft(), equals(true));
      expect(f, equals(EmptyResponseFailure()));
    });
  });
}
