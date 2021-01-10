import 'package:flutter_test/flutter_test.dart';
import 'package:mobile_blitzbudget/core/error/generic-exception.dart';
import 'package:mobile_blitzbudget/core/failure/failure.dart';
import 'package:mobile_blitzbudget/core/failure/generic-failure.dart';
import 'package:mobile_blitzbudget/data/datasource/local/authentication/auth_token_local_data_source.dart';
import 'package:mobile_blitzbudget/data/repositories/authentication/auth_token_repository_impl.dart';
import 'package:mobile_blitzbudget/domain/repositories/authentication/auth_token_repository.dart';
import 'package:mockito/mockito.dart';

class MockAuthTokenLocalDataSource extends Mock
    implements AuthTokenLocalDataSource {}

void main() {
  MockAuthTokenLocalDataSource mockAuthTokenLocalDataSource;
  AuthTokenRepositoryImpl authTokenRepositoryImpl;

  setUp(() {
    mockAuthTokenLocalDataSource = MockAuthTokenLocalDataSource();
    authTokenRepositoryImpl = AuthTokenRepositoryImpl(
        authTokenLocalDataSource: mockAuthTokenLocalDataSource);
  });
  test(
    'Should be a subclass of BankAccount entity',
    () async {
      // assert
      expect(authTokenRepositoryImpl, isA<AuthTokenRepository>());
    },
  );

  group('Read Auth Token', () {
    test('Should return No Value in Cache Exception', () async {
      when(mockAuthTokenLocalDataSource.readAuthToken())
          .thenThrow(NoValueInCacheException());
      var authTokenReceived = await authTokenRepositoryImpl.readAuthToken();

      /// Expect an exception to be thrown
      var f =
          authTokenReceived.fold<Failure>((f) => f, (_) => GenericFailure());
      expect(authTokenReceived.isLeft(), equals(true));
      expect(f, equals(EmptyResponseFailure()));
    });
  });
}
