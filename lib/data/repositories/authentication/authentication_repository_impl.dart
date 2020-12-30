import 'package:flutter/foundation.dart';
import 'package:mobile_blitzbudget/data/model/user.dart';
import 'package:mobile_blitzbudget/domain/repositories/authentication/authentication_repository.dart';

import '../../datasource/remote/authentication_remote_data_source.dart';

class AuthenticationRepositoryImpl implements AuthenticationRepository {
  final AuthenticationRemoteDataSource authenticationRemoteDataSource;

  AuthenticationRepositoryImpl({@required this.authenticationRemoteDataSource});

  @override
  Future<dynamic> attemptLogin(String email, String password) async {
    return await authenticationRemoteDataSource.attemptLogin(email, password);
  }
}
