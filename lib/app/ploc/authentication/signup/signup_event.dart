part of 'signup_bloc.dart';

abstract class SignupEvent extends Equatable {
  const SignupEvent(
      {required this.username,
      required this.password,
      required this.confirmPassword});

  final String? username;
  final String? password;
  final String? confirmPassword;

  @override
  List<Object> get props => [];
}

class SignupUser extends SignupEvent {
  const SignupUser({required String? username,required String? password,required String? confirmPassword})
      : super(
            username: username,
            password: password,
            confirmPassword: confirmPassword);
}

class LoginUser extends SignupEvent {
  const LoginUser() : super(username: '', password: '', confirmPassword: '');
}
