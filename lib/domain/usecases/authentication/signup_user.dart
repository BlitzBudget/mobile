// TODO
/*
import 'package:devicelocale/devicelocale.dart';
if (isEmpty(confirmPassword)) {
      displayDialog(
          context, 'Empty Password', 'The confirm password cannot be empty');
      return;
    } else if (!passwordExp.hasMatch(confirmPassword)) {
      displayDialog(
          context, 'Invalid Password', 'The confirm password is not valid');
      return;
    } else if (confirmPassword != password) {
      displayDialog(context, 'Password Mismatch',
          'The confirm password and the password do not match');
      return;
    }*/

/*
    /// Convert email to lowercase and trim
    email = email.toLowerCase().trim();
    var fullname = email.split('@')[0];
    var names = fetchNames(fullname);

    /// Add accept language headers
    headers['Accept-Language'] = await Devicelocale.currentLocale;
*/

/*
/// Parse the user name with Email
  _Name fetchNames(String fullname) {
    Match match = emailExp.firstMatch(fullname);
    _Name name;

    if (match == null) {
      developer.log('No match found for $fullname');

      /// Sur name cannot be empty
      name = _Name(fullname, ' ');
    } else {
      /// TODO SPLIT the name and then assign it to first and surname
      name = _Name(fullname, ' ');
      developer.log(
          'Fullname $fullname, First match: ${match.start}, end Match: ${match.input}');
    }

    return name;
  }*/
