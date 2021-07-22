import 'package:dartz/dartz.dart';
import 'package:mobile_blitzbudget/core/failure/failure.dart';

mixin ChangePasswordRepository {
  Future<Either<Failure, void>> changePassword(
      {String? accessToken, String? newPassword, String? oldPassword});
}
