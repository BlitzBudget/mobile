part of 'verify_bloc.dart';

abstract class VerifyEvent extends Equatable {
  const VerifyEvent(this.email, this.password, this.verificationCode);

  final String email;
  final String password;
  final String verificationCode;

  @override
  List<Object> get props => [];
}

class VerifyUser extends VerifyEvent {
  const VerifyUser(
      {@required String email,
      @required String password,
      @required String verificationCode})
      : super(email, password, verificationCode);
}

class ResendVerificatonCode extends VerifyEvent {
  const ResendVerificatonCode({@required String email}) : super(email, '', '');
}
