// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'hive_routine_completion.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class HiveRoutineCompletionAdapter extends TypeAdapter<HiveRoutineCompletion> {
  @override
  final int typeId = 4;

  @override
  HiveRoutineCompletion read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return HiveRoutineCompletion(
      id: fields[0] as String,
      localUserId: fields[1] as String,
      firebaseUid: fields[2] as String?,
      date: fields[3] as DateTime,
      routineType: fields[4] as String,
      completedProductIds: (fields[5] as List).cast<String>(),
      skippedProductIds: (fields[6] as List).cast<String>(),
      totalProducts: fields[7] as int,
      completedAt: fields[8] as DateTime?,
      createdAt: fields[9] as DateTime,
      updatedAt: fields[10] as DateTime,
      isSynced: fields[11] as bool,
    );
  }

  @override
  void write(BinaryWriter writer, HiveRoutineCompletion obj) {
    writer
      ..writeByte(12)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.localUserId)
      ..writeByte(2)
      ..write(obj.firebaseUid)
      ..writeByte(3)
      ..write(obj.date)
      ..writeByte(4)
      ..write(obj.routineType)
      ..writeByte(5)
      ..write(obj.completedProductIds)
      ..writeByte(6)
      ..write(obj.skippedProductIds)
      ..writeByte(7)
      ..write(obj.totalProducts)
      ..writeByte(8)
      ..write(obj.completedAt)
      ..writeByte(9)
      ..write(obj.createdAt)
      ..writeByte(10)
      ..write(obj.updatedAt)
      ..writeByte(11)
      ..write(obj.isSynced);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is HiveRoutineCompletionAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
