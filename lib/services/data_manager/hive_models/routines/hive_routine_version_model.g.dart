// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'hive_routine_version_model.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class HiveRoutineVersionAdapter extends TypeAdapter<HiveRoutineVersion> {
  @override
  final int typeId = 3;

  @override
  HiveRoutineVersion read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return HiveRoutineVersion(
      id: fields[0] as String,
      routineId: fields[1] as String,
      localUserId: fields[2] as String,
      firebaseUid: fields[3] as String?,
      name: fields[4] as String?,
      productsByCategory: (fields[5] as Map?)?.map((dynamic k, dynamic v) =>
          MapEntry(k as String, (v as List).cast<ProductModel>())),
      createdAt: fields[6] as DateTime,
    );
  }

  @override
  void write(BinaryWriter writer, HiveRoutineVersion obj) {
    writer
      ..writeByte(7)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.routineId)
      ..writeByte(2)
      ..write(obj.localUserId)
      ..writeByte(3)
      ..write(obj.firebaseUid)
      ..writeByte(4)
      ..write(obj.name)
      ..writeByte(5)
      ..write(obj.productsByCategory)
      ..writeByte(6)
      ..write(obj.createdAt);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is HiveRoutineVersionAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
