import 'package:mobile_blitzbudget/data/model/user_model.dart';
import 'package:mobile_blitzbudget/data/utils/data_utils.dart';
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
        refreshToken: parseDynamicToString(
            userResponseModel['AuthenticationResult']['RefreshToken']),
        authenticationToken: parseDynamicToString(
            userResponseModel['AuthenticationResult']['IdToken']),
        accessToken: parseDynamicToString(
            userResponseModel['AuthenticationResult']['AccessToken']),
        user: UserModel.fromJSON(
            userResponseModel['UserAttributes'] as List<dynamic>));
  }
}
