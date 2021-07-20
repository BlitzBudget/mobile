import 'package:flutter/material.dart';
import '../constants/constants.dart';

class RoundedButton extends StatelessWidget {
  const RoundedButton({
    Key key,
    this.text,
    this.press,
    this.color = primaryColor,
    this.textColor = Colors.black,
    this.enabled = true,
    this.disabledColor = primaryDisabledColor,
  }) : super(key: key);

  final String text;
  final Function press;
  final Color color, textColor, disabledColor;
  final bool enabled;

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 10),
      width: size.width * 0.8,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(29),
        child: ElevatedButton(
          onPressed: enabled ? press : null,
          child: Text(
            text,
            style: TextStyle(color: textColor),
          ),
        ),
      ),
    );
  }
}
