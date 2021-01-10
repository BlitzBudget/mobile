import 'dart:math';

import 'package:english_words/english_words.dart';
// ignore: implementation_imports
import 'package:flutter/material.dart';

final findWhiteSpace = RegExp(r'\s+');
// This file has a number of platform-agnostic non-Widget utility functions.

const _myListOfRandomColors = [
  Colors.red,
  Colors.blue,
  Colors.teal,
  Colors.yellow,
  Colors.amber,
  Colors.deepOrange,
  Colors.green,
  Colors.indigo,
  Colors.lime,
  Colors.pink,
  Colors.orange,
];

final _random = Random();

// Avoid customizing the word generator, which can be slow.
// https://github.com/filiph/english_words/issues/9
final wordPairIterator = generateWordPairs();

String generateRandomHeadline() {
  final artist = capitalizePair(wordPairIterator.first);

  switch (_random.nextInt(10)) {
    case 0:
      return '$artist says ${nouns[_random.nextInt(nouns.length)]}';
    case 1:
      return '$artist arrested due to ${wordPairIterator.first.join(' ')}';
    case 2:
      return '$artist releases ${capitalizePair(wordPairIterator.first)}';
    case 3:
      return '$artist talks about his ${nouns[_random.nextInt(nouns.length)]}';
    case 4:
      return '$artist talks about her ${nouns[_random.nextInt(nouns.length)]}';
    case 5:
      return '$artist talks about their ${nouns[_random.nextInt(nouns.length)]}';
    case 6:
      return '$artist says their music is inspired by ${wordPairIterator.first.join(' ')}';
    case 7:
      return '$artist says the world needs more ${nouns[_random.nextInt(nouns.length)]}';
    case 8:
      return '$artist calls their band ${adjectives[_random.nextInt(adjectives.length)]}';
    case 9:
      return '$artist finally ready to talk about ${nouns[_random.nextInt(nouns.length)]}';
  }

  assert(false, 'Failed to generate news headline');
  return '';
}

List<MaterialColor> getRandomColors(int amount) {
  return List<MaterialColor>.generate(amount, (index) {
    return _myListOfRandomColors[_random.nextInt(_myListOfRandomColors.length)];
  });
}

List<String> getRandomNames(int amount) {
  return wordPairIterator
      .take(amount)
      .map((pair) => capitalizePair(pair))
      .toList();
}

String capitalize(String word) {
  return '${word[0].toUpperCase()}${word.substring(1).toLowerCase()}';
}

String capitalizePair(WordPair pair) {
  return '${capitalize(pair.first)} ${capitalize(pair.second)}';
}

dynamic lastElement(List arr) {
  if (arr.isEmpty) {
    return arr;
  } else if (arr.isNotEmpty) {
    return arr[arr.length - 1];
  }
  return arr;
}

List<String> splitElement(String str, String splitString) {
  if (includesStr(str, splitString)) {
    if (isEmpty(str)) {
      return null;
    } else {
      return str.split(splitString);
    }
  }

  return null;
}

bool includesStr(String arr, String val) {
  if (arr.isEmpty) {
    return null;
  } else {
    return arr.contains(val);
  }
}

bool isEmpty(String obj) {
  /// Check if objext is a number or a boolean
  if (['', null, false, 0].contains(obj)) return true;

  return false;
}

bool isNotEmpty(String obj) {
  return !isEmpty(obj);
}

void displayDialog(BuildContext context, String title, String text) =>
    showDialog<String>(
      context: context,
      builder: (context) =>
          AlertDialog(title: Text(title), content: Text(text)),
    );

/// String to Enum Conversion
///
/// Convert all Enum to String
/// Convert both string and enum to lower case
/// Replace all white space with empty string for the String
T stringToEnum<T>(String str, Iterable<T> values) {
  return values.firstWhere(
    (value) =>
        value.toString().split('.')[1].toLowerCase() ==
        str?.replaceAll(findWhiteSpace, '')?.toLowerCase(),
    orElse: () => null,
  );
}
