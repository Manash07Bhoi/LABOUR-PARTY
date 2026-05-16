// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'labour_model.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class LabourModelAdapter extends TypeAdapter<LabourModel> {
  @override
  final int typeId = 1;

  @override
  LabourModel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return LabourModel(
      id: fields[0] as String,
      name: fields[1] as String,
      phone: fields[2] as String?,
      isActive: fields[3] as bool,
      createdAt: fields[4] as DateTime,
    );
  }

  @override
  void write(BinaryWriter writer, LabourModel obj) {
    writer
      ..writeByte(5)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.name)
      ..writeByte(2)
      ..write(obj.phone)
      ..writeByte(3)
      ..write(obj.isActive)
      ..writeByte(4)
      ..write(obj.createdAt);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is LabourModelAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
