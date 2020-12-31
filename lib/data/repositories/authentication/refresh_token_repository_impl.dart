import 'package:flutter/foundation.dart';
import 'package:mobile_blitzbudget/domain/repositories/authentication/refresh_token_repository.dart';

import '../../datasource/local/authentication/refresh_token_local_data_source.dart';

class RefreshTokenRepositoryImpl implements RefreshTokenRepository {
  final RefreshTokenLocalDataSource refreshTokenLocalDataSource;

  RefreshTokenRepositoryImpl({@required this.refreshTokenLocalDataSource});

  @override
  Future<String> readRefreshToken() async {
    return await refreshTokenLocalDataSource.readRefreshToken();
  }

  @override
  Future<void> writeRefreshToken(dynamic res) async {
    // Convert Response from the server to Refresh Token String
    var refreshToken = res['AuthenticationResult']['RefreshToken'] as String;
    return await refreshTokenLocalDataSource.writeRefreshToken(refreshToken);
  }
}
