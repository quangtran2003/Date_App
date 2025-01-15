import 'package:uuid/uuid.dart';

abstract final class IdGenerator {
  static const uuid = Uuid();

  static String generate() {
    return uuid.v4();
  }
}
