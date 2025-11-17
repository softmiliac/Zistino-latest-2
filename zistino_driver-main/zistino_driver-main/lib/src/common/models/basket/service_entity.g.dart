// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'service_entity.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class ServiceBasketAdapter extends TypeAdapter<ServiceBasket> {
  @override
  final int typeId = 0;

  @override
  ServiceBasket read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return ServiceBasket(
      id: fields[0] as int,
      acceptorProfileId: fields[1] as String,
      serviceName: fields[2] as String,
      description: fields[3] as String,
      discount: fields[4] as String,
      companyShares: fields[5] as String,
      lawyerCenter: fields[6] as String,
      price: fields[7] as String,
      quantity: fields[8] as int,
      startDate: fields[9] as String,
      endDate: fields[10] as String,
      image: fields[11] as String,
      status: fields[12] as String,
      createdAt: fields[13] as String,
      updatedAt: fields[14] as String,
    );
  }

  @override
  void write(BinaryWriter writer, ServiceBasket obj) {
    writer
      ..writeByte(15)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.acceptorProfileId)
      ..writeByte(2)
      ..write(obj.serviceName)
      ..writeByte(3)
      ..write(obj.description)
      ..writeByte(4)
      ..write(obj.discount)
      ..writeByte(5)
      ..write(obj.companyShares)
      ..writeByte(6)
      ..write(obj.lawyerCenter)
      ..writeByte(7)
      ..write(obj.price)
      ..writeByte(8)
      ..write(obj.quantity)
      ..writeByte(9)
      ..write(obj.startDate)
      ..writeByte(10)
      ..write(obj.endDate)
      ..writeByte(11)
      ..write(obj.image)
      ..writeByte(12)
      ..write(obj.status)
      ..writeByte(13)
      ..write(obj.createdAt)
      ..writeByte(14)
      ..write(obj.updatedAt);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ServiceBasketAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
