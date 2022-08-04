import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mobile_blitzbudget/app/constants/constants.dart';
import 'package:mobile_blitzbudget/app/ploc/dashboard/transaction/transaction_bloc.dart';
import 'package:mobile_blitzbudget/app/screens/authentication/components/rounded_input_field.dart';
import 'package:mobile_blitzbudget/app/screens/authentication/forgot-password/components/background.dart';
import 'package:mobile_blitzbudget/app/widgets/linear_loading_indicator.dart';
import 'package:mobile_blitzbudget/app/widgets/rounded_button.dart';

// Public exposed class
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
  String? description;
  double amount = 0;
  final login = 'Add Transaction';
  final amountText = 'Amount';
  final descriptionText = 'Description';
  String continueButton = 'Add Transactions';

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return BlocConsumer<TransactionBloc, TransactionState>(
        listener: (context, state) {
      debugPrint('The Login listener has been called');
      continueButton = 'Add Transactions';
      _btnEnabled = true;

      if (state is Success) {
        Navigator.pushNamed(context, dashboardRoute);
      } else if (state is Error) {
        // TODO Print error
        debugPrint('The Login encountered an error ${state.message}');
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
                  login,
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
              ),
              SizedBox(height: size.height * 0.03),
              RoundedInputField(
                  hintText: descriptionText,
                  onChanged: (value) {
                    description = value;
                  },
                  autofocus: true),
              RoundedInputField(
                  hintText: amountText,
                  textInputType: TextInputType.number,
                  onChanged: (value) {
                    amount = double.parse(value);
                  },
                  autofocus: true),
              RoundedButton(
                text: continueButton,

                /// Disable press if button is disabled
                press: () async {
                  _dispatchAddTransaction();
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

  void _dispatchAddTransaction() {
    BlocProvider.of<TransactionBloc>(context)
        .add(Add(amount: amount, description: description));
  }
}
