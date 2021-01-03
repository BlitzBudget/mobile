import 'package:mobile_blitzbudget/data/utils/data_utils.dart';
import 'package:mobile_blitzbudget/domain/entities/category/category.dart';
import 'package:mobile_blitzbudget/domain/entities/category/category_type.dart';

class CategoryModel extends Category {
  CategoryModel(
      {final String categoryId,
      final String walletId,
      final String categoryName,
      final double categoryTotal,
      final CategoryType categoryType})
      : super(
            categoryId: categoryId,
            walletId: walletId,
            categoryName: categoryName,
            categoryTotal: categoryTotal,
            categoryType: categoryType);

  /// Map JSON transactions to List of object
  factory CategoryModel.fromJSON(Map<String, dynamic> category) {
    return CategoryModel(
        categoryId: parseDynamicToString(category['categoryId']),
        walletId: parseDynamicToString(category['walletId']),
        categoryName: parseDynamicToString(category['category_name']),
        categoryTotal: parseDynamicToDouble(category['category_total']),
        categoryType: parseDynamicToCategoryType(category['category_type']));
  }
}
