import 'package:flutter/material.dart';

import '../../../constants/constants.dart';
import 'text_field_container.dart';

class RoundedInputField extends StatelessWidget {
  const RoundedInputField(
      {Key? key,
      this.hintText,
      this.icon = Icons.person,
      this.onChanged,
      this.autofocus,
      this.textInputType = TextInputType.text,
      this.initialValue = ''})
      : super(key: key);

  final String? hintText, initialValue;
  final IconData icon;
  final ValueChanged<String>? onChanged;
  final bool? autofocus;
  final TextInputType textInputType;

  @override
  Widget build(BuildContext context) {
    return TextFieldContainer(
      child: TextFormField(
        initialValue: initialValue,
        keyboardType: textInputType,
        autofocus: autofocus!,
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
