import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mobile_blitzbudget/core/failure/api_failure.dart';
import 'package:mobile_blitzbudget/core/failure/failure.dart';
import 'package:mobile_blitzbudget/domain/repositories/authentication/authentication_repository.dart';
import 'package:mobile_blitzbudget/domain/usecases/authentication/verify_user.dart';
import 'package:mockito/mockito.dart';

class MockAuthenticationRepository extends Mock
    implements AuthenticationRepository {}

void main() {
  MockAuthenticationRepository mockAuthenticationRepository;
  VerifyUser verifyUser;
  const email = 'nagarjun_nagesh@outlook.com';
  const password = '12345678';
  const verificationCode = '1234';

  setUp(() {
    mockAuthenticationRepository = MockAuthenticationRepository();
    verifyUser =
        VerifyUser(authenticationRepository: mockAuthenticationRepository);
  });

  group('Success: VerifyUser', () {
    test('Should receive a successful response', () async {
      const eitherUserResponseMonad = Right<Failure, void>('');
      when(mockAuthenticationRepository.verifyEmail(
              email: email,
              password: password,
              verificationCode: verificationCode,
              useVerifyURL: true))
          .thenAnswer((_) => Future.value(eitherUserResponseMonad));
      final verifyUserResponse = await verifyUser.verifyUser(
          email: email,
          password: password,
          verificationCode: verificationCode,
          useVerifyURL: true);
      expect(verifyUserResponse.isRight(), true);
      verify(verifyUser.verifyUser(
          email: email,
          password: password,
          verificationCode: verificationCode,
          useVerifyURL: true));
    });
  });

  group('ERROR: VerifyUser', () {
    test('Should receive a failure response', () async {
      final eitherUserResponseMonad = Left<Failure, void>(FetchDataFailure());
      when(mockAuthenticationRepository.verifyEmail(
              email: email,
              password: password,
              verificationCode: verificationCode,
              useVerifyURL: true))
          .thenAnswer((_) => Future.value(eitherUserResponseMonad));
      final verifyUserResponse = await verifyUser.verifyUser(
          email: email,
          password: password,
          verificationCode: verificationCode,
          useVerifyURL: true);
      expect(verifyUserResponse.isLeft(), true);
      verify(verifyUser.verifyUser(
          email: email,
          password: password,
          verificationCode: verificationCode,
          useVerifyURL: true));
    });
  });

  group('Success: resendVerificationCode', () {
    test('Should receive a successful response', () async {
      const eitherUserResponseMonad = Right<Failure, void>('');
      when(mockAuthenticationRepository.resendVerificationCode(email))
          .thenAnswer((_) => Future.value(eitherUserResponseMonad));
      final verifyUserResponse =
          await verifyUser.resendVerificationCode(email: email);
      expect(verifyUserResponse.isRight(), true);
      verify(mockAuthenticationRepository.resendVerificationCode(email));
    });
  });
}
