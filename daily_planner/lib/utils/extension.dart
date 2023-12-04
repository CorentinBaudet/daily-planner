import 'dart:core';

import 'package:daily_planner/constants/intl.dart';

extension ExtDateTime on DateTime {
  DateTime troncateDateTime() {
    return ConstantsIntl.dateTimeFormat
        .parse(ConstantsIntl.dateTimeFormat.format(this));
  }

  String formatDate() {
    return ConstantsIntl.dateFormat.format(this);
  }

  String formatTime() {
    return ConstantsIntl.timeFormat.format(this);
  }

  bool isSameDay(DateTime other) {
    return year == other.year && month == other.month && day == other.day;
  }
}
