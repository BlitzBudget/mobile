import 'package:mobile_blitzbudget/domain/entities/user.dart';

abstract class UserAttributesRepository {
  Future<User> readUserAttributes();

  Future<void> writeUserAttributes(dynamic res);
}
