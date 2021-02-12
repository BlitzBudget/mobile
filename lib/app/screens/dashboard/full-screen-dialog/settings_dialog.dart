import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../../widgets/dashboard_widget.dart';

class SettingsDialog extends StatefulWidget {
  const SettingsDialog({
    Key key,
  }) : super(key: key);

  static const title = 'Settings';
  static const androidIcon = Icon(Icons.settings);
  static const iosIcon = Icon(CupertinoIcons.gear);

  @override
  _SettingsDialogState createState() => _SettingsDialogState();
}

class _SettingsDialogState extends State<SettingsDialog> {
  var switch1 = false;
  var switch2 = true;
  var switch3 = true;
  var switch4 = true;
  var switch5 = true;
  var switch6 = false;
  var switch7 = true;

  Widget _buildList() {
    final size = MediaQuery.of(context).size;
    return ListView(
      children: [
        const Padding(padding: EdgeInsets.only(top: 24)),
        const ListTile(
          title: Text(
            'General',
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
        ),
        SizedBox(height: size.height * 0.01),
        ListTile(
          title: const Text('Categories'),

          /// The Material switch has a platform adaptive constructor.
          trailing: Switch.adaptive(
            value: switch1,
            onChanged: (value) => setState(() => switch1 = value),
          ),
        ),
        ListTile(
          title: const Text('Currency'),
          trailing: Switch.adaptive(
            value: switch2,
            onChanged: (value) => setState(() => switch2 = value),
          ),
        ),
        ListTile(
          title: const Text('Notifications'),
          trailing: Switch.adaptive(
            value: switch5,
            onChanged: (value) => setState(() => switch5 = value),
          ),
        ),
        ListTile(
          title: const Text('Language'),
          trailing: Switch.adaptive(
            value: switch6,
            onChanged: (value) => setState(() => switch6 = value),
          ),
        ),
        ListTile(
          title: const Text('Country'),
          trailing: Switch.adaptive(
            value: switch6,
            onChanged: (value) => setState(() => switch6 = value),
          ),
        ),
        SizedBox(height: size.height * 0.01),
        const ListTile(
          title: Text(
            'Extra Security',
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
        ),
        SizedBox(height: size.height * 0.01),
        ListTile(
          title: const Text('Passcode'),
          trailing: Switch.adaptive(
            value: switch3,
            onChanged: (value) => setState(() => switch3 = value),
          ),
        ),
        ListTile(
          title: const Text('Face ID'),
          trailing: Switch.adaptive(
            value: switch4,
            onChanged: (value) => setState(() => switch4 = value),
          ),
        ),
        SizedBox(height: size.height * 0.01),
        const ListTile(
          title: Text(
            'Got a question?',
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
        ),
        SizedBox(height: size.height * 0.01),
        ListTile(
          title: const Text('Help center'),
          trailing: Switch.adaptive(
            value: switch3,
            onChanged: (value) => setState(() => switch3 = value),
          ),
        ),
        ListTile(
          title: const Text('Ask a question'),
          trailing: Switch.adaptive(
            value: switch4,
            onChanged: (value) => setState(() => switch4 = value),
          ),
        ),
        ListTile(
          title: const Text('Send a feature request'),
          trailing: Switch.adaptive(
            value: switch4,
            onChanged: (value) => setState(() => switch4 = value),
          ),
        ),
      ],
    );
  }

  /// ===========================================================================
  /// Non-shared code below because this tab uses different scaffolds.
  /// ===========================================================================

  Widget _buildAndroid(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(SettingsDialog.title),
      ),
      body: _buildList(),
    );
  }

  Widget _buildIos(BuildContext context) {
    return CupertinoPageScaffold(
      navigationBar: const CupertinoNavigationBar(),
      child: _buildList(),
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
