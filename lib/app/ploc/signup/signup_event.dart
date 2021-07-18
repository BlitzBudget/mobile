part of 'signup_bloc.dart';

abstract class SignupEvent extends Equatable {
  const SignupEvent(this.username, this.password, this.confirmPassword);

  final String username;
  final String password;
  final String confirmPassword;

  @override
  List<Object> get props => [];
}

class SignupUser extends SignupEvent {
  const SignupUser(String username, String password, String confirmPassword)
      : super(username, password, confirmPassword);
}

class LoginUser extends SignupEvent {
  const LoginUser() : super('', '', '');
}
