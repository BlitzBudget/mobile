enum Recurrence { weekly, biMonthly, monthly, never }

extension RecurrenceExtension on Recurrence {
  String get name {
    switch (this) {
      case Recurrence.weekly:
        return 'WEEKLY';
      case Recurrence.biMonthly:
        return 'BI-MONTHLY';
      case Recurrence.monthly:
        return 'MONTHLY';
      case Recurrence.never:
        return 'NEVER';
      default:
        return null;
    }
  }
}
