// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'sticker.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class StickerAdapter extends TypeAdapter<Sticker> {
  @override
  final int typeId = 1;

  @override
  Sticker read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return Sticker(
      id: fields[0] as String,
      type: fields[1] as String,
      animated: fields[2] as bool,
      width: fields[3] as int,
      height: fields[4] as int,
      link: fields[5] as String,
    );
  }

  @override
  void write(BinaryWriter writer, Sticker obj) {
    writer
      ..writeByte(6)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.type)
      ..writeByte(2)
      ..write(obj.animated)
      ..writeByte(3)
      ..write(obj.width)
      ..writeByte(4)
      ..write(obj.height)
      ..writeByte(5)
      ..write(obj.link);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is StickerAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
