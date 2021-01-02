import 'package:flutter/foundation.dart';
import 'package:mobile_blitzbudget/data/datasource/remote/dashboard/common/delete_item_remote_data_source.dart';
import 'package:mobile_blitzbudget/domain/repositories/dashboard/common/delete_item_repository.dart';

class DeleteItemRepositoryImpl implements DeleteItemRepository {
  final DeleteItemRemoteDataSource deleteItemRemoteDataSource;

  DeleteItemRepositoryImpl({@required this.deleteItemRemoteDataSource});

  @override
  Future<void> delete(String walletId, String itemId) async {
    return await deleteItemRemoteDataSource.delete(walletId, itemId);
  }
}
