import 'package:equatable/equatable.dart';

abstract class Failure extends Equatable {
  @override
  List<Object> get props => [];
}

// General failures
class NetworkConnectivityFailure extends Failure {}

class FetchDataFailure extends Failure {}
