import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import 'package:mobile_blitzbudget/data/model/category/category_model.dart';
import 'package:mobile_blitzbudget/data/utils/data_utils.dart';
import 'package:mobile_blitzbudget/domain/entities/category/category.dart';

import '../../../fixtures/fixture_reader.dart';

void main() {
  final categoryModelAsString =
      fixture('models/get/category/category_model.json');
  final categoryModelAsJSON = jsonDecode(categoryModelAsString);
  final categoryModel = CategoryModel(
      userId: categoryModelAsJSON['pk'],
      categoryId: categoryModelAsJSON['sk'],
      categoryType:
          parseDynamicAsCategoryType(categoryModelAsJSON['category_type']),
      categoryName: categoryModelAsJSON['category_name']);
  test(
    'Should be a subclass of Category entity',
    () async {
      // assert
      expect(categoryModel, isA<Category>());
    },
  );

  group('fromJson', () {
    test('Should return a valid model when the JSON is parsed with all data',
        () async {
      final categoryModelConverted =
          CategoryModel.fromJSON(categoryModelAsJSON);
      expect(categoryModelConverted, equals(categoryModel));
    });
  });

  group('toJson', () {
    test('Should return a JSON map containing the proper data', () async {
      final addCategoryModelAsString =
          fixture('models/add/category/category_model.json');
      final addCategoryModelAsJSON = jsonDecode(addCategoryModelAsString);
      expect(categoryModel.toJSON(), equals(addCategoryModelAsJSON));
    });
  });
}
