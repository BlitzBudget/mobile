abstract class StartsWithDateRepository {
  Future<String> readStartsWithDate();

  Future<void> writeStartsWithDate(String value);
}
