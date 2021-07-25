part of 'category_bloc.dart';

abstract class CategoryEvent extends Equatable {
  const CategoryEvent({this.deleteItemId});

  final String? deleteItemId;

  @override
  List<Object> get props => [];
}
