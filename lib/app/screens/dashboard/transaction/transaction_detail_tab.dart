import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../../widgets/dashboard_widget.dart';

/// Page shown when a card in the transactions tab is tapped.
///
/// On Android, this page sits at the top of your app. On iOS, this page is on
/// top of the transactions tab's content but is below the tab bar itself.
class TransactionDetailTab extends StatelessWidget {
  const TransactionDetailTab({Key? key, this.id, this.transaction, this.color})
      : super(key: key);

  final int? id;
  final String? transaction;
  final Color? color;

  /// ===========================================================================
  /// Non-shared code below because we're using different scaffolds.
  /// ===========================================================================

  Widget _buildAndroid(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(transaction!)),
      body: _buildBody(),
    );
  }

  Widget _buildIos(BuildContext context) {
    return CupertinoPageScaffold(
      navigationBar: CupertinoNavigationBar(
        middle: Text(transaction!),
        previousPageTitle: 'Transactions',
      ),
      child: _buildBody(),
    );
  }

  @override
  Widget build(context) {
    return PlatformWidget(
      androidBuilder: _buildAndroid,
      iosBuilder: _buildIos,
    );
  }

  Widget _buildBody() {
    return SafeArea(
      bottom: false,
      left: false,
      right: false,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Hero(
            tag: id!,

            /// This app uses a flightShuttleBuilder to specify the exact widget
            /// to build while the hero transition is mid-flight.
            //
            /// It could either be specified here or in transactionsTab.
            flightShuttleBuilder: (context, animation, flightDirection,
                fromHeroContext, toHeroContext) {
              return HeroAnimatingTransactionCard(
                transaction: transaction,
                color: color,
                heroAnimation: animation,
              );
            },
            child: HeroAnimatingTransactionCard(
              transaction: transaction,
              color: color,
              heroAnimation: const AlwaysStoppedAnimation(1),
            ),
          ),
          const Divider(
            height: 0,
            color: Colors.grey,
          ),
          Expanded(
            child: ListView.builder(
              itemCount: 10,
              itemBuilder: (context, index) {
                if (index == 0) {
                  return const Padding(
                    padding: EdgeInsets.only(left: 15, top: 16, bottom: 8),
                    child: Text(
                      'You might also like:',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  );
                }

                /// Just a bunch of boxes that simulates loading transaction choices.
                return const TransactionPlaceHolderTile();
              },
            ),
          ),
        ],
      ),
    );
  }
}
