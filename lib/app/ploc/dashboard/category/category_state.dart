part of 'category_bloc.dart';

abstract class CategoryState extends Equatable {
  const CategoryState();

  @override
  List<Object> get props => [];
}

class Loading extends CategoryState {}

class Empty extends CategoryState {}

class Error extends CategoryState {
  const Error({required this.message});

  final String message;

  @override
  List<Object> get props => [message];
}
