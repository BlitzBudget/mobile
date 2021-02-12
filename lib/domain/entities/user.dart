import 'package:equatable/equatable.dart';

class User extends Equatable {
  const User(
      {this.userId,
      this.email,
      this.name,
      this.locale,
      this.familyName,
      this.fileFormat});

  final String userId;
  final String email;
  final String name;
  final String fileFormat;
  final String locale;
  final String familyName;

  @override
  List<Object> get props =>
      [userId, email, name, fileFormat, locale, familyName];
}
