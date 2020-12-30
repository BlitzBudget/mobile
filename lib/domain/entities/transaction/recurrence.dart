class Recurrence<String> {
  const Recurrence(String val);

  static const Recurrence weekly = Recurrence('WEEKLY');
  static const Recurrence biMonthly = Recurrence('BI-MONTHLY');
  static const Recurrence monthly = Recurrence('MONTHLY');
  static const Recurrence never = Recurrence('NEVER');
}
