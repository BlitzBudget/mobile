import 'package:flutter/material.dart';
import '../constants/constants.dart';

class LinearLoadingIndicator extends StatelessWidget {
  const LinearLoadingIndicator({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const LinearProgressIndicator(
        backgroundColor: primaryLightColor,
        valueColor: AlwaysStoppedAnimation<Color>(primaryDisabledColor));
  }
}
