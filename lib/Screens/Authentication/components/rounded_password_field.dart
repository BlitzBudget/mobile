import 'package:flutter/material.dart';
import 'text_field_container.dart';
import '../../../constants.dart';

// Public exposed class
class RoundedPassword extends StatefulWidget {
  final onChanged;
  final bool autofocus;
  final String hintText, initialValue;

  /// Constructor that accepts the onchanged variable
  const RoundedPassword(
      {Key key,
      @required this.onChanged,
      this.autofocus = false,
      this.hintText = "Password",
      this.initialValue = ""})
      : super(key: key);

  @override
  _RoundedPasswordField createState() => _RoundedPasswordField(
      this.onChanged, this.autofocus, this.hintText, this.initialValue);
}

// Private Class
class _RoundedPasswordField extends State<RoundedPassword> {
  final ValueChanged<String> onChanged;
  final bool autofocus;

  /// Initially password is obscure
  bool _obscureText;
  bool isPasswordVisible;
  final String hintText, initialValue;

  @override
  void initState() {
    _obscureText = true;
    isPasswordVisible = false;
    super.initState();
  }

  /// Constructor for the private class
  _RoundedPasswordField(
      this.onChanged, this.autofocus, this.hintText, this.initialValue);

  @override
  Widget build(BuildContext context) {
    return TextFieldContainer(
      child: TextFormField(
        initialValue: initialValue,
        obscureText: _obscureText,
        autocorrect: false,
        onChanged: onChanged,
        cursorColor: primaryColor,
        decoration: InputDecoration(
          hintText: hintText,
          icon: Icon(
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
