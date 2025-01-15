// ignore_for_file: constant_identifier_names

import 'package:intl/intl.dart';

const String PATTERN_1 = "dd/MM/yyyy";
const String PATTERN_DD = "dd";
const String PATTERN_MM = "MM";

const String PATTERN_YY = "yyyy";
const String PATTERN_2 = "dd/MM";
const String PATTERN_3 = "yyyy-MM-dd'T'HHmmss";
const String PATTERN_4 = "h:mm a dd/MM";
const String PATTERN_5 = "yyyy-MM-dd HH:mm:ss";
const String PATTERN_6 = "dd/MM/yyyy HH:mm";
const String PATTERN_7 = "HH:mm dd/MM/yyyy";
const String PATTERN_8 = "yyyy-MM-ddTHH:mm:ss";
const String PATTERN_9 = "HH:mm - dd/MM/yyyy";
const String PATTERN_10 = "dd/MM/yyyy HH:mm:ss";
const String PATTERN_11 = "HH:mm";
const String PATTERN_12 = "MM/yyyy";
const String PATTERN_13 = "HH:mm";
const String PATTERN_14 = "yyyyMMddHHmmss";
const String PATTERN_15 = "HH:mm dd/MM/yyyy";
const String PATTERN_16 = "HH:mm:ss - dd/MM/yyyy";
const String PATTERN_17 = "HH:mm:ss";
const String PATTERN_18 = "hh:mm a";
const String PATTERN_DEFAULT = "yyyy-MM-dd";

String formatDateTimeToString(DateTime? dateTime) {
  dateTime ??= DateTime.now();
  return DateFormat(PATTERN_1).format(dateTime);
}

int convertDMYToTimeStamps(String dateTimeStr, {String pattern = PATTERN_1}) {
  if (dateTimeStr.isNotEmpty) {
    DateTime dateTime = convertStringToDate(dateTimeStr, pattern);
    return dateTime.millisecondsSinceEpoch;
  }
  return 0;
}

String convertDateToString(DateTime? dateTime, String pattern) {
  dateTime ??= DateTime.now();
  return DateFormat(pattern).format(dateTime);
}

DateTime convertStringToDate(String dateTime, String pattern) {
  return DateFormat(pattern).parse(dateTime);
}

String convertDateToStringDefault(DateTime dateTime) {
  return DateFormat(PATTERN_DEFAULT).format(dateTime);
}

String changeDateString(String date, {String pattern = PATTERN_1}) {
  date = date.replaceAll('/', '');
  date = DateFormat(pattern).format(DateTime.parse(date));
  return date;
}

String changeDateSort(dynamic dateTime, {String pattern = PATTERN_1}) {
  return dateTime is String
      ? changeDateString(
          dateTime,
          pattern: pattern,
        )
      : DateFormat(pattern).format(dateTime);
}

int getQuarter(DateTime date) {
  return (date.month + 2) ~/ 3;
}

int convertHourToInt(String dateTime) {
  return int.tryParse(dateTime.replaceAll(":", '').replaceAll(" ", "")) ?? 0;
}
