abstract class AuthenticationRepository {
  Future<dynamic> attemptLogin(String email, String password);
}
