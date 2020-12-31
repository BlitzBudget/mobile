abstract class AuthTokenRepository {
  Future<String> readAuthToken();

  Future<void> writeAuthToken(dynamic res);
}
