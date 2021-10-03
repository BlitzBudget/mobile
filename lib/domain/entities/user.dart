import 'package:equatable/equatable.dart';

class User extends Equatable {
  const User(
      {this.userId,
      this.email,
      this.name,
      this.locale,
      this.familyName,
      this.fileFormat});

  factory User.fromJSON(Map<String, dynamic> userAttributes) {
    return User(
        userId: userAttributes['user_id'],
        email: userAttributes['email'],
        name: userAttributes['name'],
        locale: userAttributes['locale'],
        fileFormat: userAttributes['exportFileFormat'],
        familyName: userAttributes['family_name']);
  }

  Map<String, dynamic> toJSONForUser() => <String, dynamic>{
        'email': email,
        'name': name,
        'locale': locale,
        'family_name': familyName,
        'exportFileFormat': fileFormat,
        'user_id': userId
      };

  final String? userId;
  final String? email;
  final String? name;
  final String? fileFormat;
  final String? locale;
  final String? familyName;

  @override
  List<Object?> get props =>
      [userId, email, name, fileFormat, locale, familyName];
}
