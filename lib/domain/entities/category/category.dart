import 'package:equatable/equatable.dart';
import 'package:mobile_blitzbudget/domain/entities/category/category_type.dart';

class Category extends Equatable {
  final String categoryId;
  final String walletId;
  final String categoryName;
  final double categoryTotal;
  final CategoryType categoryType;

  Category(
      {this.categoryId,
      this.walletId,
      this.categoryName,
      this.categoryTotal,
      this.categoryType});

  @override
  List<Object> get props =>
      [categoryId, walletId, categoryName, categoryTotal, categoryType];
}
