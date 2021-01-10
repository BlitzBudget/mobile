import 'dart:convert';

import 'package:dartz/dartz.dart';
import 'package:flutter/foundation.dart';
import 'package:mobile_blitzbudget/core/error/api_exception.dart';
import 'package:mobile_blitzbudget/core/error/generic_exception.dart';
import 'package:mobile_blitzbudget/core/failure/failure.dart';
import 'package:mobile_blitzbudget/data/datasource/remote/authentication/user_attributes_remote_data_source.dart';
import 'package:mobile_blitzbudget/data/model/user_model.dart';
import 'package:mobile_blitzbudget/domain/entities/response/user_response.dart';
import 'package:mobile_blitzbudget/domain/entities/user.dart';
import 'package:mobile_blitzbudget/domain/repositories/authentication/user_attributes_repository.dart';

import '../../datasource/local/authentication/user_attributes_local_data_source.dart';

class UserAttributesRepositoryImpl implements UserAttributesRepository {
  final UserAttributesLocalDataSource userAttributesLocalDataSource;
  final UserAttributesRemoteDataSource userAttributesRemoteDataSource;

  UserAttributesRepositoryImpl(
      {@required this.userAttributesLocalDataSource,
      @required this.userAttributesRemoteDataSource});

  @override
  Future<Either<Failure, User>> readUserAttributes() async {
    try {
      var userJSONEncoded =
          await userAttributesLocalDataSource.readUserAttributes();

      /// Convert String to JSON and then Convert them back to User entity
      var user =
          User.fromJSON(jsonDecode(userJSONEncoded) as Map<String, dynamic>);
      return Right(user);
    } on Exception catch (e) {
      return Left(GenericException.convertExceptionToFailure(e));
    }
  }

  @override
  Future<void> writeUserAttributes(UserResponse userResponse) async {
    /// Encode the User Model as String
    var userJSONEncoded = jsonEncode(userResponse.user);

    return await userAttributesLocalDataSource
        .writeUserAttributes(userJSONEncoded);
  }

  @override
  Future<Either<Failure, void>> updateUserAttributes(User user) async {
    try {
      return Right(await userAttributesRemoteDataSource
          .updateUserAttributes(user as UserModel));
    } on Exception catch (e) {
      return Left(APIException.convertExceptionToFailure(e));
    }
  }
}
