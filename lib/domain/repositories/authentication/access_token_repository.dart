import 'package:mobile_blitzbudget/domain/entities/response/user_response.dart';

abstract class AccessTokenRepository {
  Future<String> readAccessToken();

  Future<void> writeAccessToken(UserResponse userResponse);
}
