import 'dart:developer' as developer;

import '../../utils/utils.dart';

class User {
  String userId;
  String email;
  String name;
  String fileFormat;
  String locale;
  String familyName;

  User(
      {this.userId,
      this.email,
      this.name,
      this.locale,
      this.familyName,
      this.fileFormat});

  factory User.fromJSON(Map<String, dynamic> userAttributes) {
    var currentUserLocal = extractUserAttributes(userAttributes);
    return User(
        userId = currentUserLocal["financialPortfolioId"],
        email = currentUserLocal["email"],
        name = currentUserLocal["name"],
        locale = currentUserLocal["locale"],
        fileFormat = currentUserLocal["exportFileFormat"],
        familyName = currentUserLocal["family_name"]);
  }

  Map extractUserAttributes(Map<String, dynamic> userAttributes) {
    Map currentUserLocal;

    /// SUCCESS Scenarios
    for (var i = 0; i < userAttributes.length; i++) {
      String name = userAttributes[i]['Name'];
      developer.log('Printing User Attributes $name');

      if (name.contains('custom:')) {
        /// if custom values then remove custom:
        String elemName = lastElement(splitElement(name, ':'));
        developer.log('User:: The elemName is $elemName');
        currentUserLocal[elemName] = userAttributes[i]['Value'];
      } else {
        currentUserLocal[name] = userAttributes[i]['Value'];
      }
    }
    return currentUserLocal;
  }

  Map<String, dynamic> toJSON() => <String, dynamic>{
        'userid': userId,
        'email': email,
        'name': name,
        'locale': locale,
        'fileformat': fileFormat,
        'familyname': familyName,
      };
}
