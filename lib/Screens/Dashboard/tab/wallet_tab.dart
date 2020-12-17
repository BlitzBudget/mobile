import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'package:mobile_blitzbudget/Screens/Dashboard/tab/settings_tab.dart';
import 'package:mobile_blitzbudget/Screens/Dashboard/tab/profile_tab.dart';
import 'package:mobile_blitzbudget/Screens/Authentication/Welcome/welcome_screen.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:mobile_blitzbudget/utils/widgets.dart';
import 'package:mobile_blitzbudget/constants.dart';

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
                    /// This pushes the settings page as a full page modal dialog on top
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
