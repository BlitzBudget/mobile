import 'package:flutter/foundation.dart';

abstract class SecureKeyValueStore {
  Future<void> setString({@required String value, @required String key});
  Future<String> getString({@required String key});
}
