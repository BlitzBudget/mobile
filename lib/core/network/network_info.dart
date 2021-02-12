import 'package:data_connection_checker/data_connection_checker.dart';
import 'package:flutter/foundation.dart';

abstract class NetworkInfo {
  Future<bool> get isConnected;
}

/// Data Connection Checker
///
/// Pings Cloudflare / OpenDNS / Google
/// To ensure 100% connectivity check
class NetworkInfoImpl implements NetworkInfo {
  NetworkInfoImpl({@required this.connectionChecker});

  final DataConnectionChecker connectionChecker;

  @override
  Future<bool> get isConnected => connectionChecker.hasConnection;
}
