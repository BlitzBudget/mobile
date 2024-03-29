import 'package:internet_connection_checker/internet_connection_checker.dart';

abstract class NetworkInfo {
  Future<bool> get isConnected;
}

/// Data Connection Checker
///
/// Pings Cloudflare / OpenDNS / Google
/// To ensure 100% connectivity check
class NetworkInfoImpl implements NetworkInfo {
  NetworkInfoImpl({required this.connectionChecker});

  final InternetConnectionChecker? connectionChecker;

  @override
  Future<bool> get isConnected => connectionChecker!.hasConnection;
}
