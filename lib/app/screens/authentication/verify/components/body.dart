import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:mobile_blitzbudget/app/constants/constants.dart';
import 'package:mobile_blitzbudget/app/ploc/verify/verify_bloc.dart';

import '../../../../widgets/linear_loading_indicator.dart';
import '../../../../widgets/rounded_button.dart';
import '../../components/rounded_input_field.dart';
import 'background.dart';
import 'resend_verification.dart';

// Public exposed class
class Body extends StatefulWidget {
  /// In the constructor, require a Todo.
  /// The verify URL is true by default
  const Body(
      {Key? key,
      required this.email,
      required this.password,
      this.useVerifyURL,
      this.showResendVerificationCode})
      : super(key: key);

  final String? email, password;
  final bool? useVerifyURL;
  final bool? showResendVerificationCode;

  @override
  _BodyState createState() => _BodyState();
}

class _BodyState extends State<Body> {
  /// In the constructor, require a body state.
  _BodyState();

  /// States
  bool _btnEnabled = true;

  String? verificationCode;
  final String verifyEmail = 'Verify Email';
  final String verificationCodeText = 'Your verification code';
  String verifyButton = 'VERIFY';

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return BlocConsumer<VerifyBloc, VerifyState>(listener: (context, state) {
      debugPrint('The Verify Bloc listener has been called');
      verifyButton = 'VERIFY';
      _btnEnabled = true;

      if (state is Loading) {
        verifyButton = 'Loading';
        _btnEnabled = false;
      } else if (state is RedirectToLogin || state is RedirectToSignup) {
        /// Navigate to the login screen using a named route.
        Navigator.pushNamed(context, loginRoute);
      } else if (state is Error) {
        debugPrint('The Verify Bloc has an error state ${state.message}');
      } else if (state is RedirectToDashboard) {
        Navigator.pushNamed(context, dashboardRoute);
      } else if (state is ResendVerificationCodeSuccessful) {
        debugPrint(
            'The Verify Bloc has successfully sent the resend verification ${state.stringify}');
      }
    }, builder: (context, state) {
      return Background(
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              ///  Linear Progress indicator for loading
              /// Show text only when the button is enabled
              Visibility(
                  visible: _btnEnabled,
                  replacement: const LinearLoadingIndicator(),
                  child: Text(
                    verifyEmail,
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  )),
              SizedBox(height: size.height * 0.03),
              SvgPicture.asset(
                'assets/icons/signup.svg',
                height: size.height * 0.35,
              ),
              RoundedInputField(
                  hintText: verificationCodeText,
                  onChanged: (value) async {
                    verificationCode = value;

                    /// If the length of the string is == 6 then submit the code for verification
                    if (verificationCode != null &&
                        verificationCode!.length >= 6) {
                      _dispatchVerifyEmail(
                          email: widget.email,
                          password: widget.password,
                          verificationCode: verificationCode,
                          useVerifyURL: widget.useVerifyURL);
                    }
                  },
                  autofocus: true),
              RoundedButton(
                text: verifyButton,
                press: () async {
                  _dispatchVerifyEmail(
                      email: widget.email,
                      password: widget.password,
                      verificationCode: verificationCode,
                      useVerifyURL: widget.useVerifyURL);
                },
                enabled: _btnEnabled,
              ),
              SizedBox(height: size.height * 0.03),

              /// Show text only when the showResendVerificationCode is enabled
              Visibility(
                visible: widget.showResendVerificationCode!,
                child: ResendVerification(email: widget.email),
              ),
            ],
          ),
        ),
      );
    });
  }

  void _dispatchVerifyEmail(
      {required String? email,
      required String? password,
      required String? verificationCode,
      required bool? useVerifyURL}) {
    BlocProvider.of<VerifyBloc>(context).add(VerifyUser(
        email: email,
        password: password,
        verificationCode: verificationCode,
        useVerifyURL: useVerifyURL));
  }
}
