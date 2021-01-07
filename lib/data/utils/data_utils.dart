import 'package:mobile_blitzbudget/core/utils/utils.dart';
import 'package:mobile_blitzbudget/domain/entities/bank-account/account_sub_type.dart';
import 'package:mobile_blitzbudget/domain/entities/bank-account/account_type.dart';
import 'package:mobile_blitzbudget/domain/entities/category/category_type.dart';
import 'package:mobile_blitzbudget/domain/entities/transaction/recurrence.dart';

Recurrence parseDynamicAsRecurrence(dynamic obj) {
  return (obj is String) ? stringToEnum(obj, Recurrence.values) : null;
}

CategoryType parseDynamicAsCategoryType(dynamic obj) {
  return (obj is String) ? stringToEnum(obj, CategoryType.values) : null;
}

String parseDynamicAsString(dynamic obj) {
  if (obj is String) {
    return obj;
  }
  return null;
}

bool parseDynamicAsBool(dynamic obj) {
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

/// Parse dynamic to Account Type
AccountType parseDynamicAsAccountType(dynamic obj) {
  return (obj is String) ? stringToEnum(obj, AccountType.values) : null;
}

/// Parse dynamic to Account Sub Type
AccountSubType parseDynamicAsAccountSubType(dynamic obj) {
  return (obj is String) ? stringToEnum(obj, AccountSubType.values) : null;
}
