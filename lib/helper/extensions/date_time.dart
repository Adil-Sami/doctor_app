
import 'package:intl/intl.dart';

extension toStandard on String {
  String toStandardDateTime() {
    DateTime now = DateTime.parse(this);
    String formattedDate = DateFormat('dd-MM-yyyy, hh:mm a').format(now);
    return formattedDate;
  }

  String toStandardDate() {
    DateTime now = DateTime.parse(this);
    String formattedDate = DateFormat('dd-MM-yyyy').format(now);
    return formattedDate;
  }
}