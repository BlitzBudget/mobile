import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:mobile_blitzbudget/app/constants/theme.dart';
import 'package:mobile_blitzbudget/app/widgets/drawer.dart';
import 'package:mobile_blitzbudget/app/widgets/navbar.dart';

import '../../../constants/constants.dart';
import '../../../widgets/dashboard_widget.dart';
import '../../../widgets/rounded_button.dart';

class ProfileDialog extends StatelessWidget {
  const ProfileDialog({
    Key? key,
  }) : super(key: key);

  static const title = 'Profile';
  static const androidIcon = Icon(Icons.person);
  static const iosIcon = Icon(CupertinoIcons.profile_circled);

  Widget _buildBodyAlternative(BuildContext context) {
    return Scaffold(
        extendBodyBehindAppBar: true,
        appBar: const Navbar(
          title: 'Profile',
          transparent: true,
        ),
        backgroundColor: ArgonColors.bgColorScreen,
        drawer: const ArgonDrawer(currentPage: 'Profile'),
        body: Stack(children: <Widget>[
          Container(
              decoration: const BoxDecoration(
                  image: DecorationImage(
                      alignment: Alignment.topCenter,
                      image: AssetImage('assets/images/profile-screen-bg.png'),
                      fit: BoxFit.fitWidth))),
          SafeArea(
            child: ListView(children: [
              Padding(
                padding: const EdgeInsets.only(left: 16, right: 16, top: 74),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Stack(children: <Widget>[
                      Container(
                        decoration: BoxDecoration(
                          boxShadow: [
                            BoxShadow(
                              color: Colors.grey.withOpacity(0.1),
                              spreadRadius: 1,
                              blurRadius: 7,
                              offset: const Offset(
                                  0, 3), // changes position of shadow
                            ),
                          ],
                        ),
                        child: Card(
                            clipBehavior: Clip.antiAliasWithSaveLayer,
                            elevation: 0,
                            shape: const RoundedRectangleBorder(
                                borderRadius:
                                    BorderRadius.all(Radius.circular(5))),
                            child: Padding(
                              padding:
                                  const EdgeInsets.only(top: 85, bottom: 20),
                              child: Row(
                                children: [
                                  Expanded(
                                    child: Column(
                                      children: [
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: [
                                            Container(
                                              decoration: BoxDecoration(
                                                color: ArgonColors.info,
                                                borderRadius:
                                                    BorderRadius.circular(3),
                                                boxShadow: [
                                                  BoxShadow(
                                                    color: Colors.grey
                                                        .withOpacity(0.3),
                                                    spreadRadius: 1,
                                                    blurRadius: 7,
                                                    offset: const Offset(0,
                                                        3), // changes position of shadow
                                                  ),
                                                ],
                                              ),
                                              padding:
                                                  const EdgeInsets.symmetric(
                                                      horizontal: 8,
                                                      vertical: 8),
                                              child: const Text(
                                                'CONNECT',
                                                style: TextStyle(
                                                    color: ArgonColors.white,
                                                    fontSize: 12,
                                                    fontWeight:
                                                        FontWeight.bold),
                                              ),
                                            ),
                                            const SizedBox(
                                              width: 30,
                                            ),
                                            Container(
                                              decoration: BoxDecoration(
                                                color: ArgonColors.initial,
                                                borderRadius:
                                                    BorderRadius.circular(3),
                                                boxShadow: [
                                                  BoxShadow(
                                                    color: Colors.grey
                                                        .withOpacity(0.3),
                                                    spreadRadius: 1,
                                                    blurRadius: 7,
                                                    offset: const Offset(0,
                                                        3), // changes position of shadow
                                                  ),
                                                ],
                                              ),
                                              padding:
                                                  const EdgeInsets.symmetric(
                                                      horizontal: 8,
                                                      vertical: 8),
                                              child: const Text(
                                                'MESSAGE',
                                                style: TextStyle(
                                                    color: ArgonColors.white,
                                                    fontSize: 12,
                                                    fontWeight:
                                                        FontWeight.bold),
                                              ),
                                            )
                                          ],
                                        ),
                                        const SizedBox(height: 40),
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceAround,
                                          children: [
                                            Column(
                                              children: const [
                                                Text('2K',
                                                    style: TextStyle(
                                                        color: Color.fromRGBO(
                                                            82, 95, 127, 1),
                                                        fontSize: 20,
                                                        fontWeight:
                                                            FontWeight.bold)),
                                                Text('Orders',
                                                    style: TextStyle(
                                                        color: Color.fromRGBO(
                                                            50, 50, 93, 1),
                                                        fontSize: 12))
                                              ],
                                            ),
                                            Column(
                                              children: const [
                                                Text('10',
                                                    style: TextStyle(
                                                        color: Color.fromRGBO(
                                                            82, 95, 127, 1),
                                                        fontSize: 20,
                                                        fontWeight:
                                                            FontWeight.bold)),
                                                Text('Photos',
                                                    style: TextStyle(
                                                        color: Color.fromRGBO(
                                                            50, 50, 93, 1),
                                                        fontSize: 12))
                                              ],
                                            ),
                                            Column(
                                              children: const [
                                                Text('89',
                                                    style: TextStyle(
                                                        color: Color.fromRGBO(
                                                            82, 95, 127, 1),
                                                        fontSize: 20,
                                                        fontWeight:
                                                            FontWeight.bold)),
                                                Text('Comments',
                                                    style: TextStyle(
                                                        color: Color.fromRGBO(
                                                            50, 50, 93, 1),
                                                        fontSize: 12))
                                              ],
                                            )
                                          ],
                                        ),
                                        const SizedBox(height: 40),
                                        const Align(
                                          child: Text('Jessica Jones, 27',
                                              style: TextStyle(
                                                  color: Color.fromRGBO(
                                                      50, 50, 93, 1),
                                                  fontSize: 28)),
                                        ),
                                        const SizedBox(height: 10),
                                        const Align(
                                          child: Text('San Francisco, USA',
                                              style: TextStyle(
                                                  color: Color.fromRGBO(
                                                      50, 50, 93, 1),
                                                  fontSize: 18,
                                                  fontWeight: FontWeight.w200)),
                                        ),
                                        const Divider(
                                          height: 40,
                                          thickness: 1.5,
                                          indent: 32,
                                          endIndent: 32,
                                        ),
                                        const Padding(
                                          padding: EdgeInsets.only(
                                              left: 32, right: 32),
                                          child: Align(
                                            child: Text(
                                                'An artist of considerable range, Jessica name taken by Melbourne...',
                                                textAlign: TextAlign.center,
                                                style: TextStyle(
                                                    color: Color.fromRGBO(
                                                        82, 95, 127, 1),
                                                    fontSize: 17,
                                                    fontWeight:
                                                        FontWeight.w200)),
                                          ),
                                        ),
                                        const SizedBox(height: 15),
                                        const Align(
                                            child: Text('Show more',
                                                style: TextStyle(
                                                    color: ArgonColors.primary,
                                                    fontWeight: FontWeight.w400,
                                                    fontSize: 16))),
                                        const SizedBox(height: 25),
                                        Padding(
                                          padding: const EdgeInsets.only(
                                              right: 25, left: 25),
                                          child: Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            children: const [
                                              Text(
                                                'Album',
                                                style: TextStyle(
                                                    fontWeight: FontWeight.bold,
                                                    fontSize: 16,
                                                    color: ArgonColors.text),
                                              ),
                                              Text(
                                                'View All',
                                                style: TextStyle(
                                                    color: ArgonColors.primary,
                                                    fontSize: 13,
                                                    fontWeight:
                                                        FontWeight.w600),
                                              ),
                                            ],
                                          ),
                                        ),
                                        SizedBox(
                                          height: 250,
                                          child: GridView.count(
                                              primary: false,
                                              padding:
                                                  const EdgeInsets.symmetric(
                                                      horizontal: 24,
                                                      vertical: 15),
                                              crossAxisSpacing: 10,
                                              mainAxisSpacing: 10,
                                              crossAxisCount: 3,
                                              children: <Widget>[
                                                Container(
                                                    height: 100,
                                                    decoration:
                                                        const BoxDecoration(
                                                      borderRadius:
                                                          BorderRadius.all(
                                                              Radius.circular(
                                                                  6)),
                                                      image: DecorationImage(
                                                          image: NetworkImage(
                                                              'https://images.unsplash.com/photo-1501601983405-7c7cabaa1581?fit=crop&w=240&q=80'),
                                                          fit: BoxFit.cover),
                                                    )),
                                                Container(
                                                    decoration:
                                                        const BoxDecoration(
                                                  borderRadius:
                                                      BorderRadius.all(
                                                          Radius.circular(6)),
                                                  image: DecorationImage(
                                                      image: NetworkImage(
                                                          'https://images.unsplash.com/photo-1543747579-795b9c2c3ada?fit=crop&w=240&q=80hoto-1501601983405-7c7cabaa1581?fit=crop&w=240&q=80'),
                                                      fit: BoxFit.cover),
                                                )),
                                                Container(
                                                    decoration:
                                                        const BoxDecoration(
                                                  borderRadius:
                                                      BorderRadius.all(
                                                          Radius.circular(6)),
                                                  image: DecorationImage(
                                                      image: NetworkImage(
                                                          'https://images.unsplash.com/photo-1551798507-629020c81463?fit=crop&w=240&q=80'),
                                                      fit: BoxFit.cover),
                                                )),
                                                Container(
                                                    decoration:
                                                        const BoxDecoration(
                                                  borderRadius:
                                                      BorderRadius.all(
                                                          Radius.circular(6)),
                                                  image: DecorationImage(
                                                      image: NetworkImage(
                                                          'https://images.unsplash.com/photo-1470225620780-dba8ba36b745?fit=crop&w=240&q=80'),
                                                      fit: BoxFit.cover),
                                                )),
                                                Container(
                                                    decoration:
                                                        const BoxDecoration(
                                                  borderRadius:
                                                      BorderRadius.all(
                                                          Radius.circular(6)),
                                                  image: DecorationImage(
                                                      image: NetworkImage(
                                                          'https://images.unsplash.com/photo-1503642551022-c011aafb3c88?fit=crop&w=240&q=80'),
                                                      fit: BoxFit.cover),
                                                )),
                                                Container(
                                                    decoration:
                                                        const BoxDecoration(
                                                  borderRadius:
                                                      BorderRadius.all(
                                                          Radius.circular(6)),
                                                  image: DecorationImage(
                                                      image: NetworkImage(
                                                          'https://images.unsplash.com/photo-1482686115713-0fbcaced6e28?fit=crop&w=240&q=80'),
                                                      fit: BoxFit.cover),
                                                )),
                                              ]),
                                        )
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            )),
                      ),
                      const FractionalTranslation(
                          translation: Offset(0, -0.5),
                          child: Align(
                            alignment: FractionalOffset(0.5, 0),
                            child: CircleAvatar(
                              backgroundImage: AssetImage(
                                  'assets/images/profile-screen-avatar.jpg'),
                              radius: 65,
                              // maxRadius: 200.0,
                            ),
                          )),
                      const LogOutButton(),
                    ]),
                  ],
                ),
              ),
            ]),
          ),
        ]));
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
      body: _buildBodyAlternative(context),
    );
  }

  Widget _buildIos(BuildContext context) {
    return CupertinoPageScaffold(
      navigationBar: const CupertinoNavigationBar(),
      child: _buildBodyAlternative(context),
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
  const PreferenceCard(
      {Key? key, this.header, this.content, this.preferenceChoices})
      : super(key: key);

  final String? header;
  final String? content;
  final List<String>? preferenceChoices;

  @override
  Widget build(BuildContext context) {
    return PressableCard(
      color: Colors.green,
      flattenAnimation: const AlwaysStoppedAnimation(0),
      onPressed: () {
        showChoices(context, preferenceChoices);
      },
      child: Stack(
        children: [
          Container(
            height: 120,
            width: 250,
            child: Padding(
              padding: const EdgeInsets.only(top: 40),
              child: Center(
                child: Text(
                  content!,
                  style: const TextStyle(fontSize: 48),
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
              padding: const EdgeInsets.only(left: 12),
              alignment: Alignment.centerLeft,
              child: Text(
                header!,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class LogOutButton extends StatelessWidget {
  const LogOutButton({
    Key? key,
  }) : super(key: key);

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
              title: const Text(logoutConfirmation),
              content: _logoutMessage,
              actions: [
                TextButton(
                  onPressed: () => () async {
                    await _logoutAndRedirect(context);
                  },
                  child: const Text(logoutButton),
                ),
                TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: const Text(logoutCancel),
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
              title: const Text(logoutConfirmation),
              message: _logoutMessage,
              actions: [
                CupertinoActionSheetAction(
                  onPressed: () async {
                    await _logoutAndRedirect(context);
                  },
                  child: const Text(logoutButton),
                )
              ],
              cancelButton: CupertinoActionSheetAction(
                isDefaultAction: true,
                onPressed: () => Navigator.pop(context),
                child: const Text(logoutCancel),
              ),
            );
          },
        );
      },
    );
  }

  @override
  Widget build(context) {
    debugPrint('The Profile dialog has been clicked');

    return PlatformWidget(
      androidBuilder: _buildAndroid,
      iosBuilder: _buildIos,
    );
  }

  /// Remove Storage and Redirect to Welcome screeen
  Future<void> _logoutAndRedirect(BuildContext context) async {
    /// Create storage
    /// Delete all
    await const FlutterSecureStorage().deleteAll();

    /// Navigate to the second screen using a named route.
    await Navigator.pushNamed(context, welcomeRoute);
  }
}
