import 'package:flutter/material.dart';
import 'package:mobile_blitzbudget/components/text_field_container.dart';
import 'package:mobile_blitzbudget/constants.dart';

// Public exposed class
class RoundedPassword extends StatefulWidget {
  final onChanged;

  // Constructor that accepts the onchanged variable
  const RoundedPassword({
    Key key,
    @required this.onChanged
  }) : super(key: key);

  @override
  _RoundedPasswordField createState() => _RoundedPasswordField(this.onChanged);

}

// Private Class
class _RoundedPasswordField extends State<RoundedPassword> {
  final ValueChanged<String> onChanged;
  // Initially password is obscure
  bool _obscureText;
  bool isPasswordVisible;

  @override
  void initState() {
      _obscureText = true;
      isPasswordVisible = false;
      super.initState();
  }

  // Constructor for the private class
  _RoundedPasswordField(this.onChanged);

  @override
  Widget build(BuildContext context) {
    return TextFieldContainer(
      child: TextField(
        obscureText: _obscureText,
        onChanged: onChanged,
        cursorColor: primaryColor,
        decoration: InputDecoration(
          hintText: "Password",
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
          border: InputBorder.none
        ),
      ),
    );
  }

  // Toggles the password show status
  void onPressVisibility() {
    setState(() {
      isPasswordVisible = !isPasswordVisible;
      _obscureText = !_obscureText;
    });
  }
}
