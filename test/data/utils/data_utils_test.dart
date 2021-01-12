import 'package:flutter_test/flutter_test.dart';
import 'package:mobile_blitzbudget/data/utils/data_utils.dart';
import 'package:mobile_blitzbudget/domain/entities/bank-account/account_sub_type.dart';
import 'package:mobile_blitzbudget/domain/entities/bank-account/account_type.dart';
import 'package:mobile_blitzbudget/domain/entities/category/category_type.dart';
import 'package:mobile_blitzbudget/domain/entities/goal/goal_type.dart';
import 'package:mobile_blitzbudget/domain/entities/goal/target_type.dart';
import 'package:mobile_blitzbudget/domain/entities/transaction/recurrence.dart';

void main() {
  group('parseDynamicAsRecurrence', () {
    test(
      'parseDynamicAsRecurrence with valid data',
      () async {
        final recurrence = parseDynamicAsRecurrence(Recurrence.weekly.name);
        // assert
        expect(recurrence, isA<Recurrence>());
        expect(recurrence, equals(Recurrence.weekly));
      },
    );

    test(
      'parseDynamicAsRecurrence with invalid data',
      () async {
        final recurrence = parseDynamicAsRecurrence('');
        // assert
        expect(recurrence, equals(null));
      },
    );
  });

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
        dynamic dynString = 'week';
        final recurrence = parseDynamicAsString(dynString);
        // assert
        expect(recurrence, isA<String>());
        expect(recurrence, equals(dynString));
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
        expect(recurrence, equals(null));
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

  group('parseDynamicAsAccountType', () {
    test(
      'parseDynamicAsAccountType with int data',
      () async {
        final obj = parseDynamicAsAccountType(AccountType.asset.name);
        // assert
        expect(obj, isA<AccountType>());
        expect(obj, equals(AccountType.asset));
      },
    );

    test(
      'parseDynamicAsAccountType with double data',
      () async {
        final obj = parseDynamicAsAccountType('');
        // assert
        expect(obj, isA<Null>());
        expect(obj, equals(null));
      },
    );

    test(
      'parseDynamicAsAccountType with empty data',
      () async {
        dynamic emptyData;
        final obj = parseDynamicAsDouble(emptyData);
        // assert
        expect(obj, equals(null));
      },
    );
  });

  group('parseDynamicAsAccountSubType', () {
    test(
      'parseDynamicAsAccountSubType with AccountSubType data',
      () async {
        final obj = parseDynamicAsAccountSubType(AccountSubType.assets.name);
        // assert
        expect(obj, isA<AccountSubType>());
        expect(obj, equals(AccountSubType.assets));
      },
    );

    test(
      'parseDynamicAsAccountSubType with blank string',
      () async {
        final obj = parseDynamicAsAccountSubType('');
        // assert
        expect(obj, isA<Null>());
        expect(obj, equals(null));
      },
    );

    test(
      'parseDynamicAsAccountSubType with empty data',
      () async {
        dynamic emptyData;
        final obj = parseDynamicAsAccountSubType(emptyData);
        // assert
        expect(obj, equals(null));
      },
    );
  });

  group('parseDynamicAsGoalType', () {
    test(
      'parseDynamicAsGoalType with GoalType data',
      () async {
        final obj = parseDynamicAsGoalType(GoalType.buyACar.name);
        // assert
        expect(obj, isA<GoalType>());
        expect(obj, equals(GoalType.buyACar));
      },
    );

    test(
      'parseDynamicAsGoalType with blank string',
      () async {
        final obj = parseDynamicAsGoalType('');
        // assert
        expect(obj, isA<Null>());
        expect(obj, equals(null));
      },
    );

    test(
      'parseDynamicAsGoalType with empty data',
      () async {
        dynamic emptyData;
        final obj = parseDynamicAsGoalType(emptyData);
        // assert
        expect(obj, equals(null));
      },
    );
  });

  group('parseDynamicAsTargetType', () {
    test(
      'parseDynamicAsTargetType with targettype data',
      () async {
        final obj = parseDynamicAsTargetType(TargetType.account.name);
        // assert
        expect(obj, isA<TargetType>());
        expect(obj, equals(TargetType.account));
      },
    );

    test(
      'parseDynamicAsTargetType with blank string',
      () async {
        final obj = parseDynamicAsTargetType('');
        // assert
        expect(obj, isA<Null>());
        expect(obj, equals(null));
      },
    );

    test(
      'parseDynamicAsTargetType with empty data',
      () async {
        dynamic emptyData;
        final obj = parseDynamicAsTargetType(emptyData);
        // assert
        expect(obj, equals(null));
      },
    );
  });
}
