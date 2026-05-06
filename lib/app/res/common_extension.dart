extension StringExtension on String {
  DateTime get dateTime {
    if (length <= 6) {
      return DateTime.tryParse(this) ?? DateTime.now();
    }
    return DateTime.parse(substring(0, length - 6));
  }
}

extension NumExtension on int {
  String get gapTime => this < 10 ? "0$this" : "$this";
}

