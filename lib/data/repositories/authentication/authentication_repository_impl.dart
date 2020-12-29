import '../../datasource/local/authentication/authentication_local_data_source.dart';

class AuthenticationRepositoryImpl implements AuthenticationRepository {
  final AuthenticationLocalDataSource authenticationLocalDataSource;

  AuthenticationRepositoryImpl({@required this.authenticationLocalDataSource});

  @override
  Future<String> readAuthentication() async {
    return await authenticationLocalDataSource.readAuthentication();
  }

  Future<void> writeAuthentication(String value) async {
    return await authenticationLocalDataSource.writeAuthentication(value);
  }
}
