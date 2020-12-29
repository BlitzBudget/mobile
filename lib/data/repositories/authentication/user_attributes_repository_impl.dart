import '../../datasource/local/authentication/user_attributes_local_data_source.dart';

class UserAttributesRepositoryImpl implements UserAttributesRepository {
  final UserAttributesLocalDataSource userAttributesLocalDataSource;

  UserAttributesRepositoryImpl({@required this.userAttributesLocalDataSource});

  @override
  Future<String> readUserAttributes() async {
    return await userAttributesLocalDataSource.readUserAttributes();
  }

  Future<void> writeUserAttributes(String value) async {
    return await userAttributesLocalDataSource.writeUserAttributes(value);
  }
}
