import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:mobile_blitzbudget/app/constants/constants.dart';
import 'package:mobile_blitzbudget/app/ploc/authentication/login/login_bloc.dart';
import 'package:mobile_blitzbudget/app/screens/authentication/forgot-password/forgot_password_screen.dart';
import 'package:mobile_blitzbudget/app/screens/authentication/signup/signup_screen.dart';
import 'package:mobile_blitzbudget/app/screens/authentication/verify/verify_screen.dart';
import '../../../../widgets/linear_loading_indicator.dart';
import '../../../../widgets/rounded_button.dart';
import '../../components/already_have_an_account_check.dart';
import '../../components/password_constraint_container.dart';
import '../../components/rounded_input_field.dart';
import '../../components/rounded_password_field.dart';
import 'background.dart';

// Public exposed class
class Body extends StatefulWidget {
  /// In the constructor
  const Body({Key? key}) : super(key: key);

  @override
  _BodyState createState() => _BodyState();
}

class _BodyState extends State<Body> {
  /// States
  bool _btnEnabled = true;

  TextEditingController? controller;
  String? username, password;
  final login = 'LOGIN';
  final yourEmail = 'Your Email';
  String continueButton = 'CONTINUE';

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return BlocConsumer<LoginBloc, LoginState>(listener: (context, state) {
      debugPrint('The Login listener has been called');
      continueButton = 'CONTINUE';
      _btnEnabled = true;

      if (state is RedirectToDashboard) {
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
                SignUpScreen(email: username, password: password),
          ),
        );
      } else if (state is RedirectToVerification) {
        /// Navigate to the Verify screen using a named route.
        Navigator.push(
          context,
          MaterialPageRoute<VerifyScreen>(
            builder: (context) => VerifyScreen(
                email: username,
                password: password,
                useVerifyURL: false,
                showResendVerificationCode: false),
          ),
        );
      } else if (state is RedirectToForgotPassword) {
        /// Navigate to the Verify screen using a named route.
        Navigator.push(
          context,
          MaterialPageRoute<ForgotPasswordScreen>(
            builder: (context) =>
                ForgotPasswordScreen(email: username!, password: password!),
          ),
        );
      } else if (state is Loading) {
        continueButton = 'Loading';
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
                  login,
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
              ),
              SizedBox(height: size.height * 0.03),
              SvgPicture.asset(
                'assets/icons/login.svg',
                height: size.height * 0.35,
              ),
              SizedBox(height: size.height * 0.03),
              RoundedInputField(
                  hintText: yourEmail,
                  textInputType: TextInputType.emailAddress,
                  onChanged: (value) {
                    username = value;
                  },
                  autofocus: true),
              RoundedPassword(
                onChanged: (value) {
                  password = value;
                },
              ),
              const PasswordConstraint(),
              RoundedButton(
                text: continueButton,

                /// Disable press if button is disabled
                press: () async {
                  _dispatchLoginUser();
                },
                enabled: _btnEnabled,
              ),
              SizedBox(height: size.height * 0.03),
              AlreadyHaveAnAccountCheck(
                press: () {
                  _dispatchForgotPasswordUser();
                },
              ),
            ],
          ),
        ),
      );
    });
  }

  void _dispatchForgotPasswordUser() {
    BlocProvider.of<LoginBloc>(context).add(ForgotPassword(username, password));
  }

  void _dispatchLoginUser() {
    BlocProvider.of<LoginBloc>(context)
        .add(LoginUser(username: username, password: password));
  }
}
