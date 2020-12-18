import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

import 'settings_tab.dart';
import 'profile_tab.dart';
import '../../../constants.dart';
import '../../../utils/widgets.dart';
import '../../components/rounded_button.dart';
import '../../authentication/welcome/welcome_screen.dart';

class WalletTab extends StatelessWidget {
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
          automaticallyImplyLeading: false,
          trailing: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: <Widget>[
                CupertinoButton(
                  padding: EdgeInsets.zero,
                  child: SettingsTab.iosIcon,
                  onPressed: () {
                    /// This pushes the settings page as a full page modal dialog on top
                    /// of the tab bar and everything.
                    Navigator.of(context, rootNavigator: true).push<void>(
                      CupertinoPageRoute(
                        title: SettingsTab.title,
                        fullscreenDialog: true,
                        builder: (context) => SettingsTab(),
                      ),
                    );
                  },
                ),
                CupertinoButton(
                  padding: EdgeInsets.zero,
                  child: ProfileTab.iosIcon,
                  onPressed: () {
                    /// This pushes the profile page as a full page modal dialog on top
                    /// of the tab bar and everything.
                    Navigator.of(context, rootNavigator: true).push<void>(
                      CupertinoPageRoute(
                        title: ProfileTab.title,
                        fullscreenDialog: true,
                        builder: (context) => ProfileTab(),
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
  static const _logoutMessage = Text(logoutDescription);

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
      text: logoutTitle,
      color: secondaryColor,
      press: () {
        /// You should do something with the result of the dialog prompt in a
        /// real app but this is just a demo.
        showDialog<void>(
          context: context,
          builder: (context) {
            return AlertDialog(
              title: Text(logoutConfirmation),
              content: _logoutMessage,
              actions: [
                FlatButton(
                  child: const Text(logoutButton),
                  onPressed: () => () async {
                    /// Navigate to the second screen using a named route.
                    Navigator.pushNamed(context, welcomeRoute);
                  },
                ),
                FlatButton(
                  child: const Text(logoutCancel),
                  onPressed: () => Navigator.pop(context),
                ),
              ],
            );
          },
        );
      },
    );
  }

  Widget _buildIos(BuildContext context) {
    return RoundedButton(
      text: logoutTitle,
      color: secondaryColor,
      press: () {
        /// You should do something with the result of the action sheet prompt
        /// in a real app but this is just a demo.
        showCupertinoModalPopup<void>(
          context: context,
          builder: (context) {
            return CupertinoActionSheet(
              title: Text(logoutConfirmation),
              message: _logoutMessage,
              actions: [
                CupertinoActionSheetAction(
                    child: const Text(logoutButton),
                    onPressed: () async {
                      /// Navigate to the second screen using a named route.
                      Navigator.pushNamed(context, welcomeRoute);
                    }),
              ],
              cancelButton: CupertinoActionSheetAction(
                child: const Text(logoutCancel),
                isDefaultAction: true,
                onPressed: () => Navigator.pop(context),
              ),
            );
          },
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
