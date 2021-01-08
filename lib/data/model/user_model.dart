import 'dart:developer' as developer;

import 'package:mobile_blitzbudget/domain/entities/user.dart';

import 'package:mobile_blitzbudget/core/utils/utils.dart';

class UserModel extends User {
  UserModel(
      {String userId,
      String email,
      String name,
      String fileFormat,
      String locale,
      String familyName})
      : super(
            userId: userId,
            email: email,
            name: name,
            locale: locale,
            familyName: familyName,
            fileFormat: fileFormat);

  factory UserModel.fromJSON(List<dynamic> userAttributes) {
    var currentUserLocal = extractUserAttributes(userAttributes);
    return UserModel(
        userId: currentUserLocal['financialPortfolioId'] as String,
        email: currentUserLocal['email'] as String,
        name: currentUserLocal['name'] as String,
        locale: currentUserLocal['locale'] as String,
        fileFormat: currentUserLocal['exportFileFormat'] as String,
        familyName: currentUserLocal['family_name'] as String);
  }

  Map<String, dynamic> toJSON() => <String, dynamic>{
        'email': email,
        'name': name,
        'locale': locale,
        'family_name': familyName,
        'exportFileFormat': fileFormat
      };

  static Map extractUserAttributes(List<dynamic> userAttributes) {
    Map currentUserLocal = <String, dynamic>{};

    /// SUCCESS Scenarios
    for (var i = 0; i < userAttributes.length; i++) {
      var name = userAttributes[i]['Name'] as String;
      developer.log('Printing User Attributes $name');

      if (name.contains('custom:')) {
        /// if custom values then remove custom:
        var elemName = lastElement(splitElement(name, ':')) as String;
        developer.log('User:: The elemName is $elemName');
        currentUserLocal[elemName] = userAttributes[i]['Value'];
      } else {
        currentUserLocal[name] = userAttributes[i]['Value'];
      }
    }
    return currentUserLocal;
  }
}
