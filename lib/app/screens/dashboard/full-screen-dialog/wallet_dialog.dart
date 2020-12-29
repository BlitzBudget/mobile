import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

import 'settings_dialog.dart';
import 'profile_dialog.dart';
import '../../../app/constants/constants.dart';
import 'wallet/add_new_wallet.dart';
import '../../../app/widgets/dashboard_widget.dart';
import '../../../app/widgets/rounded_button.dart';
import '../../authentication/welcome/welcome_screen.dart';

class WalletDialog extends StatelessWidget {
  static const title = 'Wallets';
  static const androidIcon = Icon(Icons.person);
  static const iosIcon = Icon(CupertinoIcons.profile_circled);

  Widget _buildBody(BuildContext context) {
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          children: [
            Padding(
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
            AddNewWalletButton(),
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
        title: Text(title),
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
          child: SettingsDialog.iosIcon,
          onPressed: () {
            /// This pushes the settings page as a full page modal dialog on top
            /// of the tab bar and everything.
            Navigator.of(context, rootNavigator: true).push<void>(
              CupertinoPageRoute(
                title: SettingsDialog.title,
                fullscreenDialog: true,
                builder: (context) => SettingsDialog(),
              ),
            );
          },
        ),
        CupertinoButton(
          padding: EdgeInsets.zero,
          child: ProfileDialog.iosIcon,
          onPressed: () {
            /// This pushes the profile page as a full page modal dialog on top
            /// of the tab bar and everything.
            Navigator.of(context, rootNavigator: true).push<void>(
              CupertinoPageRoute(
                title: ProfileDialog.title,
                fullscreenDialog: true,
                builder: (context) => ProfileDialog(),
              ),
            );
          },
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
  static const _newWalletMessage = Text(logoutDescription);
  static const addNewWallet = "Add new wallet";

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
        Navigator.push<void>(
            context, MaterialPageRoute(builder: (context) => AddNewWallet()));
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
            builder: (context) => AddNewWallet(),
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
