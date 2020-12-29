import 'network_helper.dart';
import '../../main.dart';
import '../../app/routes.dart';

class RefreshTokenHelper {
 final RefreshTokenRepository refreshTokenRepository;
 final AuthTokenRepository authTokenRepository;
    final AccessTokenRepository accessTokenRepository;
    final NetworkHelper networkHelper = NetworkHelper();

    RefreshTokenHelper(this.refreshTokenRepository, this.authTokenRepository, this.accessTokenRepository);
// Refresh Token
  static final refreshTokenURI =
      authentication.baseURL + '/profile/refresh-token';

  /// Refresh authorization token
  ///
  /// If successful call the API again
  /// If unsuccessful then logout
  Future<dynamic> refreshAuthToken(String url, {Map headers, body, encoding}) async {
    debugPrint(
        " The authorization token has expired, Trying to refresh the token.");

    /// Store Access token and Authentication Token
    final refreshToken = refreshTokenRepository.readRefreshToken();

    return http
        .post(refreshTokenURI,
            body: jsonEncode({"refreshToken": refreshToken}),
            headers: headers,
            encoding: encoding)
        .then((http.Response response) async {
      final int statusCode = response.statusCode;
      final res = _decoder.convert(response.body);
      debugPrint(
          " The response code is ${statusCode.toString()} with the response $res");

      /// Check if the status code is error
      if (statusCode < 200 || statusCode > 400 || response == null) {
        debugPrint(
            "Error while fetching data with status code ${statusCode.toString()}");

        /// Logout And Redirect User
        clearAllStorageRepositoryImpl.clearAllStorage();
        /// Navigate using the global navigation key
        navigatorKey.currentState.pushNamed(welcomeRoute);
        return;
      }

      debugPrint(" The authorization token has been refreshed successfully.");

      /// Store Auth Token
      authTokenRepository.writeAuthToken(res["AuthenticationResult"]["IdToken"]);

      /// Store Access Token
      accessTokenRepository.writeAccessToken(res["AuthenticationResult"]["AccessToken"]);

      // Set the new Authorization header
      headers['Authorization'] = res["AuthenticationResult"]["IdToken"];

      switch (apiCallToMake) {
        case "Patch":
          // Call the PATCH again
          return networkHelper.patch(url, body: body, headers: headers, encoding: encoding);
        case "Put":
          // Call the POST again
          return networkHelper.put(url, body: body, headers: headers, encoding: encoding);
        case "Post":
        default:
          // Call the POST again
          return networkHelper.post(url, body: body, headers: headers, encoding: encoding);
      }
    });
  }
}
