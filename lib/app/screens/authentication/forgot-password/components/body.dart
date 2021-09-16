import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:mobile_blitzbudget/app/ploc/authentication/verify/verify_bloc.dart';
import 'package:mobile_blitzbudget/app/screens/authentication/signup/signup_screen.dart';
import 'package:mobile_blitzbudget/app/screens/authentication/verify/verify_screen.dart';

import '../../../../constants/constants.dart';
import '../../../../widgets/linear_loading_indicator.dart';
import '../../../../widgets/rounded_button.dart';
import '../../components/rounded_input_field.dart';
import 'background.dart';

// Public exposed class
class Body extends StatefulWidget {
  /// In the constructor, require a Todo.
  const Body({Key? key, this.email, this.password}) : super(key: key);

  final String? email, password;

  @override
  _BodyState createState() => _BodyState();
}

class _BodyState extends State<Body> {
  /// States
  bool _btnEnabled = true;
  String verificationCode = '';
  String forgotPasswordButton = 'FORGOT PASSWORD';
  final String hintPassword = 'New Password';
  final String verifyEmail = 'Verify Email';
  final String verificationCodeText = 'Your verification code';
  String verifyButton = 'VERIFY';

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return BlocConsumer<VerifyBloc, VerifyState>(listener: (context, state) {
      forgotPasswordButton = 'FORGOT PASSWORD';
      _btnEnabled = true;

      if (state is RedirectToLogin) {
        /// Navigate to the second screen using a named route.
        Navigator.pushNamed(context, loginRoute);
      } else if (state is RedirectToDashboard) {
        Navigator.pushNamed(context, dashboardRoute);
      } else if (state is Error) {
        // TODO Print error
        debugPrint('The Login encountered an error ${state.message}');
      } else if (state is RedirectToSignup) {
        /// Navigate to the Signup screen using a named route.
        Navigator.push(
          context,
          MaterialPageRoute<SignUpScreen>(
            builder: (context) =>
                SignUpScreen(email: widget.email, password: widget.password),
          ),
        );
      } else if (state is RedirectToVerification) {
        /// Navigate to the Verify screen using a named route.
        Navigator.push(
          context,
          MaterialPageRoute<VerifyScreen>(
            builder: (context) => VerifyScreen(
                email: widget.email,
                password: widget.password,
                useVerifyURL: false,
                showResendVerificationCode: false),
          ),
        );
      } else if (state is Loading) {
        forgotPasswordButton = 'Loading';
        _btnEnabled = false;
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
                    if (verificationCode.length >= 6) {
                      _dispatchForgotPasswordUser();
                    }
                  },
                  autofocus: true),
              RoundedButton(
                text: verifyButton,
                press: () async {
                  _dispatchForgotPasswordUser();
                },
                enabled: _btnEnabled,
              ),
              SizedBox(height: size.height * 0.03),
            ],
          ),
        ),
      );
    });
  }

  void _dispatchForgotPasswordUser() {
    BlocProvider.of<VerifyBloc>(context).add(VerifyUser(
        email: widget.email,
        password: widget.password,
        useVerifyURL: false,
        verificationCode: verificationCode));
  }
}
