// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'location_item.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************



class LocationItemAdapter extends TypeAdapter<LocationItem> {
  @override
  final int typeId = 1;

  @override
  LocationItem read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return LocationItem(
      startLocation:  fields[0] as int,
    );
  }

  @override
  void write(BinaryWriter writer, LocationItem obj) {
    writer
      ..writeByte(1)
      ..writeByte(0)
      ..write(obj.startLocation);


  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is LocationItemAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
