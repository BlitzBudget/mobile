import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mobile_blitzbudget/app/ploc/authentication/verify/verify_bloc.dart';
import '../../../../injection_container.dart';
import 'components/body.dart';

class ForgotPasswordScreen extends StatelessWidget {
  /// In the constructor, require a Todo.
  const ForgotPasswordScreen({Key? key, this.email = '', this.password = ''})
      : super(key: key);

  final String email, password;

  @override
  BlocProvider<VerifyBloc> build(BuildContext context) {
    return BlocProvider(
        create: (_) => VerifyBloc(verifyUser: getIt()),
        child: Scaffold(
          body: Body(email: email, password: password),
        ));
  }
}
