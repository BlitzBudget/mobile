import 'package:flutter_test/flutter_test.dart';
import 'package:mobile_blitzbudget/data/utils/data_utils.dart';
import 'package:mobile_blitzbudget/domain/entities/category/category_type.dart';

void main() {
  group('parseDynamicAsCategoryType', () {
    test(
      'parseDynamicAsCategoryType with valid data',
      () async {
        final recurrence = parseDynamicAsCategoryType(CategoryType.income.name);
        // assert
        expect(recurrence, isA<CategoryType>());
        expect(recurrence, equals(CategoryType.income));
      },
    );

    test(
      'parseDynamicAsCategoryType with invalid data',
      () async {
        final recurrence = parseDynamicAsCategoryType('');
        // assert
        expect(recurrence, equals(null));
      },
    );
  });

  group('parseDynamicAsString', () {
    test(
      'parseDynamicAsString with dynamic data',
      () async {
        const week = 'week';
        final recurrence = parseDynamicAsString(week);
        // assert
        expect(recurrence, isA<String>());
        expect(recurrence, equals(week));
      },
    );

    test(
      'parseDynamicAsString with integer data',
      () async {
        final recurrence = parseDynamicAsString(1);
        // assert
        expect(recurrence, isA<String>());
        expect(recurrence, equals('1'));
      },
    );

    test(
      'parseDynamicAsString with empty data',
      () async {
        dynamic emptyData;
        final recurrence = parseDynamicAsString(emptyData);
        // assert
        expect(recurrence, equals(''));
      },
    );
  });

  group('parseDynamicAsBool', () {
    test(
      'parseDynamicAsBool with boolean data',
      () async {
        final convertedBool = parseDynamicAsBool(true);
        // assert
        expect(convertedBool, isA<bool>());
        expect(convertedBool, equals(true));
      },
    );

    test(
      'parseDynamicAsBool with empty data',
      () async {
        dynamic emptyData;
        final convertedBool = parseDynamicAsBool(emptyData);
        // assert
        expect(convertedBool, equals(null));
      },
    );
  });

  group('parseDynamicAsDouble', () {
    test(
      'parseDynamicAsDouble with int data',
      () async {
        final convertedDouble = parseDynamicAsDouble(1);
        // assert
        expect(convertedDouble, isA<double>());
        expect(convertedDouble, equals(1));
      },
    );

    test(
      'parseDynamicAsDouble with double data',
      () async {
        final convertedDouble = parseDynamicAsDouble(1.5);
        // assert
        expect(convertedDouble, isA<double>());
        expect(convertedDouble, equals(1.5));
      },
    );

    test(
      'parseDynamicAsDouble with empty data',
      () async {
        dynamic emptyData;
        final convertedDouble = parseDynamicAsDouble(emptyData);
        // assert
        expect(convertedDouble, equals(null));
      },
    );
  });
}
