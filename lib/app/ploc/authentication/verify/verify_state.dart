part of 'verify_bloc.dart';

abstract class VerifyState extends Equatable {
  const VerifyState();

  @override
  List<Object> get props => [];
}

class Empty extends VerifyState {}

class RedirectToDashboard extends VerifyState {}

class RedirectToLogin extends VerifyState {}

class RedirectToVerification extends VerifyState {}

class RedirectToSignup extends VerifyState {}

class ResendVerificationCodeSuccessful extends VerifyState {}

class Loading extends VerifyState {}

class Error extends VerifyState {
  const Error({required this.message});

  final String message;

  @override
  List<Object> get props => [message];
}
