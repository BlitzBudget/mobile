import 'package:flutter/material.dart';
import '../constants/constants.dart';

class LinearLoadingIndicator extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return LinearProgressIndicator(
        backgroundColor: primaryLightColor,
        valueColor: AlwaysStoppedAnimation<Color>(primaryDisabledColor));
  }
}
