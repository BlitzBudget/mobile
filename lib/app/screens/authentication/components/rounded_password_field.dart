import 'package:flutter/material.dart';

import '../../../constants/constants.dart';
import 'text_field_container.dart';

// Public exposed class
class RoundedPassword extends StatefulWidget {
  /// Constructor that accepts the onchanged variable
  const RoundedPassword(
      {Key key,
      @required this.onChanged,
      this.autofocus = false,
      this.hintText = 'Password',
      this.initialValue = ''})
      : super(key: key);

  final ValueChanged<String> onChanged;
  final bool autofocus;
  final String hintText, initialValue;

  @override
  _RoundedPasswordField createState() => _RoundedPasswordField();
}

// Private Class
class _RoundedPasswordField extends State<RoundedPassword> {
  /// Constructor for the private class
  _RoundedPasswordField();

  /// Initially password is obscure
  bool _obscureText;
  bool isPasswordVisible;

  @override
  void initState() {
    _obscureText = true;
    isPasswordVisible = false;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return TextFieldContainer(
      child: TextFormField(
        initialValue: widget.initialValue,
        obscureText: _obscureText,
        autocorrect: false,
        onChanged: widget.onChanged,
        cursorColor: primaryColor,
        decoration: InputDecoration(
          hintText: widget.hintText,
          icon: const Icon(
            Icons.lock,
            color: primaryColor,
          ),
          suffixIcon: IconButton(
            icon: Icon(
              isPasswordVisible ? Icons.visibility : Icons.visibility_off,
              color: primaryColor,
            ),
            onPressed: onPressVisibility,
          ),
          border: InputBorder.none,
        ),
      ),
    );
  }

  /// Toggles the password show status
  void onPressVisibility() {
    setState(() {
      /// Is password visible
      isPasswordVisible = !isPasswordVisible;

      /// Obscure text
      _obscureText = !_obscureText;
    });
  }
}
