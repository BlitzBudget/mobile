import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_lorem/flutter_lorem.dart';
import 'package:mobile_blitzbudget/app/ploc/dashboard/overview/overview_bloc.dart';
import 'package:mobile_blitzbudget/app/screens/dashboard/overview/overview_screen.dart';

import '../../../../widgets/dashboard_widget.dart';

class Body extends StatefulWidget {
  const Body({
    Key? key,
  }) : super(key: key);

  @override
  _BodyState createState() => _BodyState();
}

class _BodyState extends State<Body> {
  static const _itemsLength = 20;

  late List<String> titles;
  late List<String> contents;

  @override
  void initState() {
    _dispatchFetch();
    titles = List.generate(_itemsLength, (index) => 'generateRandomHeadline()');
    contents =
        List.generate(_itemsLength, (index) => lorem(paragraphs: 1, words: 24));
    super.initState();
  }

  void _dispatchFetch() {
    BlocProvider.of<OverviewBloc>(context).add(const Fetch());
  }

  Widget _listBuilder(BuildContext context, int index) {
    if (index >= _itemsLength) {
      return Container();
    }

    return SafeArea(
      top: false,
      bottom: false,
      child: Card(
        elevation: 1.5,
        margin: const EdgeInsets.fromLTRB(6, 12, 6, 0),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(4),
        ),
        child: InkWell(
          /// Make it splash on Android. It would happen automatically if this
          /// was a real card but this is just a demo. Skip the splash on iOS.
          onTap: defaultTargetPlatform == TargetPlatform.iOS ? null : () {},
          child: Padding(
            padding: const EdgeInsets.all(12),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                CircleAvatar(
                  backgroundColor: Colors.black,
                  child: Text(
                    titles[index].substring(0, 1),
                    style: const TextStyle(color: Colors.white),
                  ),
                ),
                const Padding(padding: EdgeInsets.only(left: 16)),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        titles[index],
                        style: const TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      const Padding(padding: EdgeInsets.only(top: 8)),
                      Text(
                        contents[index],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  /// ===========================================================================
  /// Non-shared code below because this tab uses different scaffolds.
  /// ===========================================================================

  Widget _buildAndroid(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(OverviewScreen.title),
      ),
      body: ListView.builder(
        itemBuilder: _listBuilder,
      ),
    );
  }

  Widget _buildIos(BuildContext context) {
    return CupertinoPageScaffold(
      navigationBar: const CupertinoNavigationBar(),
      child: ListView.builder(
        itemBuilder: _listBuilder,
      ),
    );
  }

  @override
  Widget build(context) {
    debugPrint('The Overview tab has been clicked');

    return PlatformWidget(
      androidBuilder: _buildAndroid,
      iosBuilder: _buildIos,
    );
  }
}
