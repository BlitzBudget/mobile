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

String parseDynamicAsString(dynamic obj) {
  if (obj is String) {
    return obj;
  }
  return null;
}

bool parseDynamicToBool(dynamic obj) {
  if (obj is bool) {
    return obj;
  }
  return null;
}

double parseDynamicAsDouble(dynamic obj) {
  if (obj is double) {
    return obj;
  } else if (obj is int) {
    return obj.toDouble();
  }
  return null;
}
