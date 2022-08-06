import 'package:mobile_blitzbudget/core/utils/utils.dart';
import 'package:mobile_blitzbudget/domain/entities/category/category_type.dart';

CategoryType? parseDynamicAsCategoryType(dynamic obj) {
  return (obj is String) ? stringToEnum(obj, CategoryType.values) : null;
}

String parseDynamicAsString(dynamic obj) {
  if (obj is String) {
    return obj;
  } else if (obj is int) {
    return obj.toString();
  }
  return '';
}

bool? parseDynamicAsBool(dynamic obj) {
  if (obj is bool) {
    return obj;
  }
  return null;
}

double? parseDynamicAsDouble(dynamic obj) {
  if (obj is num) {
    return obj.toDouble();
  }
  return null;
}
