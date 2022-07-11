import 'package:mobile_blitzbudget/core/failure/failure.dart';
import 'package:mobile_blitzbudget/core/failure/generic_failure.dart';

// ignore: avoid_classes_with_only_static_members
class GenericException implements Exception {
  /// Convert Exception to Failure
  static Failure convertExceptionToFailure(Exception authorizationException) {
    if (authorizationException is NoValueInCacheException) {
      return EmptyResponseFailure();
    }
    return GenericFailure();
  }
}

/// This exception is thrown by the key value store / Secure Key Value store
class NoValueInCacheException extends GenericException {}
