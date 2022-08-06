import 'package:equatable/equatable.dart';
import 'package:mobile_blitzbudget/domain/entities/category/category_type.dart';

class Category extends Equatable {
  const Category(
      {this.categoryId,
      this.userId,
      this.categoryName,
      this.categoryTotal,
      this.categoryType});

  final String? categoryId;
  final String? userId;
  final String? categoryName;
  final double? categoryTotal;
  final CategoryType? categoryType;

  @override
  List<Object?> get props =>
      [categoryId, userId, categoryName, categoryTotal, categoryType];
}
