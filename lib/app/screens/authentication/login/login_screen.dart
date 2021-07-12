import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mobile_blitzbudget/app/ploc/login/login_bloc.dart';
import 'package:mobile_blitzbudget/injection_container.dart';
import 'components/body.dart';

class LoginScreen extends StatelessWidget {
  /// In the constructor, require a Todo.
  const LoginScreen({Key key}) : super(key: key);
  @override
  BlocProvider<LoginBloc> build(BuildContext context) {
    return BlocProvider(
      create: (_) => LoginBloc(forgotPassword: getIt(), loginUser: getIt()),
      child: const Scaffold(
        body: Body(),
      ),
    );
  }
}
