import 'package:mobile_blitzbudget/domain/entities/response/user_response.dart';

abstract class AuthTokenRepository {
  Future<String> readAuthToken();

  Future<void> writeAuthToken(UserResponse userResponse);
}
