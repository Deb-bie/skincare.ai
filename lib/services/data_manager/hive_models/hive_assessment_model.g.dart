// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'hive_assessment_model.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class HiveAssessmentModelAdapter extends TypeAdapter<HiveAssessmentModel> {
  @override
  final int typeId = 0;

  @override
  HiveAssessmentModel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return HiveAssessmentModel(
      id: fields[0] as String,
      localUserId: fields[1] as String,
      firebaseUid: fields[2] as String?,
      gender: fields[3] as String?,
      ageRange: fields[4] as String?,
      skinType: fields[5] as String?,
      skinConcerns: (fields[6] as List?)?.cast<String>(),
      currentRoutine: fields[7] as String?,
      isSynced: fields[8] as bool,
      isDeleted: fields[9] as bool,
      updatedAt: fields[10] as DateTime,
      createdAt: fields[11] as DateTime,
    );
  }

  @override
  void write(BinaryWriter writer, HiveAssessmentModel obj) {
    writer
      ..writeByte(12)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.localUserId)
      ..writeByte(2)
      ..write(obj.firebaseUid)
      ..writeByte(3)
      ..write(obj.gender)
      ..writeByte(4)
      ..write(obj.ageRange)
      ..writeByte(5)
      ..write(obj.skinType)
      ..writeByte(6)
      ..write(obj.skinConcerns)
      ..writeByte(7)
      ..write(obj.currentRoutine)
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
      other is HiveAssessmentModelAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
