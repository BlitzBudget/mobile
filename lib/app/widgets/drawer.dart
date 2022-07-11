import 'package:flutter/material.dart';

import 'package:mobile_blitzbudget/app/constants/theme.dart';

import 'package:mobile_blitzbudget/app/widgets/drawer_tile.dart';

class ArgonDrawer extends StatelessWidget {
  const ArgonDrawer({Key? key, required this.currentPage}) : super(key: key);

  final String currentPage;

  @override
  Widget build(BuildContext context) {
    return Drawer(
        child: Container(
      color: ArgonColors.white,
      child: Column(children: [
        Container(
            height: MediaQuery.of(context).size.height * 0.1,
            width: MediaQuery.of(context).size.width * 0.85,
            child: SafeArea(
              bottom: false,
              child: Align(
                alignment: Alignment.bottomLeft,
                child: Padding(
                  padding: const EdgeInsets.only(left: 32),
                  child: Image.asset('assets/img/argon-logo.png'),
                ),
              ),
            )),
        Expanded(
          flex: 2,
          child: ListView(
            padding: const EdgeInsets.only(top: 24, left: 16, right: 16),
            children: [
              DrawerTile(
                  icon: Icons.home,
                  onTap: () {
                    if (currentPage != 'Home') {
                      Navigator.pushReplacementNamed(context, '/home');
                    }
                  },
                  iconColor: ArgonColors.primary,
                  title: 'Home',
                  isSelected: currentPage == 'Home'),
              DrawerTile(
                  icon: Icons.pie_chart,
                  onTap: () {
                    if (currentPage != 'Profile') {
                      Navigator.pushReplacementNamed(context, '/profile');
                    }
                  },
                  iconColor: ArgonColors.warning,
                  title: 'Profile',
                  isSelected: currentPage == 'Profile'),
              DrawerTile(
                  icon: Icons.account_circle,
                  onTap: () {
                    if (currentPage != 'Account') {
                      Navigator.pushReplacementNamed(context, '/account');
                    }
                  },
                  iconColor: ArgonColors.info,
                  title: 'Account',
                  isSelected: currentPage == 'Account'),
              DrawerTile(
                  icon: Icons.settings_input_component,
                  onTap: () {
                    if (currentPage != 'Elements') {
                      Navigator.pushReplacementNamed(context, '/elements');
                    }
                  },
                  iconColor: ArgonColors.error,
                  title: 'Elements',
                  isSelected: currentPage == 'Elements'),
              DrawerTile(
                  icon: Icons.apps,
                  onTap: () {
                    if (currentPage != 'Articles') {
                      Navigator.pushReplacementNamed(context, '/articles');
                    }
                  },
                  iconColor: ArgonColors.primary,
                  title: 'Articles',
                  isSelected: currentPage == 'Articles'),
            ],
          ),
        ),
        Expanded(
          child: Container(
              padding: const EdgeInsets.only(left: 8, right: 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Divider(
                      height: 4, thickness: 0, color: ArgonColors.muted),
                  const Padding(
                    padding: EdgeInsets.only(top: 16, left: 16, bottom: 8),
                    child: Text('DOCUMENTATION',
                        style: TextStyle(
                          color: Color.fromRGBO(0, 0, 0, 0.5),
                          fontSize: 15,
                        )),
                  ),
                  DrawerTile(
                    icon: Icons.airplanemode_active,
                    iconColor: ArgonColors.muted,
                    title: 'Getting Started',
                    isSelected: currentPage == 'Getting started',
                    onTap: () {
                      if (currentPage != 'Home') {
                        Navigator.pushReplacementNamed(context, '/home');
                      }
                    },
                  ),
                ],
              )),
        ),
      ]),
    ));
  }
}
