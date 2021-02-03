import 'package:dartz/dartz.dart';
import 'package:devicelocale/devicelocale.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mobile_blitzbudget/core/failure/api_failure.dart';
import 'package:mobile_blitzbudget/core/failure/failure.dart';
import 'package:mobile_blitzbudget/domain/repositories/authentication/authentication_repository.dart';
import 'package:mobile_blitzbudget/domain/usecases/authentication/signup_user.dart';
import 'package:mockito/mockito.dart';

class MockAuthenticationRepository extends Mock
    implements AuthenticationRepository {}

class MockDevicelocale extends Mock implements Devicelocale {}

void main() {
  MockAuthenticationRepository mockAuthenticationRepository;
  SignupUser signupUser;
  const email = 'nagarjun_nagesh@outlook.com';
  const password = '12345678';

  setUp(() {
    mockAuthenticationRepository = MockAuthenticationRepository();
    signupUser =
        SignupUser(authenticationRepository: mockAuthenticationRepository);
  });

  group('Success: SignupUser', () {
    test('Should receive a successful response', () async {
      final eitherUserResponseMonad = Right<Failure, void>('');

      when(mockAuthenticationRepository.signupUser(
              email: email,
              password: password,
              firstName: 'nagarjun',
              surName: 'nagesh',
              acceptLanguage: null))
          .thenAnswer((_) => Future.value(eitherUserResponseMonad));
      final signupUserResponse =
          await signupUser.signupUser(email: email, password: password);
      expect(signupUserResponse.isRight(), true);
      verify(signupUser.signupUser(email: email, password: password));
    });
  });

  group('ERROR: SignupUser', () {
    test('Should receive a failure response', () async {
      final eitherUserResponseMonad = Left<Failure, void>(FetchDataFailure());
      when(mockAuthenticationRepository.signupUser(
              email: email,
              password: password,
              firstName: 'nagarjun',
              surName: 'nagesh',
              acceptLanguage: null))
          .thenAnswer((_) => Future.value(eitherUserResponseMonad));
      final signupUserResponse =
          await signupUser.signupUser(email: email, password: password);
      expect(signupUserResponse.isLeft(), true);
      verify(signupUser.signupUser(email: email, password: password));
    });
  });
}
