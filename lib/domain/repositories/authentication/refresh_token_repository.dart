abstract class RefreshTokenRepository {
  Future<String> readRefreshToken();

  Future<void> writeRefreshToken(String value);
}
