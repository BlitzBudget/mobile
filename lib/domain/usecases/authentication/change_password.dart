import 'package:dartz/dartz.dart';
import 'package:flutter/material.dart';
import 'package:mobile_blitzbudget/core/failure/failure.dart';
import 'package:mobile_blitzbudget/core/failure/generic_failure.dart';
import 'package:mobile_blitzbudget/domain/repositories/authentication/access_token_repository.dart';
import 'package:mobile_blitzbudget/domain/repositories/authentication/change_password_repository.dart';
import 'package:mobile_blitzbudget/domain/usecases/use_case.dart';

class ChangePassword extends UseCase {
  ChangePassword(
      {@required this.changePasswordRepository,
      @required this.accessTokenRepository});

  final ChangePasswordRepository changePasswordRepository;
  final AccessTokenRepository accessTokenRepository;

  Future<Either<Failure, void>> changePassword(
      {@required String oldPassword, @required String newPassword}) async {
    final accessToken = await accessTokenRepository.readAccessToken();

    /// Access Token is Left then
    if (accessToken.isLeft()) {
      return Left(EmptyResponseFailure());
    }
    return changePasswordRepository.changePassword(
        accessToken: accessToken.getOrElse(null),
        oldPassword: oldPassword,
        newPassword: newPassword);
  }
}
