import 'package:flutter_test/flutter_test.dart';
import 'package:mobile_blitzbudget/core/error/api_exception.dart';
import 'package:mobile_blitzbudget/core/error/generic_exception.dart';
import 'package:mobile_blitzbudget/core/failure/generic_failure.dart';

void main() {
  group('Is an GenericException', () {
    test(
      'NoValueInCacheException',
      () async {
        final genericException = NoValueInCacheException();
        // assert
        expect(genericException, isA<GenericException>());
      },
    );
  });

  group('Convert Generic Exception to Failure', () {
    test(
      'NoValueInCacheException is a EmptyResponseFailure',
      () async {
        final failure = GenericException.convertExceptionToFailure(
            NoValueInCacheException());
        // assert
        expect(failure, equals(EmptyResponseFailure()));
      },
    );

    test(
      'TokenExpiredException is a GenericFailure',
      () async {
        final failure = GenericException.convertExceptionToFailure(
            TokenExpiredException(null));
        // assert
        expect(failure, equals(GenericFailure()));
      },
    );
  });
}
