import 'dart:developer' as developer;

import 'package:mobile_blitzbudget/domain/entities/user.dart';

import 'package:mobile_blitzbudget/core/utils/utils.dart';

class UserModel extends User {
  const UserModel(
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
    final currentUserLocal = extractUserAttributes(userAttributes);
    return UserModel(
        userId: currentUserLocal['financialPortfolioId'],
        email: currentUserLocal['email'],
        name: currentUserLocal['name'],
        locale: currentUserLocal['locale'],
        fileFormat: currentUserLocal['exportFileFormat'],
        familyName: currentUserLocal['family_name']);
  }

  Map<String, dynamic> toJSON() => <String, dynamic>{
        'username': email,
        'name': name,
        'locale': locale,
        'family_name': familyName,
        'exportFileFormat': fileFormat
      };

  static Map<String, dynamic> extractUserAttributes(
      List<dynamic> userAttributes) {
    final currentUserLocal = <String, dynamic>{};

    /// SUCCESS Scenarios
    for (var i = 0; i < userAttributes.length; i++) {
      final name = userAttributes[i]['Name'];
      developer.log('Printing User Attributes $name');

      if (name.contains('custom:')) {
        /// if custom values then remove custom:
        final elemName = lastElement(
            splitElement(stringToSplit: name, character: ':')
                .getOrElse(() => <String>[])).getOrElse(() => '');
        developer.log('User:: The elemName is $elemName');
        currentUserLocal[elemName] = userAttributes[i]['Value'];
      } else {
        currentUserLocal[name] = userAttributes[i]['Value'];
      }
    }
    return currentUserLocal;
  }
}
