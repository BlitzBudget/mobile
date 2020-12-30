import 'package:flutter/foundation.dart';
import 'package:mobile_blitzbudget/domain/repositories/authentication/access_token_repository.dart'
    show AccessTokenRepository;

import '../../datasource/local/authentication/access_token_local_data_source.dart';

class AccessTokenRepositoryImpl implements AccessTokenRepository {
  final AccessTokenLocalDataSource accessTokenLocalDataSource;

  AccessTokenRepositoryImpl({@required this.accessTokenLocalDataSource});

  @override
  Future<String> readAccessToken() async {
    return await accessTokenLocalDataSource.readAccessToken();
  }

  @override
  Future<void> writeAccessToken(String value) async {
    return await accessTokenLocalDataSource.writeAccessToken(value);
  }
}
