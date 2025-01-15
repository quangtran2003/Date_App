// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'album_sticker.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class AlbumStickerAdapter extends TypeAdapter<AlbumSticker> {
  @override
  final int typeId = 2;

  @override
  AlbumSticker read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return AlbumSticker(
      id: fields[0] as String,
      stickers: (fields[1] as List).cast<Sticker>(),
      isDefault: fields[2] as bool,
    );
  }

  @override
  void write(BinaryWriter writer, AlbumSticker obj) {
    writer
      ..writeByte(3)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.stickers)
      ..writeByte(2)
      ..write(obj.isDefault);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is AlbumStickerAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
