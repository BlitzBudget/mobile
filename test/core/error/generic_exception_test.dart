import 'package:flutter_test/flutter_test.dart';
import 'package:mobile_blitzbudget/core/error/generic_exception.dart';

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
}
