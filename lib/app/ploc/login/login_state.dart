part of 'login_bloc.dart';

abstract class LoginState extends Equatable {
  const LoginState();

  @override
  List<Object> get props => [];
}

class Empty extends LoginState {}

class RedirectToSignup extends LoginState {}

class RedirectToVerification extends LoginState {}

class RedirectToDashboard extends LoginState {}

class Loading extends LoginState {}

class Error extends LoginState {
  const Error({required this.message});

  final String message;

  @override
  List<Object> get props => [message];
}
