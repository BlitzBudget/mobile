abstract class AccessTokenRepository {
  Future<String> readAccessToken();

  Future<void> writeAccessToken(dynamic res);
}
