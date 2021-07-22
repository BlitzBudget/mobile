import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:mobile_blitzbudget/app/ploc/signup/signup_bloc.dart';
import 'package:mobile_blitzbudget/app/screens/authentication/verify/verify_screen.dart';

import '../../../../constants/constants.dart';
import '../../../../widgets/linear_loading_indicator.dart';
import '../../../../widgets/rounded_button.dart';
import '../../components/already_have_an_account_check.dart';
import '../../components/password_constraint_container.dart';
import '../../components/rounded_password_field.dart';
import 'background.dart';
import 'or_divider.dart';
import 'social_icon.dart';

// Public exposed class
class Body extends StatefulWidget {
  /// In the constructor, require a Todo.
  const Body({Key? key, required this.email, required this.password})
      : super(key: key);

  final String? email, password;

  @override
  _BodyState createState() => _BodyState();
}

class _BodyState extends State<Body> {
  /// Constructor for the private class
  _BodyState();

  /// States
  bool _btnEnabled = true;

  String? confirmPassword;
  final signupText = 'SIGNUP';
  final yourEmail = 'Your Email';
  String signupButton = 'SIGNUP';

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return BlocConsumer<SignupBloc, SignupState>(listener: (context, state) {
      debugPrint('The Signup Bloc listener has been called');
      signupButton = 'SIGNUP';
      _btnEnabled = true;

      if (state is RedirectToVerification) {
        /// Navigate to the verification screen using a named route.
        Navigator.push(
          context,
          MaterialPageRoute<VerifyScreen>(
            builder: (context) =>
                VerifyScreen(email: widget.email, password: widget.password),
          ),
        );
      } else if (state is RedirectToLogin || state is RedirectToSignup) {
        /// Navigate to the login screen using a named route.
        Navigator.pushNamed(context, loginRoute);
      } else if (state is Error) {
        debugPrint('The Signup Bloc has an error state ${state.message}');
      } else if (state is Loading) {
        signupButton = 'Loading';
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
                  signupText,
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
              ),
              SizedBox(height: size.height * 0.03),
              SvgPicture.asset(
                'assets/icons/signup.svg',
                height: size.height * 0.35,
              ),
              Text(
                widget.email!,
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
              RoundedPassword(
                  onChanged: (value) {
                    confirmPassword = value;
                  },
                  autofocus: true),
              const PasswordConstraint(),
              RoundedButton(
                text: signupButton,
                press: () async {
                  setState(() {
                    signupButton = 'Loading';
                    _btnEnabled = false;
                  });
                  _dispatchSignupUser(
                      email: widget.email,
                      password: widget.password,
                      confirmPassword: confirmPassword);
                  setState(() {
                    signupButton = 'SIGNUP';
                    _btnEnabled = true;
                  });
                },
                enabled: _btnEnabled,
              ),
              SizedBox(height: size.height * 0.03),
              AlreadyHaveAnAccountCheck(
                login: false,
                press: () {
                  _dispatchLoginUser();
                },
              ),
              const OrDivider(),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  SocalIcon(
                    iconSrc: 'assets/icons/facebook.svg',
                    press: () {},
                  ),
                  SocalIcon(
                    iconSrc: 'assets/icons/twitter.svg',
                    press: () {},
                  ),
                  SocalIcon(
                    iconSrc: 'assets/icons/google-plus.svg',
                    press: () {},
                  ),
                ],
              )
            ],
          ),
        ),
      );
    });
  }

  void _dispatchLoginUser() {
    BlocProvider.of<SignupBloc>(context).add(const LoginUser());
  }

  void _dispatchSignupUser(
      {required String? email,
      required String? password,
      required String? confirmPassword}) {
    BlocProvider.of<SignupBloc>(context)
        .add(SignupUser(email, password, confirmPassword));
  }
}
