class TimerUtils {
//时间格式化，根据总秒数转换为对应的 hh:mm:ss 格式
  static String constructTime(int seconds) {
    int day = seconds ~/ 3600 ~/ 24;
    int hour = seconds ~/ 3600;
    int minute = seconds % 3600 ~/ 60;
    int second = seconds % 60;
    if (day != 0) {
      return '$day天$hour小时$minute分$second秒';
    } else if (hour != 0) {
      return '$hour小时$minute分$second秒';
    } else if (minute != 0) {
//      return '$minute分$second秒';
      return '$hour小时${minute>10?minute:'0${minute}'}分$second秒';
    } else if (second != 0) {
      return '$second秒';
    } else {
      return '';
    }
//    return formatTime(day)+'天'+formatTime(hour) + "小时" + formatTime(minute) + "分" + formatTime(second)+'秒后自动取消';
  }

  static String constructVipTime(int seconds) {
    int day = seconds ~/ 3600 ~/ 24;
    int hour = seconds ~/ 3600;
    int minute = seconds % 3600 ~/ 60;
    int second = seconds % 60;
    if (day != 0) {
      return '剩$day天$hour小时$minute分';
    } else if (hour != 0) {
      return '剩$hour小时$minute分';
    } else if (minute != 0) {
      return '剩$minute分';
    } else {
      return '';
    }
//    return formatTime(day)+'天'+formatTime(hour) + "小时" + formatTime(minute) + "分" + formatTime(second)+'秒后自动取消';
  }

//数字格式化，将 0~9 的时间转换为 00~09
  static String formatTime(int timeNum) {
    return timeNum < 10 ? "0" + timeNum.toString() : timeNum.toString();
  }
}
