import 'date_utils.dart';

void sortDateList({
  required List<dynamic> list,
}) {
  list.sort(
    (a, b) => changeDateSort(
      b.createTime,
      pattern: PATTERN_5,
    ).compareTo(
      changeDateSort(
        a.createTime,
        pattern: PATTERN_5,
      ),
    ),
  );
}
