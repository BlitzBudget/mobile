part of 'change_password_bloc.dart';

abstract class ChangePasswordEvent extends Equatable {
  const ChangePasswordEvent(
      {required this.oldPassword, required this.newPassword});

  final String? oldPassword;
  final String? newPassword;

  @override
  List<Object> get props => [];
}

class ChangePassword extends ChangePasswordEvent {
  const ChangePassword(
      {required String? oldPassword, required String? newPassword})
      : super(oldPassword: oldPassword, newPassword: newPassword);
}
