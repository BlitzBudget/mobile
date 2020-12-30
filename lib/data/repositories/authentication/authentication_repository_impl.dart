import 'package:flutter/foundation.dart';
import 'package:mobile_blitzbudget/domain/repositories/authentication/authentication_repository.dart';

import '../../datasource/remote/authentication_remote_data_source.dart';

class AuthenticationRepositoryImpl implements AuthenticationRepository {
  final AuthenticationRemoteDataSource authenticationRemoteDataSource;

  AuthenticationRepositoryImpl({@required this.authenticationRemoteDataSource});

  @override
  Future<String> readAuthentication() async {
    return await authenticationRemoteDataSource.readAuthentication();
  }

  @override
  Future<void> writeAuthentication(String value) async {
    return await authenticationRemoteDataSource.writeAuthentication(value);
  }
}
