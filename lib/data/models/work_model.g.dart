// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'work_model.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class WorkModelAdapter extends TypeAdapter<WorkModel> {
  @override
  final int typeId = 0;

  @override
  WorkModel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return WorkModel(
      id: fields[0] as String,
      workName: fields[1] as String,
      date: fields[2] as DateTime,
      placeId: fields[3] as String,
      placeName: fields[4] as String,
      labourIds: (fields[5] as List).cast<String>(),
      labourCount: fields[6] as int,
      totalAmount: fields[7] as double,
      driverId: fields[9] as String?,
      driverName: fields[10] as String?,
      tractorId: fields[11] as String?,
      tractorName: fields[12] as String?,
      sandTrips: fields[13] as int,
      createdAt: fields[14] as DateTime,
      updatedAt: fields[15] as DateTime,
    );
  }

  @override
  void write(BinaryWriter writer, WorkModel obj) {
    writer
      ..writeByte(15)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.workName)
      ..writeByte(2)
      ..write(obj.date)
      ..writeByte(3)
      ..write(obj.placeId)
      ..writeByte(4)
      ..write(obj.placeName)
      ..writeByte(5)
      ..write(obj.labourIds)
      ..writeByte(6)
      ..write(obj.labourCount)
      ..writeByte(7)
      ..write(obj.totalAmount)
      ..writeByte(9)
      ..write(obj.driverId)
      ..writeByte(10)
      ..write(obj.driverName)
      ..writeByte(11)
      ..write(obj.tractorId)
      ..writeByte(12)
      ..write(obj.tractorName)
      ..writeByte(13)
      ..write(obj.sandTrips)
      ..writeByte(14)
      ..write(obj.createdAt)
      ..writeByte(15)
      ..write(obj.updatedAt);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is WorkModelAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
