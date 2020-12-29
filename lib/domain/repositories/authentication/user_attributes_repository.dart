

abstract class UserAttributesRepository {

  Future<String> readUserAttributes();

  Future<void> writeUserAttributes(String value);
}
