import 'package:mobile_blitzbudget/data/utils/data_utils.dart';
import 'package:mobile_blitzbudget/domain/entities/category/category.dart';
import 'package:mobile_blitzbudget/domain/entities/category/category_type.dart';

class CategoryModel extends Category {
  const CategoryModel(
      {final String? categoryId,
      final String? userId,
      final String? categoryName,
      final CategoryType? categoryType})
      : super(
            categoryId: categoryId,
            userId: userId,
            categoryName: categoryName,
            categoryType: categoryType);

  /// Map JSON transactions to List of object
  factory CategoryModel.fromJSON(Map<String, dynamic> category) {
    return CategoryModel(
        categoryId: parseDynamicAsString(category['sk']),
        userId: parseDynamicAsString(category['pk']),
        categoryName: parseDynamicAsString(category['category_name']),
        categoryType: parseDynamicAsCategoryType(category['category_type']));
  }

  /// Budget to JSON
  Map<String, dynamic> toJSON() => <String, dynamic>{
        'pk': userId,
        'sk': categoryId,
        'category_name': categoryName,
        'category_type': categoryType.name
      };
}
