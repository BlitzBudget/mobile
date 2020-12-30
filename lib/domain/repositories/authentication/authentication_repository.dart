abstract class AuthenticationRepository {
  Future<String> readAuthentication();

  Future<void> writeAuthentication(String value);
}
