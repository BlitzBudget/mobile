import 'package:mobile_blitzbudget/domain/usecases/authentication/verify_user.dart'
    as verify_usecase;

class MockVerifyUser extends Mock implements verify_usecase.VerifyUser {}

void main() {
  late MockVerifyUser mockVerifyUser;
  const VALID_EMAIL = 'n123@gmail.com';
  const VALID_PASSWORD = 'P1234gs.';
  const VERIFICATION_CODE = 123456;
  const positiveMonadResponse = Right<Failure, void>('');

  setUp(() {
    mockVerifyUser = MockVerifyUser();
  })

  group('Success: VerifyBloc', () {
    blocTest<VerifyBloc, VerifyState>(
      'Emits [RedirectToDashboard] states for verification successful',
      build: () {
        when(() => mockVerifyUser.verifyUser(
                email: VALID_EMAIL, password: VALID_PASSWORD, verificationCode: VERIFICATION_CODE, useVerifyURL: true))
            .thenAnswer((_) => Future.value(positiveMonadResponse));
        return VerifyBloc(
          verifyUser: mockVerifyUser,
        );
      },
      act: (bloc) => bloc.add(const VerifyUser(email: VALID_EMAIL, password: VALID_PASSWORD, verificationCode: VERIFICATION_CODE, useVerifyURL: true)),
      expect: () => [Loading(), RedirectToDashboard()],
    );

    blocTest<VerifyBloc, VerifyState>(
      'Emits [ResendVerificationCodeSuccessful] states for resend verification code successful',
      build: () {
        when(() => mockVerifyUser.resendVerificationCode(
                email: VALID_EMAIL))
            .thenAnswer((_) => Future.value(positiveMonadResponse));
        return VerifyBloc(
          verifyUser: mockVerifyUser,
        );
      },
      act: (bloc) => bloc.add(const ResendVerificatonCode(email: VALID_EMAIL)),
      expect: () => [Loading(), ResendVerificationCodeSuccessful()],
    );
  });

  group('Error: Resend Verification VerifyBloc', () {
    blocTest<VerifyBloc, VerifyState>(
      'Emits [RedirectToLoginDueToFailure] states for resend verification code RedirectToLogin',
      build: () {
        final failureResponse =
            Left<Failure, void>(RedirectToLoginDueToFailure());
        when(() => mockVerifyUser.resendVerificationCode(
                email: VALID_EMAIL))
            .thenAnswer((_) => Future.value(failureResponse));
        return VerifyBloc(
          verifyUser: mockVerifyUser,
        );
      },
      act: (bloc) => bloc.add(const ResendVerificatonCode(email: VALID_EMAIL)),
      expect: () => [Loading(), RedirectToLogin()],
    );

    blocTest<VerifyBloc, VerifyState>(
      'Emits [RedirectToSignupDueToFailure] states for resend verification code RedirectToSignup',
      build: () {
        final failureResponse =
            Left<Failure, void>(RedirectToSignupDueToFailure());
        when(() => mockVerifyUser.resendVerificationCode(
                email: VALID_EMAIL))
            .thenAnswer((_) => Future.value(failureResponse));
        return VerifyBloc(
          verifyUser: mockVerifyUser,
        );
      },
      act: (bloc) => bloc.add(const ResendVerificatonCode(email: VALID_EMAIL)),
      expect: () => [Loading(), RedirectToSignup()],
    );

    blocTest<VerifyBloc, VerifyState>(
      'Emits [RedirectToVerificationDueToFailure] states for resend verification code RedirectToVerification',
      build: () {
        final failureResponse =
            Left<Failure, void>(RedirectToVerificationDueToFailure());
        when(() => mockVerifyUser.resendVerificationCode(
                email: VALID_EMAIL))
            .thenAnswer((_) => Future.value(failureResponse));
        return VerifyBloc(
          verifyUser: mockVerifyUser,
        );
      },
      act: (bloc) => bloc.add(const ResendVerificatonCode(email: VALID_EMAIL)),
      expect: () => [Loading(), RedirectToVerification()],
    );
  });

  group('Error: Verify VerifyBloc', () {
    blocTest<VerifyBloc, VerifyState>(
      'Emits [RedirectToVerificationDueToFailure] states for verification RedirectToVerification',
      build: () {
        final failureResponse =
            Left<Failure, void>(RedirectToVerificationDueToFailure());
        when(() => mockVerifyUser.verifyUser(
                email: VALID_EMAIL, password: VALID_PASSWORD, verificationCode: VERIFICATION_CODE, useVerifyURL: true))
            .thenAnswer((_) => Future.value(failureResponse));
        return VerifyBloc(
          verifyUser: mockVerifyUser,
        );
      },
      act: (bloc) => bloc.add(const VerifyUser(email: VALID_EMAIL, password: VALID_PASSWORD, verificationCode: VERIFICATION_CODE, useVerifyURL: true)),
      expect: () => [Loading(), RedirectToVerification()],
    );
  });

  blocTest<VerifyBloc, VerifyState>(
      'Emits [RedirectToLoginDueToFailure] states for verification RedirectToLogin',
      build: () {
        final failureResponse =
            Left<Failure, void>(RedirectToLoginDueToFailure());
        when(() => mockVerifyUser.verifyUser(
                email: VALID_EMAIL, password: VALID_PASSWORD, verificationCode: VERIFICATION_CODE, useVerifyURL: true))
            .thenAnswer((_) => Future.value(failureResponse));
        return VerifyBloc(
          verifyUser: mockVerifyUser,
        );
      },
      act: (bloc) => bloc.add(const VerifyUser(email: VALID_EMAIL, password: VALID_PASSWORD, verificationCode: VERIFICATION_CODE, useVerifyURL: true)),
      expect: () => [Loading(), RedirectToLogin()],
    );
  });

  blocTest<VerifyBloc, VerifyState>(
      'Emits [RedirectToSignupDueToFailure] states for verification RedirectToSignup',
      build: () {
        final failureResponse =
            Left<Failure, void>(RedirectToSignupDueToFailure());
        when(() => mockVerifyUser.verifyUser(
                email: VALID_EMAIL, password: VALID_PASSWORD, verificationCode: VERIFICATION_CODE, useVerifyURL: true))
            .thenAnswer((_) => Future.value(failureResponse));
        return VerifyBloc(
          verifyUser: mockVerifyUser,
        );
      },
      act: (bloc) => bloc.add(const VerifyUser(email: VALID_EMAIL, password: VALID_PASSWORD, verificationCode: VERIFICATION_CODE, useVerifyURL: true)),
      expect: () => [Loading(), RedirectToSignup()],
    );
  });
}