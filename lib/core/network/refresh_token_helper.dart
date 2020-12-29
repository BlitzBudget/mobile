class RefreshTokenHelper {
// Refresh Token
  static final refreshTokenURI =
      authentication.baseURL + '/profile/refresh-token';

  /// Refresh authorization token
  ///
  /// If successful call the API again
  /// If unsuccessful then logout
  Future<dynamic> refreshAuthToken(String url, String apiCallToMake,
      {Map headers, body, encoding}) async {
    debugPrint(
        " The authorization token has expired, Trying to refresh the token.");

    /// Store Access token and Authentication Token
    final refreshToken = await _storage.read(key: constants.refreshToken);

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
        profile.logoutAndRedirect();
        return;
      }

      debugPrint(" The authorization token has been refreshed successfully.");

      /// Store Access Token
      authentication.storeAccessToken(res, _storage);

      /// Store Auth Token
      authentication.storeAuthToken(res, _storage);

      // Set the new Authorization header
      headers['Authorization'] = res["AuthenticationResult"]["IdToken"];

      switch (apiCallToMake) {
        case "Patch":
          // Call the PATCH again
          return patch(url, body: body, headers: headers, encoding: encoding);
        case "Put":
          // Call the POST again
          return put(url, body: body, headers: headers, encoding: encoding);
        case "Post":
        default:
          // Call the POST again
          return post(url, body: body, headers: headers, encoding: encoding);
      }
    });
  }
}
