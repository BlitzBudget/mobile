import '../user.dart';

class UserResponse {
  String refreshToken;
  String authenticationToken;
  String accessToken;
  User user;

  UserResponse(
      {this.refreshToken,
      this.authenticationToken,
      this.accessToken,
      this.user});
}
