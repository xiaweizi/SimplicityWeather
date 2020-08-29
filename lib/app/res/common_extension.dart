extension StringExtension on String {
  DateTime get dateTime => DateTime.parse(this.substring(0, this.length - 6)); // 对时间进行裁剪
}

extension NumExtension on int {
  String get gapTime => this < 10 ? "0$this" : "$this"; // 缺0 补0
}

