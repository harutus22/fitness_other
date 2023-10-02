const calendarChecked = "calendar_checked";
const calendarDay = "calendar_day";
const calendarMonth = "calendar_month";

class CalendarItem{
  int isChecked = 0;
  int day = 0;
  int month = 0;

  CalendarItem({required this.isChecked, required this.day, required this.month});

  Map<String, Object?> toMap() {
    var map = <String, Object?>{
      calendarChecked: isChecked,
      calendarDay: day,
      calendarMonth: month,
    };
    return map;
  }
  CalendarItem.empty();

  CalendarItem.fromMap(Map<dynamic, dynamic> map) {
    isChecked = map[calendarChecked];
    day = map[calendarDay];
    month = map[calendarMonth];
  }
}