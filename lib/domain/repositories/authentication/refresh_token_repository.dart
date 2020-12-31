abstract class RefreshTokenRepository {
  Future<String> readRefreshToken();

  Future<void> writeRefreshToken(dynamic res);
}
