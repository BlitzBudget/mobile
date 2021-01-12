import 'package:flutter_test/flutter_test.dart';
import 'package:mobile_blitzbudget/core/failure/generic_failure.dart';

void main() {
  group('Is an APIFailure', () {
    test(
      'EmptyResponseFailure',
      () async {
        final genericFailure = EmptyResponseFailure();
        // assert
        expect(genericFailure, isA<GenericFailure>());
      },
    );
  });
}
