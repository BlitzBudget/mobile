import 'package:mobile_blitzbudget/domain/entities/response/user_response.dart';

abstract class RefreshTokenRepository {
  Future<String> readRefreshToken();

  Future<void> writeRefreshToken(UserResponse userResponse);
}
