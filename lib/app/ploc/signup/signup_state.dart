part of 'signup_bloc.dart';

abstract class SignupState extends Equatable {
  const SignupState();

  @override
  List<Object> get props => [];
}

class Empty extends SignupState {}

class RedirectToVerification extends SignupState {}

class RedirectToLogin extends SignupState {}

class Loading extends SignupState {}

class Error extends SignupState {
  const Error({@required this.message});

  final String message;

  @override
  List<Object> get props => [message];
}
