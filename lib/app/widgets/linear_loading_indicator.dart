import 'package:flutter/material.dart';
import '../app/constants/constants.dart';

class LinearLoadingIndicator extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return LinearProgressIndicator(
        backgroundColor: primaryLightColor,
        valueColor: new AlwaysStoppedAnimation<Color>(primaryDisabledColor));
  }
}
