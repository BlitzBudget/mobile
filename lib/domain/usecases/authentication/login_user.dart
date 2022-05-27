import 'package:dartz/dartz.dart';
import 'package:mobile_blitzbudget/core/failure/failure.dart';
import 'package:mobile_blitzbudget/core/failure/generic_failure.dart';
import 'package:mobile_blitzbudget/data/model/response/user_response_model.dart';
import 'package:mobile_blitzbudget/domain/entities/response/user_response.dart';
import 'package:mobile_blitzbudget/domain/repositories/authentication/access_token_repository.dart';
import 'package:mobile_blitzbudget/domain/repositories/authentication/auth_token_repository.dart';
import 'package:mobile_blitzbudget/domain/repositories/authentication/authentication_repository.dart';
import 'package:mobile_blitzbudget/domain/repositories/authentication/refresh_token_repository.dart';
import 'package:mobile_blitzbudget/domain/repositories/authentication/user_attributes_repository.dart';
import 'package:mobile_blitzbudget/domain/usecases/use_case.dart';

class LoginUser extends UseCase {
  LoginUser(
      {required this.authenticationRepository,
      required this.userAttributesRepository,
      required this.refreshTokenRepository,
      required this.accessTokenRepository,
      required this.authTokenRepository});

  final AuthenticationRepository? authenticationRepository;
  final UserAttributesRepository? userAttributesRepository;
  final RefreshTokenRepository? refreshTokenRepository;
  final AccessTokenRepository? accessTokenRepository;
  final AuthTokenRepository? authTokenRepository;

  Future<Either<Failure, Option<UserResponse>>> loginUser(
      {required String email, required String? password}) async {
    final response = await authenticationRepository!.loginUser(
        email: email, password: password); // Either<Failure, UserResponse>

    if (response.isRight()) {
      final userResponse = response.getOrElse(() => const None());

      /// If the user information is empty then
      if (userResponse.isNone()) {
        return Left(EmptyResponseFailure());
      }

      final user = cast<UserResponse>(
          userResponse.getOrElse(() => const UserResponseModel()));

      /// Store User Attributes
      await userAttributesRepository!.writeUserAttributes(user);

      /// Store Refresh Token
      await refreshTokenRepository!.writeRefreshToken(user);

      /// Store Access Token
      await accessTokenRepository!.writeAccessToken(user);

      /// Store Auth Token
      await authTokenRepository!.writeAuthToken(user);
    }

    return response;
  }
}
