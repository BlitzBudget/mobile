import 'package:flutter/foundation.dart' show required;
import 'package:mobile_blitzbudget/domain/entities/response/user_response.dart';
import 'package:mobile_blitzbudget/domain/repositories/authentication/auth_token_repository.dart';

import '../../datasource/local/authentication/auth_token_local_data_source.dart'
    show AuthTokenLocalDataSource;

class AuthTokenRepositoryImpl implements AuthTokenRepository {
  final AuthTokenLocalDataSource authTokenLocalDataSource;

  AuthTokenRepositoryImpl({@required this.authTokenLocalDataSource});

  @override
  Future<String> readAuthToken() async {
    return await authTokenLocalDataSource.readAuthToken();
  }

  @override
  Future<void> writeAuthToken(UserResponse userResponse) async {
    return await authTokenLocalDataSource
        .writeAuthToken(userResponse.authenticationToken);
  }
}
