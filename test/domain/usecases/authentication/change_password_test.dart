import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mobile_blitzbudget/core/failure/failure.dart';
import 'package:mobile_blitzbudget/core/failure/generic_failure.dart';
import 'package:mobile_blitzbudget/domain/repositories/authentication/access_token_repository.dart';
import 'package:mobile_blitzbudget/domain/repositories/authentication/change_password_repository.dart';
import 'package:mobile_blitzbudget/domain/usecases/authentication/change_password.dart';
import 'package:mockito/mockito.dart';

class MockChangePasswordRepository extends Mock
    implements ChangePasswordRepository {}

class MockAccessTokenRepository extends Mock implements AccessTokenRepository {}

void main() {
  MockChangePasswordRepository mockChangePasswordRepository;
  MockAccessTokenRepository mockAccessTokenRepository;
  ChangePassword changePassword;
  const  accessToken =
      'eyJraWQiOiJ5UG14MUFmdzFZa0U4ZHZ3YlgxcjUwMitmOTM1NGM1ZURZUmlcL3RxQ296VT0iLCJhbGciOiJSUzI1NiJ9.eyJzdWIiOiI1OTMxMmUyYS00OGQ1LTQyOTctYWJiOC1lOGI1M2E0M2EyZGUiLCJldmVudF9pZCI6IjdlMTRmZGViLWMyODEtNDZlMC1hM2EwLTU4ZTM1ZDY0NzQyZCIsInRva2VuX3VzZSI6ImFjY2VzcyIsInNjb3BlIjoiYXdzLmNvZ25pdG8uc2lnbmluLnVzZXIuYWRtaW4iLCJhdXRoX3RpbWUiOjE2MDk3NzM0MjAsImlzcyI6Imh0dHBzOlwvXC9jb2duaXRvLWlkcC5ldS13ZXN0LTEuYW1hem9uYXdzLmNvbVwvZXUtd2VzdC0xX2NqZkM4cU5pQiIsImV4cCI6MTYwOTc3NzAyMCwiaWF0IjoxNjA5NzczNDIwLCJqdGkiOiIxN2EzMjM0Yy0xMWZkLTRhNDItYWIzYi05MGVhM2VhOWI3M2IiLCJjbGllbnRfaWQiOiIyZnRsYnMxa2ZtcjJ1YjBlNHAxNXRzYWc4ZyIsInVzZXJuYW1lIjoibmFnYXJqdW5fbmFnZXNoQG91dGxvb2suY29tIn0.npmtjthQi53SSX9R2xRzuOEcsXXyD-YuQsdGwOoscbfg-f1HJ7-4SJH7KZFzUTTerQXli-82nlr9OeCoG7gWf0SSXim1O7pw2HiT5zLkmNETY-AH2uuTfJheqx85QHl55qiFfK9PfrP7JBoxb0YPYkGoquD1vR1rtEjXtXasYNknM8FyKxfr35fCW1CBFLdwPdp-5QKYh_ahIf3EVsDB7qD9-j3AvkYTAwSAhwuPAFRAcRTXRNc8XdX7sfIvFRcul4tVENdqNF5Im0bUPfWkuvaINbaRRL6gX_0Syjlfe4tzTNKXT3Xz4_CxqH5lSJOHwivcYecv7XQrDljewjNBCQ';

  setUp(() {
    mockChangePasswordRepository = MockChangePasswordRepository();
    mockAccessTokenRepository = MockAccessTokenRepository();
    changePassword = ChangePassword(
        accessTokenRepository: mockAccessTokenRepository,
        changePasswordRepository: mockChangePasswordRepository);
  });

  group('Success: ChangePassword', () {
    test('Should receive a successful response', () async {
      const Either<Failure, String> accessTokenMonad =
          Right<Failure, String>(accessToken);
      when(mockAccessTokenRepository.readAccessToken())
          .thenAnswer((_) => Future.value(accessTokenMonad));
      await changePassword.changePassword(
          newPassword: 'newPassword', oldPassword: 'oldPassword');
      verify(mockChangePasswordRepository.changePassword(
          accessToken: accessToken,
          newPassword: 'newPassword',
          oldPassword: 'oldPassword'));
      verify(mockAccessTokenRepository.readAccessToken());
    });
  });

  group('ERROR: ChangePassword', () {
    test('Should receive a failure response', () async {
      final Either<Failure, String> accessTokenMonad =
          Left<Failure, String>(EmptyResponseFailure());
      when(mockAccessTokenRepository.readAccessToken())
          .thenAnswer((_) => Future.value(accessTokenMonad));
      final changedPassword = await changePassword.changePassword(
          newPassword: 'newPassword', oldPassword: 'oldPassword');
      expect(changedPassword.isLeft(), equals(true));
      verifyNever(mockChangePasswordRepository.changePassword(
          newPassword: 'newPassword',
          oldPassword: 'oldPassword'));
      verify(mockAccessTokenRepository.readAccessToken());
    });
  });
}
