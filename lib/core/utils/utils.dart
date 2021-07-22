import 'package:collection/collection.dart' show IterableExtension;
import 'package:dartz/dartz.dart';
import 'package:english_words/english_words.dart';

final findWhiteSpace = RegExp(r'\s+');

Option<String> capitalize(String word) {
  return isEmpty(word)
      ? const None()
      : Some('${word[0].toUpperCase()}${word.substring(1).toLowerCase()}');
}

Option<String> capitalizePair(WordPair? pair) {
  return (pair == null) ? const None() : Some(pair.asPascalCase);
}

Option<dynamic> lastElement(List<dynamic>? arr) {
  if (arr == null || arr.isEmpty) {
    return const None<dynamic>();
  } else if (arr.isNotEmpty) {
    return Some<dynamic>(arr[arr.length - 1]);
  }
  return const None<dynamic>();
}

Option<List<String>> splitElement({String? stringToSplit, String? character}) {
  if (includesStr(value: character, array: stringToSplit)
      .getOrElse(() => false)) {
    if (isEmpty(stringToSplit) || isEmpty(character)) {
      return const None();
    } else {
      return Some(stringToSplit!.split(character!));
    }
  }

  return const None();
}

Option<bool> includesStr({dynamic array, dynamic value}) {
  if (isEmpty(array) || isEmpty(value)) {
    return const None();
  }

  if (array is String && value is String) {
    return Some(array.contains(value));
  }

  return const None();
}

bool isEmpty(String? obj) {
  /// Check if objext is a number or a boolean
  if (['', null, false, 0].contains(obj)) {
    return true;
  }

  return false;
}

bool isNotEmpty(dynamic obj) {
  return !isEmpty(obj);
}

/// String to Enum Conversion
///
/// Convert all Enum to String
/// Convert both string and enum to lower case
/// Replace all white space with empty string for the String
T? stringToEnum<T>(String str, Iterable<T> values) {
  return values.firstWhereOrNull(
    (value) =>
        value.toString().split('.')[1].toLowerCase() ==
        str.replaceAll(findWhiteSpace, '').toLowerCase(),
  );
}
