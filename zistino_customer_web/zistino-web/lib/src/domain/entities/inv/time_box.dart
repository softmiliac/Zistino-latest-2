class DayBox {
  DateTime date;
  String text;

  DayBox({required this.date, required this.text});
}

class HourBox {
  int start;
  int end;
  bool active;
  String text;

  HourBox(
      {required this.start,
      required this.end,
      required this.active,
      required this.text});
}
