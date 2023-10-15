import 'package:daily_planner/constants/intl.dart';

class Utils {
  DateTime troncateCreationTime(DateTime createdAt) {
    return ConstantsIntl.dateTimeFormat
        .parse(ConstantsIntl.dateTimeFormat.format(createdAt));
  }
}
