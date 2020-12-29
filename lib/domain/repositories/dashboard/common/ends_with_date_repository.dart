abstract class EndsWithDateRepository {
  Future<String> readEndsWithDate();

  Future<void> writeEndsWithDate(String value);
}
