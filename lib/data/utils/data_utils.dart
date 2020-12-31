import 'package:mobile_blitzbudget/domain/entities/category/category_type.dart';
import 'package:mobile_blitzbudget/domain/entities/transaction/recurrence.dart';

Recurrence parseDynamicToRecurrence(dynamic obj) {
  if (obj is Recurrence) {
    return obj;
  }
  return null;
}

CategoryType parseDynamicToCategoryType(dynamic obj) {
  if (obj is CategoryType) {
    return obj;
  }
  return null;
}
