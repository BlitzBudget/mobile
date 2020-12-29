import '../../datasource/local/authentication/auth_token_local_data_source.dart';

class AuthTokenRepositoryImpl implements AuthTokenRepository {
  final AuthTokenLocalDataSource authTokenLocalDataSource;

  AuthTokenRepositoryImpl({@required this.authTokenLocalDataSource});

  @override
  Future<String> readAuthToken() async {
    return await authTokenLocalDataSource.readAuthToken();
  }

  Future<void> writeAuthToken(String value) async {
    return await authTokenLocalDataSource.writeAuthToken(value);
  }
}
