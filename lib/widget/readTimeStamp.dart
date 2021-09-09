import 'package:intl/date_symbol_data_local.dart';
import 'package:intl/intl.dart';

String readTimestamptoDate(int timestamp) {
  initializeDateFormatting('fr_CH', null);
  var format = new DateFormat('dd/MM/yyy');
  var date = new DateTime.fromMicrosecondsSinceEpoch(timestamp * 1000);
  var timer = format.format(date);

  return timer;
}

String readTimestamptoDateWithHour(int timestamp) {
  initializeDateFormatting('fr_CH', null);
  var format = new DateFormat('dd/MM/yyy kk:mm');
  var date = new DateTime.fromMicrosecondsSinceEpoch(timestamp * 1000);
  var timer = format.format(date);

  return timer;
}

String readTimestampYear(int timestamp) {
  initializeDateFormatting('fr_CH', null);
  var now = new DateTime.now();
  var format = new DateFormat('yyy');
  var date = new DateTime.fromMicrosecondsSinceEpoch(timestamp * 1000);
  var diff = date.difference(now);
  var time = '';
  var timer = format.format(date);

  return timer;
}
