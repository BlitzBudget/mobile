class Recurrence<String> {
  const Recurrence(String val);

  static const Recurrence WEEKLY = const Recurrence('WEEKLY');
  static const Recurrence BIMONTHLY = const Recurrence('BI-MONTHLY');
  static const Recurrence MONTHLY = const Recurrence('MONTHLY');
  static const Recurrence NEVER = const Recurrence('NEVER');
}
