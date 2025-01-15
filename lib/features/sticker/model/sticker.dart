import 'package:hive/hive.dart';

part 'sticker.g.dart';

@HiveType(typeId: 1)
class Sticker {
  @HiveField(0)
  final String id;
  @HiveField(1)
  final String type;
  @HiveField(2)
  final bool animated;
  @HiveField(3)
  final int width;
  @HiveField(4)
  final int height;
  @HiveField(5)
  final String link;

  const Sticker({
    required this.id,
    required this.type,
    required this.animated,
    required this.width,
    required this.height,
    required this.link,
  });

  factory Sticker.fromJson(Map<String, dynamic> json) {
    return Sticker(
      id: json['id'] ?? '',
      type: json['type'] ?? '',
      animated: json['animated'] ?? false,
      width: json['width'] ?? 0,
      height: json['height'] ?? 0,
      link: json['link'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'type': type,
      'animated': animated,
      'width': width,
      'height': height,
      'link': link,
    };
  }
}
