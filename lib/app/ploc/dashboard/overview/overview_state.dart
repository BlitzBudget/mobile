part of 'overview_bloc.dart';

abstract class OverviewState extends Equatable {
  const OverviewState();

  @override
  List<Object> get props => [];
}

class Loading extends OverviewState {}

class Empty extends OverviewState {}

class Error extends OverviewState {
  const Error({required this.message});

  final String message;

  @override
  List<Object> get props => [message];
}
