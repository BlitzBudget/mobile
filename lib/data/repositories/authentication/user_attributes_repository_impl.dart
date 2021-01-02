import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:mobile_blitzbudget/data/model/user_model.dart';
import 'package:mobile_blitzbudget/domain/entities/response/user_response.dart';
import 'package:mobile_blitzbudget/domain/entities/user.dart';
import 'package:mobile_blitzbudget/domain/repositories/authentication/user_attributes_repository.dart';

import '../../datasource/local/authentication/user_attributes_local_data_source.dart';

class UserAttributesRepositoryImpl implements UserAttributesRepository {
  final UserAttributesLocalDataSource userAttributesLocalDataSource;

  UserAttributesRepositoryImpl({@required this.userAttributesLocalDataSource});

  @override
  Future<User> readUserAttributes() async {
    var userJSONEncoded =
        await userAttributesLocalDataSource.readUserAttributes();

    /// Convert String to JSON and then Convert them back to User entity
    User user =
        UserModel.fromJSON(jsonDecode(userJSONEncoded) as Map<String, dynamic>);

    return user;
  }

  @override
  Future<void> writeUserAttributes(UserResponse userResponse) async {
    /// Encode the User Model as String
    var userJSONEncoded = jsonEncode(userResponse.user);

    return await userAttributesLocalDataSource
        .writeUserAttributes(userJSONEncoded);
  }
}
