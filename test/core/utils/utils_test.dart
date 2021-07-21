import 'package:english_words/english_words.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mobile_blitzbudget/core/utils/utils.dart' as utils;
import 'package:mobile_blitzbudget/domain/entities/transaction/recurrence.dart';

void main() {
  group('Capitalize', () {
    test('Should return first letter capitalized', () async {
      final capitalizedWord = utils.capitalize('return');
      expect(capitalizedWord.isSome(), equals(true));
      expect(capitalizedWord.getOrElse(() => ''), equals('Return'));
    });

    test('Should return None()', () async {
      final capitalizedWord = utils.capitalize('');
      expect(capitalizedWord.isNone(), equals(true));
    });
  });

  group('CapitalizePair', () {
    test('Should return first letter capitalized', () async {
      final wordPair = WordPair('first', 'second');
      final capitalizedWord = utils.capitalizePair(wordPair);
      expect(capitalizedWord.isSome(), equals(true));
      expect(capitalizedWord.getOrElse(() => ''), equals('FirstSecond'));
    });

    test('Should return None()', () async {
      final capitalizedWord = utils.capitalizePair(null);
      expect(capitalizedWord.isNone(), equals(true));
    });
  });

  group('LastElement', () {
    test('Success: Last Element in an array', () async {
      final arr = <dynamic>['first', 'second', 'last'];
      final lastEl = utils.lastElement(arr);
      expect(lastEl.isSome(), equals(true));
      expect(lastEl.getOrElse(() => ''), equals(arr.last));
    });

    test('Empty Array: Should return None()', () async {
      final arr = <dynamic>[];
      final lastEl = utils.lastElement(arr);
      expect(lastEl.isNone(), equals(true));
    });

    test('Null Array: Should return None()', () async {
      final lastEl = utils.lastElement(null);
      expect(lastEl.isNone(), equals(true));
    });
  });

  group('SplitElement', () {
    test('Should return splitted array', () async {
      final splittedArray = utils.splitElement(
          stringToSplit: 'Thisis,thestringto,split', character: ',');
      expect(splittedArray.isSome(), equals(true));
      expect(splittedArray.getOrElse(() => <String>[]).first, equals('Thisis'));
      expect(splittedArray.getOrElse(() => <String>[]).last, equals('split'));
      expect(splittedArray.getOrElse(() => <String>[]).length, equals(3));
    });

    test('String Empty: Should return None()', () async {
      final capitalizedWord =
          utils.splitElement(stringToSplit: '', character: ',');
      expect(capitalizedWord.isNone(), equals(true));
    });

    test('Character Empty: Should return None()', () async {
      final capitalizedWord =
          utils.splitElement(stringToSplit: 'TheStringToSplit', character: '');
      expect(capitalizedWord.isNone(), equals(true));
    });
  });

  group('IncludesStr', () {
    test('Should check included string', () async {
      final isIncluded =
          utils.includesStr(array: 'CheckIfStringContains', value: 'i');
      expect(isIncluded.isSome(), equals(true));
      expect(isIncluded.getOrElse(() => false), equals(true));
    });

    test('Empty Array: Should return None()', () async {
      final isIncluded = utils.includesStr(array: '', value: 'i');
      expect(isIncluded.isNone(), equals(true));
    });

    test('Character Empty: Should return None()', () async {
      final isIncluded = utils.includesStr(array: 'i', value: '');
      expect(isIncluded.isNone(), equals(true));
    });
  });

  group('IsEmpty', () {
    test('Check if empty', () async {
      final emptyString = utils.isEmpty('asad');
      expect(emptyString, equals(false));
    });

    test('Empty String: Should return false', () async {
      final emptyString = utils.isEmpty('');
      expect(emptyString, equals(true));
    });

    test('Character Empty: Should return None()', () async {
      final emptyString = utils.isEmpty(null);
      expect(emptyString, equals(true));
    });
  });

  group('IsNotEmpty', () {
    test('Check if not empty', () async {
      final emptyString = utils.isNotEmpty('asad');
      expect(emptyString, equals(true));
    });

    test('Empty String: Should return false', () async {
      final emptyString = utils.isNotEmpty('');
      expect(emptyString, equals(false));
    });

    test('Character Empty: Should return None()', () async {
      final emptyString = utils.isNotEmpty(null);
      expect(emptyString, equals(false));
    });
  });

  group('StringToEnum', () {
    test('Check if string to enum is successful', () async {
      final recurrence = utils.stringToEnum('weekly', Recurrence.values);
      expect(recurrence, equals(Recurrence.weekly));
    });

    test('Empty Recurrence: Should return false', () async {
      final recurrence = utils.stringToEnum('', Recurrence.values);
      expect(recurrence, equals(null));
    });
  });
}
