import 'package:flutter_test/flutter_test.dart';
import 'package:mobile_blitzbudget/core/failure/api_failure.dart';

void main() {
  group('Is an APIFailure', () {
    test(
      'FetchDataFailure',
      () async {
        final apiFailure = FetchDataFailure();
        // assert
        expect(apiFailure, isA<APIFailure>());
      },
    );

    test(
      'ClientFailure',
      () async {
        final apiFailure = ClientFailure();
        // assert
        expect(apiFailure, isA<APIFailure>());
      },
    );

    test(
      'ServerFailure',
      () async {
        final apiFailure = ServerFailure();
        // assert
        expect(apiFailure, isA<APIFailure>());
      },
    );

    test(
      'ConnectionFailure',
      () async {
        final apiFailure = ConnectionFailure();
        // assert
        expect(apiFailure, isA<APIFailure>());
      },
    );

    test(
      'NoNetworkFailure',
      () async {
        final apiFailure = NoNetworkFailure();
        // assert
        expect(apiFailure, isA<APIFailure>());
      },
    );

    test(
      'GenericAPIFailure',
      () async {
        final apiFailure = GenericAPIFailure();
        // assert
        expect(apiFailure, isA<APIFailure>());
      },
    );
  });
}
