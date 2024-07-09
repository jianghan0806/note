class TimeUtils {
  static String getWeekday(int day) {
    switch (day) {
      case 1:
        return "一";
      case 2:
        return "二";
      case 3:
        return "三";
      case 4:
        return "四";
      case 5:
        return "五";
      case 6:
        return "六";
      case 7:
        return "日";
      default:
      // 可以返回一个默认的字符串，或者抛出异常
        throw ArgumentError("Invalid day: $day");
    // 或者
    // return "未知";
    }

  }

  static String getDateTime(DateTime dateTime) {
    return '${dateTime.year}年${dateTime.month}月${dateTime.day}日 ${dateTime.hour}:${dateTime.minute}:${dateTime.second}';
  }

  static String getDate(DateTime dateTime) {
    return '${dateTime.year}年${dateTime.month}月';
  }
  static String getFormatTime(DateTime dateTime) {
    // Format the DateTime object to a string (e.g., "2023-06-24 14:32")
    return "${dateTime.year}-${dateTime.month.toString().padLeft(2, '0')}-${dateTime.day.toString().padLeft(2, '0')} "
        "${dateTime.hour.toString().padLeft(2, '0')}:${dateTime.minute.toString().padLeft(2, '0')}";
  }
}