// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'hive_routine_model.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class HiveRoutineModelAdapter extends TypeAdapter<HiveRoutineModel> {
  @override
  final int typeId = 2;

  @override
  HiveRoutineModel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return HiveRoutineModel(
      id: fields[0] as String,
      localUserId: fields[1] as String,
      firebaseUid: fields[2] as String?,
      name: fields[3] as String?,
      productsByCategory: (fields[4] as Map?)?.map((dynamic k, dynamic v) =>
          MapEntry(k as String, (v as List).cast<ProductModel>())),
      morningRoutinesJson: (fields[5] as Map?)?.cast<String, dynamic>(),
      eveningRoutinesJson: (fields[6] as Map?)?.cast<String, dynamic>(),
      completionsJson: (fields[7] as Map?)?.cast<String, dynamic>(),
      isSynced: fields[8] as bool,
      isDeleted: fields[9] as bool,
      updatedAt: fields[10] as DateTime,
      createdAt: fields[11] as DateTime,
    );
  }

  @override
  void write(BinaryWriter writer, HiveRoutineModel obj) {
    writer
      ..writeByte(12)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.localUserId)
      ..writeByte(2)
      ..write(obj.firebaseUid)
      ..writeByte(3)
      ..write(obj.name)
      ..writeByte(4)
      ..write(obj.productsByCategory)
      ..writeByte(5)
      ..write(obj.morningRoutinesJson)
      ..writeByte(6)
      ..write(obj.eveningRoutinesJson)
      ..writeByte(7)
      ..write(obj.completionsJson)
      ..writeByte(8)
      ..write(obj.isSynced)
      ..writeByte(9)
      ..write(obj.isDeleted)
      ..writeByte(10)
      ..write(obj.updatedAt)
      ..writeByte(11)
      ..write(obj.createdAt);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is HiveRoutineModelAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
