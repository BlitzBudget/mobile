part of 'change_password_bloc.dart';

abstract class ChangePasswordState extends Equatable {
  const ChangePasswordState();

  @override
  List<Object> get props => [];
}

class Empty extends ChangePasswordState {}

class Loading extends ChangePasswordState {}

class Success extends ChangePasswordState {}

class RedirectToLogin extends ChangePasswordState {}

class RedirectToSignup extends ChangePasswordState {}

class RedirectToVerification extends ChangePasswordState {}

class Error extends ChangePasswordState {
  const Error({required this.message});

  final String message;

  @override
  List<Object> get props => [message];
}
