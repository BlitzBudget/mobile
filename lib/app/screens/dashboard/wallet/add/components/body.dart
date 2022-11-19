// Public exposed class
import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mobile_blitzbudget/app/constants/constants.dart';
import 'package:mobile_blitzbudget/app/ploc/dashboard/wallet/wallet_bloc.dart';
import 'package:mobile_blitzbudget/app/screens/authentication/components/rounded_input_field.dart';
import 'package:mobile_blitzbudget/app/screens/dashboard/wallet/add/components/background.dart';
import 'package:mobile_blitzbudget/app/widgets/linear_loading_indicator.dart';
import 'package:mobile_blitzbudget/app/widgets/rounded_button.dart';

class Body extends StatefulWidget {
  /// In the constructor
  const Body({Key? key}) : super(key: key);

  @override
  _BodyState createState() => _BodyState();
}

class _BodyState extends State<Body> {
  /// States
  bool _btnEnabled = true;

  TextEditingController? controller;
  String? name;
  String? currency;
  final addButtonText = 'Add Wallet';
  final currencyText = 'Currency';
  final nameText = 'Name';
  String continueButton = 'Add Wallet';

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return BlocConsumer<WalletBloc, WalletState>(listener: (context, state) {
      debugPrint('The Wallet listener has been called');
      continueButton = 'Add Wallet';
      _btnEnabled = true;

      if (state is Success) {
        Navigator.pushNamed(context, dashboardRoute);
      } else if (state is Error) {
        // TODO Print error
        debugPrint('The Wallet encountered an error ${state.message}');
      } else if (state is Loading) {
        continueButton = 'Loading';
        _btnEnabled = false;
      }
    }, builder: (context, state) {
      return Background(
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              ///  Linear Progress indicator for loading
              /// Show text only when the button is enabled
              Visibility(
                visible: _btnEnabled,
                replacement: const LinearLoadingIndicator(),
                child: Text(
                  addButtonText,
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
              ),
              SizedBox(height: size.height * 0.03),
              RoundedInputField(
                  hintText: currencyText,
                  onChanged: (value) {
                    currency = value;
                  },
                  autofocus: true),
              RoundedInputField(
                  hintText: nameText,
                  onChanged: (value) {
                    name = value;
                  },
                  autofocus: true),
              RoundedButton(
                text: continueButton,

                /// Disable press if button is disabled
                press: () async {
                  _dispatchAddWallet();
                },
                enabled: _btnEnabled,
              ),
              SizedBox(height: size.height * 0.03),
            ],
          ),
        ),
      );
    });
  }

  void _dispatchAddWallet() {
    BlocProvider.of<WalletBloc>(context)
        .add(Add(currency: currency, walletName: name));
  }
}
