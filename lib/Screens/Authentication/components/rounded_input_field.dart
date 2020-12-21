import 'package:flutter/material.dart';
import 'text_field_container.dart';
import '../../../constants.dart';

class RoundedInputField extends StatelessWidget {
  final String hintText, initialValue;
  final IconData icon;
  final ValueChanged<String> onChanged;
  final bool autofocus;
  const RoundedInputField(
      {Key key,
      this.hintText,
      this.icon = Icons.person,
      this.onChanged,
      this.autofocus,
      this.initialValue = ""})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TextFieldContainer(
      child: TextFormField(
        initialValue: initialValue,
        autofocus: autofocus,
        onChanged: onChanged,
        cursorColor: primaryColor,
        decoration: InputDecoration(
          icon: Icon(
            icon,
            color: primaryColor,
          ),
          hintText: hintText,
          border: InputBorder.none,
        ),
      ),
    );
  }
}
