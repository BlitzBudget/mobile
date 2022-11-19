import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mobile_blitzbudget/app/ploc/dashboard/wallet/wallet_bloc.dart';
import 'package:mobile_blitzbudget/injection_container.dart';

import 'components/body.dart';

class AddWalletScreen extends StatelessWidget {
  /// In the constructor, require a Todo.
  const AddWalletScreen({Key? key, this.androidDrawer}) : super(key: key);

  final Widget? androidDrawer;
  static const title = 'Wallet';
  static const androidIcon = Icon(CupertinoIcons.news_solid);
  static const iosIcon = Icon(CupertinoIcons.news_solid);

  @override
  BlocProvider<WalletBloc> build(BuildContext context) {
    return BlocProvider(
      create: (_) => WalletBloc(
          updateWalletUseCase: getIt(),
          addWalletUseCase: getIt(),
          deleteWalletUseCase: getIt(),
          fetchWalletUseCase: getIt()),
      child: const Scaffold(
        body: Body(),
      ),
    );
  }
}
