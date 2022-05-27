part of 'overview_bloc.dart';

abstract class OverviewEvent extends Equatable {
  const OverviewEvent();

  @override
  List<Object> get props => [];
}

class Fetch extends OverviewEvent {
  const Fetch() : super();
}
