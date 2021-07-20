part of 'verify_bloc.dart';

abstract class VerifyEvent extends Equatable {
  const VerifyEvent({
    @required this.email,
    @required this.password,
    @required this.verificationCode,
    @required this.useVerifyURL,
  });

  final String email;
  final String password;
  final String verificationCode;
  final bool useVerifyURL;

  @override
  List<Object> get props => [];
}

class VerifyUser extends VerifyEvent {
  const VerifyUser(
      {@required String email,
      @required String password,
      @required String verificationCode,
      @required bool useVerifyURL})
      : super(
            email: email,
            password: password,
            verificationCode: verificationCode,
            useVerifyURL: useVerifyURL);
}

class ResendVerificatonCode extends VerifyEvent {
  const ResendVerificatonCode({@required String email})
      : super(
            email: email,
            password: '',
            verificationCode: '',
            useVerifyURL: false);
}
