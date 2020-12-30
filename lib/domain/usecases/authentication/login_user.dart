import 'package:mobile_blitzbudget/data/model/user.dart';
import 'package:mobile_blitzbudget/domain/repositories/authentication/access_token_repository.dart';
import 'package:mobile_blitzbudget/domain/repositories/authentication/auth_token_repository.dart';
import 'package:mobile_blitzbudget/domain/repositories/authentication/authentication_repository.dart';
import 'package:mobile_blitzbudget/domain/repositories/authentication/refresh_token_repository.dart';
import 'package:mobile_blitzbudget/domain/repositories/authentication/user_attributes_repository.dart';

class LoginUser {
  AuthenticationRepository authenticationRepository;
  UserAttributesRepository userAttributesRepository;
  RefreshTokenRepository refreshTokenRepository;
  AccessTokenRepository accessTokenRepository;
  AuthTokenRepository authTokenRepository;

  Future<dynamic> attemptLogin(String email, String password) async {
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

    dynamic res = await authenticationRepository.attemptLogin(email, password);

    /// User
    var user = User.fromJSON(res['UserAttributes'] as Map<String, dynamic>);

    /// Store User Attributes
    await userAttributesRepository.writeUserAttributes(user);

    /// Store Refresh Token
    await refreshTokenRepository.writeRefreshToken(res);

    /// Store Access Token
    await accessTokenRepository.writeAccessToken(res);

    /// Store Auth Token
    await authTokenRepository.writeAuthToken(res);

    /// Navigate to the second screen using a named route.
    /*Navigator.pushNamed(context, constants.dashboardRoute);*/
  }
}
