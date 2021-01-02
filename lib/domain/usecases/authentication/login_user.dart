import 'package:dartz/dartz.dart';
import 'package:flutter/foundation.dart';
import 'package:mobile_blitzbudget/core/failure/failure.dart';
import 'package:mobile_blitzbudget/core/failure/generic-failure.dart';
import 'package:mobile_blitzbudget/domain/entities/response/user_response.dart';
import 'package:mobile_blitzbudget/domain/repositories/authentication/access_token_repository.dart';
import 'package:mobile_blitzbudget/domain/repositories/authentication/auth_token_repository.dart';
import 'package:mobile_blitzbudget/domain/repositories/authentication/authentication_repository.dart';
import 'package:mobile_blitzbudget/domain/repositories/authentication/refresh_token_repository.dart';
import 'package:mobile_blitzbudget/domain/repositories/authentication/user_attributes_repository.dart';
import 'package:mobile_blitzbudget/domain/usecases/use_case.dart';
import 'package:mobile_blitzbudget/utils/utils.dart';

class LoginUser extends UseCase {
  AuthenticationRepository authenticationRepository;
  UserAttributesRepository userAttributesRepository;
  RefreshTokenRepository refreshTokenRepository;
  AccessTokenRepository accessTokenRepository;
  AuthTokenRepository authTokenRepository;

  Future<Either<Failure, UserResponse>> attemptLogin(
      {@required String email, @required String password}) async {
    /*if (isEmpty(email)) {
      displayDialog(context, 'Empty Email', 'The email cannot be empty');
      return null;
    } else if (!EmailValidator.validate(email.trim())) {
      displayDialog(context, 'Invalid Email', 'The email is not valid');
      return null;
    } else if (isEmpty(password)) {
      displayDialog(context, 'Empty Password', 'The password cannot be empty');
      return null;
    } else if (!passwordExp.hasMatch(password)) {
      displayDialog(context, 'Invalid Password', 'The password is not valid');
      return null;
    }*/

    var res = await authenticationRepository.attemptLogin(
        email, password); // Either<Failure, UserResponse>

    if (res.isRight()) {
      var user = res.getOrElse(null);

      /// If the user information is empty then
      if (user == null) {
        return Left(EmptyResponseFailure());
      }

      /// Store User Attributes
      await userAttributesRepository.writeUserAttributes(user);

      /// Store Refresh Token
      await refreshTokenRepository.writeRefreshToken(user);

      /// Store Access Token
      await accessTokenRepository.writeAccessToken(user);

      /// Store Auth Token
      await authTokenRepository.writeAuthToken(user);
    }

    /// Navigate to the second screen using a named route.
    /*Navigator.pushNamed(context, constants.dashboardRoute);*/
  }
}
