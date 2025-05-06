import 'package:hive/hive.dart';
part 'theme_enum.g.dart';

@HiveType(typeId: 3)
enum AppTheme {
  @HiveField(0)
  light,
  @HiveField(1)
  dark,
  @HiveField(2)
  system;
}
