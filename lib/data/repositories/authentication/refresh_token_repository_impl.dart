import '../../datasource/local/authentication/refresh_token_local_data_source.dart';

class RefreshTokenRepositoryImpl implements RefreshTokenRepository {
  final RefreshTokenLocalDataSource refreshTokenLocalDataSource;

  RefreshTokenRepositoryImpl({@required this.refreshTokenLocalDataSource});

  @override
  Future<String> readRefreshToken() async {
    return await refreshTokenLocalDataSource.readRefreshToken();
  }

  Future<void> writeRefreshToken(String value) async {
    return await refreshTokenLocalDataSource.writeRefreshToken(value);
  }
}
