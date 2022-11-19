import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mobile_blitzbudget/app/constants/constants.dart';
import 'package:mobile_blitzbudget/app/ploc/dashboard/goal/goal_bloc.dart';
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
  double currentAmount = 0;
  double targetAmount = 0;
  String? targetDate;
  String? goalName;

  final login = 'Add Goal';
  final currentAmountText = 'Current Amount';
  final targetAmountText = 'Target Amount';
  final targetDateText = 'Target Date';
  final goalNameText = 'Goal Name';
  String continueButton = 'Add Goals';

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return BlocConsumer<GoalBloc, GoalState>(listener: (context, state) {
      debugPrint('The Goal listener has been called');
      continueButton = 'Add Goals';
      _btnEnabled = true;

      if (state is Success) {
        Navigator.pushNamed(context, dashboardRoute);
      } else if (state is Error) {
        // TODO Print error
        debugPrint('The Goal encountered an error ${state.message}');
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
                  hintText: currentAmountText,
                  textInputType: TextInputType.number,
                  onChanged: (value) {
                    currentAmount = double.parse(value);
                  },
                  autofocus: true),
              RoundedInputField(
                hintText: targetAmountText,
                textInputType: TextInputType.number,
                onChanged: (value) {
                  targetAmount = double.parse(value);
                },
              ),
              RoundedInputField(
                hintText: targetDateText,
                textInputType: TextInputType.datetime,
                onChanged: (value) {
                  targetDate = value;
                },
              ),
              RoundedInputField(
                hintText: goalNameText,
                onChanged: (value) {
                  goalName = value;
                },
              ),
              RoundedButton(
                text: continueButton,

                /// Disable press if button is disabled
                press: () async {
                  _dispatchAddGoal();
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

  void _dispatchAddGoal() {
    BlocProvider.of<GoalBloc>(context).add(Add(
        currentAmount: currentAmount,
        targetAmount: targetAmount,
        targetDate: targetDate,
        goalName: goalName));
  }
}
