import 'package:daily_planner/constants/intl.dart';

class Utils {
  DateTime troncateDateTime(DateTime dateTime) {
    return ConstantsIntl.dateTimeFormat
        .parse(ConstantsIntl.dateTimeFormat.format(dateTime));
  }

  String formatTime(DateTime time) {
    return ConstantsIntl.timeFormat.format(time);
  }
}
