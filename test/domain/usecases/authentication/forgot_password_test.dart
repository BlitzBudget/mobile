import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mobile_blitzbudget/core/failure/failure.dart';
import 'package:mobile_blitzbudget/domain/repositories/authentication/authentication_repository.dart';
import 'package:mobile_blitzbudget/domain/usecases/authentication/forgot_password.dart';
import 'package:mockito/mockito.dart';

class MockAuthenticationRepository extends Mock
    implements AuthenticationRepository {}

void main() {
  MockAuthenticationRepository mockAuthenticationRepository;
  ForgotPassword forgotPassword;
  final authenticationToken =
      'eyJraWQiOiJ5UG14MUFmdzFZa0U4ZHZ3YlgxcjUwMitmOTM1NGM1ZURZUmlcL3RxQ296VT0iLCJhbGciOiJSUzI1NiJ9.eyJzdWIiOiI1OTMxMmUyYS00OGQ1LTQyOTctYWJiOC1lOGI1M2E0M2EyZGUiLCJldmVudF9pZCI6IjdlMTRmZGViLWMyODEtNDZlMC1hM2EwLTU4ZTM1ZDY0NzQyZCIsInRva2VuX3VzZSI6ImFjY2VzcyIsInNjb3BlIjoiYXdzLmNvZ25pdG8uc2lnbmluLnVzZXIuYWRtaW4iLCJhdXRoX3RpbWUiOjE2MDk3NzM0MjAsImlzcyI6Imh0dHBzOlwvXC9jb2duaXRvLWlkcC5ldS13ZXN0LTEuYW1hem9uYXdzLmNvbVwvZXUtd2VzdC0xX2NqZkM4cU5pQiIsImV4cCI6MTYwOTc3NzAyMCwiaWF0IjoxNjA5NzczNDIwLCJqdGkiOiIxN2EzMjM0Yy0xMWZkLTRhNDItYWIzYi05MGVhM2VhOWI3M2IiLCJjbGllbnRfaWQiOiIyZnRsYnMxa2ZtcjJ1YjBlNHAxNXRzYWc4ZyIsInVzZXJuYW1lIjoibmFnYXJqdW5fbmFnZXNoQG91dGxvb2suY29tIn0.npmtjthQi53SSX9R2xRzuOEcsXXyD-YuQsdGwOoscbfg-f1HJ7-4SJH7KZFzUTTerQXli-82nlr9OeCoG7gWf0SSXim1O7pw2HiT5zLkmNETY-AH2uuTfJheqx85QHl55qiFfK9PfrP7JBoxb0YPYkGoquD1vR1rtEjXtXasYNknM8FyKxfr35fCW1CBFLdwPdp-5QKYh_ahIf3EVsDB7qD9-j3AvkYTAwSAhwuPAFRAcRTXRNc8XdX7sfIvFRcul4tVENdqNF5Im0bUPfWkuvaINbaRRL6gX_0Syjlfe4tzTNKXT3Xz4_CxqH5lSJOHwivcYecv7XQrDljewjNBCQ';

  setUp(() {
    mockAuthenticationRepository = MockAuthenticationRepository();
    forgotPassword =
        ForgotPassword(authenticationRepository: mockAuthenticationRepository);
  });

  group('Success: ForgotPassword', () {
    test('Should receive a successful response', () async {
      final userEmail = 'nagarjun_nagesh@outlook.com';
      final userPassword = 'password';
      Either<Failure, String> authenticationMonad =
          Right<Failure, String>(authenticationToken);
      when(mockAuthenticationRepository.forgotPassword(
              email: userEmail, password: userPassword))
          .thenAnswer((_) => Future.value(authenticationMonad));
      await forgotPassword.forgotPassword(
          email: userEmail, password: userPassword);
      verify(mockAuthenticationRepository.forgotPassword(
          email: userEmail, password: userPassword));
    });
  });
}
