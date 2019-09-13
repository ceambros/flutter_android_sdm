import 'package:intl/intl.dart';
import 'package:queries/queries.dart';

DateTime convertToDate(String format, String date) {
  var x = DateFormat(format).parse(date);
  return x;
}

List<String> convertListToString(IOrderedEnumerable<DateTime> datas) {
  List<String> list = [];

  for (var data in datas.toList()) {
    var day = data.day.toString().padLeft(2, "0");
    var month = data.month.toString().padLeft(2, "0");
    var year = data.year.toString();
    list.add("$day/$month/$year");
  }

  return list;
}
