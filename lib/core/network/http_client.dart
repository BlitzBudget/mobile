import '../error/exceptions.dart';

class HttpClient {
  final AuthTokenRepository authTokenRepository;
  final NetworkHelper networkHelper = NetworkHelper();
  final RefreshTokenHelper refreshTokenHelper = RefreshTokenHelper();

  HttpClient(this.authTokenRepository);

  Future<dynamic> post(String url, {Map headers, body, encoding}) async {
    String authToken = authTokenRepository.readAuthToken();

    /// Check if authorization is empty
    if (isEmpty(authToken)) {
      throw EmptyAuthorizationTokenException();
    }
    // Set Authorization header
    headers['Authorization'] = authToken;
    try {
      dynamic response = networkHelper.post(url,
            body: body,
            headers: headers);
      return _response(response);
    } on SocketException {
      throw ConnectionException();
    } on TokenExpiredException {

    }
  }

  Future<dynamic> put(String url, {Map headers, body, encoding}) async {
    String authToken = authTokenRepository.readAuthToken();

    /// Check if authorization is empty
    if (isEmpty(authToken)) {
      throw EmptyAuthorizationTokenException();
    }
    // Set Authorization header
    headers['Authorization'] = authToken;
    try {
      dynamic response = networkHelper.put(url,
            body: body,
            headers: headers);
      return _response(response);
    } on SocketException {
      throw ConnectionException();
    } on TokenExpiredException {

    }
  }

  Future<dynamic> patch(String url, {Map headers, body, encoding}) async {
    String authToken = authTokenRepository.readAuthToken();

    /// Check if authorization is empty
    if (isEmpty(authToken)) {
      throw EmptyAuthorizationTokenException();
    }
    // Set Authorization header
    headers['Authorization'] = authToken;
    try {
      dynamic response = networkHelper.patch(url,
            body: body,
            headers: headers);
      return _response(response);
    } on SocketException {
      throw ConnectionException();
    } on TokenExpiredException {

    }
  }

  dynamic _response(http.Response response) {
    final statusCode = response.statusCode;
    if (statusCode >= 200 && statusCode < 299) {
      if (response.body.isEmpty) {
        return List<dynamic>();
      } else {
        return jsonDecode(response.body);
      }
    } else if(statusCode == 401) {
      throw TokenExpiredException();
    } else if (statusCode >= 400 && statusCode < 500) {
      throw ClientErrorException();
    } else if (statusCode >= 500 && statusCode < 600) {
      throw ServerErrorException();
    } else {
      throw UnknownException();
    }
  }
}
