import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';

import '../tab/goal_tab.dart';
import '../tab/budget_tab.dart';
import '../tab/overview_tab.dart';
import '../full-screen-dialog/settings_dialog.dart';
import '../tab/transactions_tab.dart';
import '../full-screen-dialog/profile_dialog.dart';
import '../../../widgets/dashboard_widget.dart';
import '../../../constants/constants.dart';

class Body extends StatelessWidget {
  const Body({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return PlatformAdaptingHomePage();
  }
}

// Shows a different type of scaffold depending on the platform.
//
// This file has the most amount of non-sharable code since it behaves the most
// differently between the platforms.
//
// These differences are also subjective and have more than one 'right' answer
// depending on the app and content.
class PlatformAdaptingHomePage extends StatefulWidget {
  @override
  _PlatformAdaptingHomePageState createState() =>
      _PlatformAdaptingHomePageState();
}

class _PlatformAdaptingHomePageState extends State<PlatformAdaptingHomePage> {
  static const plusIcon = Icon(CupertinoIcons.plus_circle_fill,
      color: primaryColor, size: 50.0, semanticLabel: 'Add');

  /// This app keeps a global key for the transactions tab because it owns a bunch of
  /// data. Since changing platform re-parents those tabs into different
  /// scaffolds, keeping a global key to it lets this app keep that tab's data as
  /// the platform toggles.
  //
  /// This isn't needed for apps that doesn't toggle platforms while running.
  final TransactionsTabKey = GlobalKey();

  /// In Material, this app uses the hamburger menu paradigm and flatly lists
  /// all 4 possible tabs. This drawer is injected into the transactions tab which is
  /// actually building the scaffold around the drawer.
  Widget _buildAndroidHomePage(BuildContext context) {
    return TransactionsTab(
      key: TransactionsTabKey,
      androidDrawer: _AndroidDrawer(),
    );
  }

  /// On iOS, the app uses a bottom tab paradigm. Here, each tab view sits inside
  /// a tab in the tab scaffold. The tab scaffold also positions the tab bar
  /// in a row at the bottom.
  //
  /// An important thing to note is that while a Material Drawer can display a
  /// large number of items, a tab bar cannot. To illustrate one way of adjusting
  /// for this, the app folds its fourth tab (the settings page) into the
  /// third tab. This is a common pattern on iOS.
  Widget _buildIosHomePage(BuildContext context) {
    return CupertinoTabScaffold(
      tabBar: CupertinoTabBar(
        items: [
          BottomNavigationBarItem(
              title: Text(TransactionsTab.title),
              icon: TransactionsTab.iosIcon),
          BottomNavigationBarItem(
              title: Text(OverviewTab.title), icon: OverviewTab.iosIcon),
          BottomNavigationBarItem(icon: plusIcon),
          BottomNavigationBarItem(
              title: Text(BudgetTab.title), icon: BudgetTab.iosIcon),
          BottomNavigationBarItem(
              title: Text(GoalTab.title), icon: GoalTab.iosIcon),
        ],
      ),
      tabBuilder: (context, index) {
        switch (index) {
          case 0:
            return CupertinoTabView(
              defaultTitle: TransactionsTab.title,
              builder: (context) => TransactionsTab(key: TransactionsTabKey),
            );
          case 1:
            return CupertinoTabView(
              defaultTitle: OverviewTab.title,
              builder: (context) => OverviewTab(),
            );
          case 2:
          case 3:
            return CupertinoTabView(
              defaultTitle: BudgetTab.title,
              builder: (context) => BudgetTab(),
            );
          case 4:
            return CupertinoTabView(
              defaultTitle: GoalTab.title,
              builder: (context) => GoalTab(),
            );
          default:
            assert(false, 'Unexpected tab');
            return null;
        }
      },
    );
  }

  @override
  Widget build(context) {
    return PlatformWidget(
      androidBuilder: _buildAndroidHomePage,
      iosBuilder: _buildIosHomePage,
    );
  }
}

class _AndroidDrawer extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          new GestureDetector(
              onTap: () {
                Navigator.pop(context);
                Navigator.push<void>(context,
                    MaterialPageRoute(builder: (context) => ProfileDialog()));
              },
              child: DrawerHeader(
                decoration: BoxDecoration(color: Colors.green),
                child: Padding(
                  padding: const EdgeInsets.only(bottom: 20),
                  child: Icon(
                    Icons.account_circle,
                    color: Colors.green.shade800,
                    size: 96,
                  ),
                ),
              )),
          ListTile(
            leading: TransactionsTab.androidIcon,
            title: Text(TransactionsTab.title),
            onTap: () {
              Navigator.pop(context);
            },
          ),
          ListTile(
            leading: OverviewTab.androidIcon,
            title: Text(OverviewTab.title),
            onTap: () {
              Navigator.pop(context);
              Navigator.push<void>(context,
                  MaterialPageRoute(builder: (context) => OverviewTab()));
            },
          ),
          ListTile(
            leading: BudgetTab.androidIcon,
            title: Text(BudgetTab.title),
            onTap: () {
              Navigator.pop(context);
              Navigator.push<void>(context,
                  MaterialPageRoute(builder: (context) => BudgetTab()));
            },
          ),
          ListTile(
            leading: GoalTab.androidIcon,
            title: Text(GoalTab.title),
            onTap: () {
              Navigator.pop(context);
              Navigator.push<void>(
                  context, MaterialPageRoute(builder: (context) => GoalTab()));
            },
          ),

          /// Long drawer contents are often segmented.
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Divider(),
          ),
          ListTile(
            leading: SettingsDialog.androidIcon,
            title: Text(SettingsDialog.title),
            onTap: () {
              Navigator.pop(context);
              Navigator.push<void>(context,
                  MaterialPageRoute(builder: (context) => SettingsDialog()));
            },
          ),
        ],
      ),
    );
  }
}
