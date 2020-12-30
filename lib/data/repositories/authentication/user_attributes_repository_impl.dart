import 'package:flutter/foundation.dart';
import 'package:mobile_blitzbudget/domain/repositories/authentication/user_attributes_repository.dart';

import '../../datasource/local/authentication/user_attributes_local_data_source.dart';

class UserAttributesRepositoryImpl implements UserAttributesRepository {
  final UserAttributesLocalDataSource userAttributesLocalDataSource;

  UserAttributesRepositoryImpl({@required this.userAttributesLocalDataSource});

  @override
  Future<String> readUserAttributes() async {
    return await userAttributesLocalDataSource.readUserAttributes();
  }

  @override
  Future<void> writeUserAttributes(String value) async {
    return await userAttributesLocalDataSource.writeUserAttributes(value);
  }
}
