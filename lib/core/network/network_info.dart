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
  final DataConnectionChecker connectionChecker;

  NetworkInfoImpl({@required this.connectionChecker});

  @override
  Future<bool> get isConnected => connectionChecker.hasConnection;
}
