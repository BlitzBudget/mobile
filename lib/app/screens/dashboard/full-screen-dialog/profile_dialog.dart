import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

import 'settings_dialog.dart';
import '../../authentication/welcome/welcome_screen.dart';
import '../../../widgets/dashboard_widget.dart';
import '../../../../utils/utils.dart';
import '../../../../main.dart';
import '../../../constants/constants.dart';
import '../../../../app/widgets/rounded_button.dart';

class ProfileDialog extends StatelessWidget {
  static const title = 'Profile';
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
            PreferenceCard(
              header: 'MY INTENSITY PREFERENCE',
              content: '🔥',
              preferenceChoices: [
                'Super heavy',
                'Dial it to 11',
                "Head bangin'",
                '1000W',
                'My neighbor hates me',
              ],
            ),
            PreferenceCard(
              header: 'CURRENT MOOD',
              content: '🤘🏾🚀',
              preferenceChoices: [
                'Over the moon',
                'Basking in sunlight',
                'Hello fellow Martians',
                'Into the darkness',
              ],
            ),
            Expanded(
              child: Container(),
            ),
            LogOutButton(),
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
      navigationBar: CupertinoNavigationBar(),
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

class PreferenceCard extends StatelessWidget {
  const PreferenceCard({this.header, this.content, this.preferenceChoices});

  final String header;
  final String content;
  final List<String> preferenceChoices;

  @override
  Widget build(context) {
    return PressableCard(
      color: Colors.green,
      flattenAnimation: AlwaysStoppedAnimation(0),
      child: Stack(
        children: [
          Container(
            height: 120,
            width: 250,
            child: Padding(
              padding: EdgeInsets.only(top: 40),
              child: Center(
                child: Text(
                  content,
                  style: TextStyle(fontSize: 48),
                ),
              ),
            ),
          ),
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            child: Container(
              color: Colors.black12,
              height: 40,
              padding: EdgeInsets.only(left: 12),
              alignment: Alignment.centerLeft,
              child: Text(
                header,
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ),
        ],
      ),
      onPressed: () {
        showChoices(context, preferenceChoices);
      },
    );
  }
}

class LogOutButton extends StatelessWidget {
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
                    logoutAndRedirect(context: context);
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
                      logoutAndRedirect(context: context);
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

  /// Remove Storage and Redirect to Welcome screeen
  void logoutAndRedirect(BuildContext context) async {
    /// Create storage
    /// Delete all
    await new FlutterSecureStorage().deleteAll();

    if (isEmpty(context)) {
      /// Navigate using the global navigation key
      navigatorKey.currentState.pushNamed(welcomeRoute);
    } else {
      /// Navigate to the second screen using a named route.
      Navigator.pushNamed(context, welcomeRoute);
    }
  }
}
