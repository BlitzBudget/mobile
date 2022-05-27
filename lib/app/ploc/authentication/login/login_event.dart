part of 'login_bloc.dart';

abstract class LoginEvent extends Equatable {
  const LoginEvent({required this.username, required this.password});

  final String? username;
  final String? password;

  @override
  List<Object> get props => [];
}

class LoginUser extends LoginEvent {
  const LoginUser({required String? username, required String? password})
      : super(username: username, password: password);
}

class ForgotPassword extends LoginEvent {
  const ForgotPassword(String? username, String? password)
      : super(username: username, password: password);
}
