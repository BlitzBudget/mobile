abstract class AuthTokenRepository {
  Future<String> readAuthToken();

  Future<void> writeAuthToken(String value);
}
