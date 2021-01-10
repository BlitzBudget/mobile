import 'package:dartz/dartz.dart';
import 'package:flutter/material.dart';
import 'package:mobile_blitzbudget/core/failure/failure.dart';
import 'package:mobile_blitzbudget/core/failure/generic-failure.dart';
import 'package:mobile_blitzbudget/domain/repositories/authentication/access_token_repository.dart';
import 'package:mobile_blitzbudget/domain/repositories/authentication/change_password_repository.dart';
import 'package:mobile_blitzbudget/domain/usecases/use_case.dart';

class ChangePassword extends UseCase {
  ChangePasswordRepository changePasswordRepository;
  AccessTokenRepository accessTokenRepository;

  Future<Either<Failure, void>> changePassword(
      {@required String oldPassword, @required String newPassword}) async {
    var accessToken = await accessTokenRepository.readAccessToken();

    /// Access Token is Left then
    if (accessToken.isLeft()) {
      return Left(EmptyResponseFailure());
    }
    return await changePasswordRepository.changePassword(
        accessToken.getOrElse(null), oldPassword, newPassword);
  }
}
