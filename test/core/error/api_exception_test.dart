import 'package:flutter_test/flutter_test.dart';
import 'package:mobile_blitzbudget/core/error/api_exception.dart';
import 'package:mobile_blitzbudget/core/failure/api_failure.dart';

void main() {
  group('Is an API Exception', () {
    test(
      'TokenExpiredException',
      () async {
        final apiException = TokenExpiredException(null);
        // assert
        expect(apiException, isA<APIException>());
      },
    );

    test(
      'EmptyAuthorizationTokenException',
      () async {
        final apiException = EmptyAuthorizationTokenException();
        // assert
        expect(apiException, isA<APIException>());
      },
    );

    test(
      'UnableToRefreshTokenException',
      () async {
        final apiException = UnableToRefreshTokenException();
        // assert
        expect(apiException, isA<APIException>());
      },
    );

    test(
      'ConnectionException',
      () async {
        final apiException = ConnectionException(null);
        // assert
        expect(apiException, isA<APIException>());
      },
    );

    test(
      'ServerErrorException',
      () async {
        final apiException = ServerErrorException(null);
        // assert
        expect(apiException, isA<APIException>());
      },
    );

    test(
      'ClientErrorException',
      () async {
        final apiException = ClientErrorException(null);
        // assert
        expect(apiException, isA<APIException>());
      },
    );

    test(
      'UnknownException',
      () async {
        final apiException = UnknownException(null);
        // assert
        expect(apiException, isA<APIException>());
      },
    );

    test(
      'NoNetworkConnectionException',
      () async {
        final apiException = NoNetworkConnectionException();
        // assert
        expect(apiException, isA<APIException>());
      },
    );
  });

  group('Convert API Exception to Failure', () {
    test(
      'TokenExpiredException is a GenericAPIFailure',
      () async {
        final failure =
            APIException.convertExceptionToFailure(TokenExpiredException(null));
        // assert
        expect(failure, equals(GenericAPIFailure()));
      },
    );

    test(
      'EmptyAuthorizationTokenException is a FetchDataFailure',
      () async {
        final failure = APIException.convertExceptionToFailure(
            EmptyAuthorizationTokenException());
        // assert
        expect(failure, equals(FetchDataFailure()));
      },
    );

    test(
      'UnableToRefreshTokenException is a FetchDataFailure',
      () async {
        final failure = APIException.convertExceptionToFailure(
            UnableToRefreshTokenException());
        // assert
        expect(failure, equals(FetchDataFailure()));
      },
    );

    test(
      'ConnectionException is a ConnectionFailure',
      () async {
        final failure =
            APIException.convertExceptionToFailure(ConnectionException(null));
        // assert
        expect(failure, equals(ConnectionFailure()));
      },
    );

    test(
      'ServerErrorException is a ServerFailure',
      () async {
        final failure =
            APIException.convertExceptionToFailure(ServerErrorException(null));
        // assert
        expect(failure, equals(ServerFailure()));
      },
    );

    test(
      'ClientErrorException is a ClientFailure',
      () async {
        final failure =
            APIException.convertExceptionToFailure(ClientErrorException(null));
        // assert
        expect(failure, equals(ClientFailure()));
      },
    );

    test(
      'UnknownException is a GenericAPIFailure',
      () async {
        final failure =
            APIException.convertExceptionToFailure(UnknownException(null));
        // assert
        expect(failure, equals(GenericAPIFailure()));
      },
    );

    test(
      'NoNetworkConnectionException is a NoNetworkFailure',
      () async {
        final failure = APIException.convertExceptionToFailure(
            NoNetworkConnectionException());
        // assert
        expect(failure, equals(NoNetworkFailure()));
      },
    );
  });
}
