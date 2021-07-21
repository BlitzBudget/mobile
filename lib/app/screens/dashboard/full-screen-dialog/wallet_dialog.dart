import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../../../app/widgets/rounded_button.dart';
import '../../../constants/constants.dart';
import '../../../widgets/dashboard_widget.dart';
import 'profile_dialog.dart';
import 'settings_dialog.dart';
import 'wallet/add_new_wallet.dart';

class WalletDialog extends StatelessWidget {
  const WalletDialog({
    Key? key,
  }) : super(key: key);

  static const title = 'Wallets';
  static const androidIcon = Icon(Icons.person);
  static const iosIcon = Icon(CupertinoIcons.profile_circled);

  Widget _buildBody(BuildContext context) {
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          children: [
            const Padding(
              padding: EdgeInsets.all(8),
              child: Center(
                child: Text(
                  '😼',
                  style: TextStyle(
                    fontSize: 80,
                    decoration: TextDecoration.none,
                  ),
                ),
              ),
            ),
            Expanded(
              child: Container(),
            ),
            const AddNewWalletButton(),
          ],
        ),
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
      navigationBar: CupertinoNavigationBar(
          /*automaticallyImplyLeading: false,*/
          trailing:
              Row(mainAxisAlignment: MainAxisAlignment.end, children: <Widget>[
        CupertinoButton(
          padding: EdgeInsets.zero,
          onPressed: () {
            /// This pushes the settings page as a full page modal dialog on top
            /// of the tab bar and everything.
            Navigator.of(context, rootNavigator: true).push<void>(
              CupertinoPageRoute(
                title: SettingsDialog.title,
                fullscreenDialog: true,
                builder: (context) => const SettingsDialog(),
              ),
            );
          },
          child: SettingsDialog.iosIcon,
        ),
        CupertinoButton(
          padding: EdgeInsets.zero,
          onPressed: () {
            /// This pushes the profile page as a full page modal dialog on top
            /// of the tab bar and everything.
            Navigator.of(context, rootNavigator: true).push<void>(
              CupertinoPageRoute(
                title: ProfileDialog.title,
                fullscreenDialog: true,
                builder: (context) => const ProfileDialog(),
              ),
            );
          },
          child: ProfileDialog.iosIcon,
        ),
      ])),
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

class AddNewWalletButton extends StatelessWidget {
  const AddNewWalletButton({
    Key? key,
  }) : super(key: key);

  static const addNewWallet = 'Add new wallet';

  /// ===========================================================================
  /// Non-shared code below because this tab shows different interfaces. On
  /// Android, it's showing an alert dialog with 2 buttons and on iOS,
  /// it's showing an action sheet with 3 choices.
  //
  /// This is a design choice and you may want to do something different in your
  /// app.
  /// ===========================================================================

  Widget _buildAndroid(BuildContext context) {
    return RoundedButton(
      text: addNewWallet,
      color: secondaryColor,
      press: () {
        Navigator.pop(context);
        Navigator.push<void>(context,
            MaterialPageRoute(builder: (context) => const AddNewWallet()));
      },
    );
  }

  Widget _buildIos(BuildContext context) {
    return RoundedButton(
      text: addNewWallet,
      color: secondaryColor,
      press: () {
        /// This pushes the Wallets page as a full page modal dialog on top
        /// of the tab bar and everything.
        Navigator.of(context, rootNavigator: true).push<void>(
          CupertinoPageRoute(
            title: WalletDialog.title,
            fullscreenDialog: true,
            builder: (context) => const AddNewWallet(),
          ),
        );
      },
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
