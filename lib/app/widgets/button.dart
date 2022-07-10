import 'package:flutter/material.dart';

const double defaultBorderRadius = 3;

class StretchableButton extends StatelessWidget {
  const StretchableButton({
    Key? key,
    required this.buttonColor,
    required this.borderRadius,
    required this.children,
    required this.splashColor,
    required this.buttonBorderColor,
    required this.onPressed,
    required this.buttonPadding,
  }) : super(key: key);

  final VoidCallback onPressed;
  final double borderRadius;
  final double buttonPadding;
  final Color buttonColor, splashColor;
  final Color buttonBorderColor;
  final List<Widget> children;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final contents = List<Widget>.from(children);

        if (constraints.minWidth == 0) {
          contents.add(const SizedBox.shrink());
        } else {
          contents.add(const Spacer());
        }

        final bs = BorderSide(
          color: buttonBorderColor,
        );

        return ButtonTheme(
          height: 40,
          padding: EdgeInsets.all(buttonPadding),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(borderRadius),
            side: bs,
          ),
          child: ElevatedButton(
            onPressed: onPressed,
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: contents,
            ),
          ),
        );
      },
    );
  }
}
