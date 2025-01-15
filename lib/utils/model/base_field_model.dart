class FieldModelInt extends BaseFieldModel<int> {
  FieldModelInt({
    required super.defaultValue,
    required super.items,
  });

  factory FieldModelInt.fromJson(Map<String, dynamic> json) => FieldModelInt(
        defaultValue: json["defaultValue"] ?? 0,
        items: (json["items"] as List<dynamic>?)
                ?.map((x) => ItemField<int>.fromJson(x))
                .toList() ??
            [],
      );
}

class FieldModelString extends BaseFieldModel<String> {
  FieldModelString({
    required super.defaultValue,
    required super.items,
  });

  factory FieldModelString.fromJson(Map<String, dynamic> json) =>
      FieldModelString(
        defaultValue: json["defaultValue"] ?? "",
        items: (json["items"] as List<dynamic>?)
                ?.map((x) => ItemField<String>.fromJson(x))
                .toList() ??
            [],
      );
}

class BaseFieldModel<T> {
  BaseFieldModel({
    required this.defaultValue,
    required this.items,
  });

  final T defaultValue;
  final List<ItemField<T>> items;

  factory BaseFieldModel.fromJson(Map<String, dynamic> json) {
    return BaseFieldModel<T>(
      defaultValue: json["defaultValue"] ?? "",
      items: json["items"] == null
          ? []
          : List<ItemField<T>>.from(
              json["items"]!.map((x) => ItemField<T>.fromJson(x))),
    );
  }

  Map<String, dynamic> toJson() => {
        "defaultValue": defaultValue,
        "items": items.map((x) => x.toJson()).toList(),
      };
}

class ItemField<T> {
  ItemField({
    required this.itemValue,
    this.itemText = "",
  });

  final T itemValue;
  final String itemText;

  factory ItemField.fromJson(Map<String, dynamic> json) {
    return ItemField<T>(
      itemValue: json["itemValue"] ?? "",
      itemText: json["itemText"] ?? "",
    );
  }

  Map<String, dynamic> toJson() => {
        "itemValue": itemValue,
        "itemText": itemText,
      };
}

class ConvertToMap {
  static Map<T, String> createMapFromItems<T>(List<ItemField<T>> items) {
    return {
      for (var item in items) item.itemValue: item.itemText,
    };
  }
}
