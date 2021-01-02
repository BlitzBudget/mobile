import 'package:mobile_blitzbudget/data/model/user_model.dart';
import 'package:mobile_blitzbudget/domain/entities/response/user_response.dart';
import 'package:mobile_blitzbudget/domain/entities/user.dart';

class UserResponseModel extends UserResponse {
  UserResponseModel(
      {String refreshToken,
      String authenticationToken,
      String accessToken,
      User user})
      : super(
            refreshToken: refreshToken,
            authenticationToken: authenticationToken,
            accessToken: accessToken,
            user: user);

  factory UserResponseModel.fromJSON(Map<String, dynamic> userResponseModel) {
    return UserResponseModel(
        refreshToken:
            userResponseModel['AuthenticationResult']['RefreshToken'] as String,
        authenticationToken:
            userResponseModel['AuthenticationResult']['IdToken'] as String,
        accessToken:
            userResponseModel['AuthenticationResult']['AccessToken'] as String,
        user: UserModel.fromJSON(
            userResponseModel['UserAttributes'] as Map<String, dynamic>));
  }
}
