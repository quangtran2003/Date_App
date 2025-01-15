// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'language_enum.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class LanguageEnumAdapter extends TypeAdapter<LanguageEnum> {
  @override
  final int typeId = 0;

  @override
  LanguageEnum read(BinaryReader reader) {
    switch (reader.readByte()) {
      case 0:
        return LanguageEnum.vietnamese;
      case 1:
        return LanguageEnum.english;
      default:
        return LanguageEnum.vietnamese;
    }
  }

  @override
  void write(BinaryWriter writer, LanguageEnum obj) {
    switch (obj) {
      case LanguageEnum.vietnamese:
        writer.writeByte(0);
        break;
      case LanguageEnum.english:
        writer.writeByte(1);
        break;
    }
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is LanguageEnumAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
