import 'package:mobile_blitzbudget/data/model/user.dart';

abstract class AuthenticationRepository {
  Future<dynamic> attemptLogin(String email, String password);
}
