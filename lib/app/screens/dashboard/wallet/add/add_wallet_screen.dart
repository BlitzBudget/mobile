import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:mobile_blitzbudget/app/widgets/dashboard_widget.dart';

import '../choose/choose_currency.dart';

class AddNewWallet extends StatelessWidget {
  const AddNewWallet({
    Key? key,
  }) : super(key: key);

  static const title = 'Add new wallet';

  Widget _buildBody(BuildContext context) {
    return const SafeArea(
      child: Padding(
        padding: EdgeInsets.all(24),
        child: ChooseCurrencyList(),
      ),
    );
  }

  /// ===========================================================================
  /// Non-shared code below because on iOS, the settings tab is nested inside of
  /// the profile tab as a button in the nav bar.
  /// ===========================================================================
  Widget _buildAndroid(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(title),
      ),
      body: _buildBody(context),
    );
  }

  Widget _buildIos(BuildContext context) {
    return CupertinoPageScaffold(
      navigationBar: const CupertinoNavigationBar(),
      child: _buildBody(context),
    );
  }

  @override
  Widget build(context) {
    return PlatformWidget(
      androidBuilder: _buildAndroid,
      iosBuilder: _buildIos,
    );
  }
}
