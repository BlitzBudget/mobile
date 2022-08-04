import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mobile_blitzbudget/app/ploc/dashboard/transaction/transaction_bloc.dart';
import 'package:mobile_blitzbudget/injection_container.dart';

import 'components/body.dart';

class AddTransactionScreen extends StatelessWidget {
  /// In the constructor, require a Todo.
  const AddTransactionScreen({Key? key, this.androidDrawer}) : super(key: key);

  final Widget? androidDrawer;
  static const title = 'Transactions';
  static const androidIcon = Icon(CupertinoIcons.news_solid);
  static const iosIcon = Icon(CupertinoIcons.news_solid);

  @override
  BlocProvider<TransactionBloc> build(BuildContext context) {
    return BlocProvider(
      create: (_) => TransactionBloc(
          updateTransactionUseCase: getIt(),
          addTransactionUseCase: getIt(),
          deleteTransactionUseCase: getIt(),
          fetchTransactionUseCase: getIt()),
      child: const Scaffold(
        body: Body(),
      ),
    );
  }
}
