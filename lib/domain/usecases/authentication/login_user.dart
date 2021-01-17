import 'package:dartz/dartz.dart';
import 'package:flutter/foundation.dart';
import 'package:mobile_blitzbudget/core/failure/failure.dart';
import 'package:mobile_blitzbudget/core/failure/generic_failure.dart';
import 'package:mobile_blitzbudget/domain/entities/response/user_response.dart';
import 'package:mobile_blitzbudget/domain/repositories/authentication/access_token_repository.dart';
import 'package:mobile_blitzbudget/domain/repositories/authentication/auth_token_repository.dart';
import 'package:mobile_blitzbudget/domain/repositories/authentication/authentication_repository.dart';
import 'package:mobile_blitzbudget/domain/repositories/authentication/refresh_token_repository.dart';
import 'package:mobile_blitzbudget/domain/repositories/authentication/user_attributes_repository.dart';
import 'package:mobile_blitzbudget/domain/usecases/use_case.dart';

class LoginUser extends UseCase {
  final AuthenticationRepository authenticationRepository;
  final UserAttributesRepository userAttributesRepository;
  final RefreshTokenRepository refreshTokenRepository;
  final AccessTokenRepository accessTokenRepository;
  final AuthTokenRepository authTokenRepository;

  LoginUser(
      {@required this.authenticationRepository,
      @required this.userAttributesRepository,
      @required this.refreshTokenRepository,
      @required this.accessTokenRepository,
      @required this.authTokenRepository});

  Future<Either<Failure, Option<UserResponse>>> loginUser(
      {@required String email, @required String password}) async {
    /// Change all the email to lower case and trim the string
    email = email.toLowerCase().trim();

    var response = await authenticationRepository.loginUser(
        email: email, password: password); // Either<Failure, UserResponse>

    if (response.isRight()) {
      var userResponse = response.getOrElse(null);

      /// If the user information is empty then
      if (userResponse.isNone()) {
        return Left(EmptyResponseFailure());
      }

      var user = userResponse.getOrElse(null);

      /// Store User Attributes
      await userAttributesRepository.writeUserAttributes(user);

      /// Store Refresh Token
      await refreshTokenRepository.writeRefreshToken(user);

      /// Store Access Token
      await accessTokenRepository.writeAccessToken(user);

      /// Store Auth Token
      await authTokenRepository.writeAuthToken(user);
    }

    return response;
  }
}

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

/// Navigate to the second screen using a named route.
/*Navigator.pushNamed(context, constants.dashboardRoute);*/
