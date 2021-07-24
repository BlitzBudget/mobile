import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../injection_container.dart';
import '../../../ploc/authentication/signup/signup_bloc.dart';
import 'components/body.dart';

class SignUpScreen extends StatelessWidget {
  /// In the constructor, require a Todo.
  const SignUpScreen({Key? key, required this.email, required this.password})
      : super(key: key);

  final String? email;
  final String? password;

  @override
  BlocProvider<SignupBloc> build(BuildContext context) {
    return BlocProvider(
        create: (_) => SignupBloc(signupUser: getIt()),
        child: Scaffold(
          body: Body(email: email, password: password),
        ));
  }
}
