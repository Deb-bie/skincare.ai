// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'hive_reminder_model.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class HiveReminderModelAdapter extends TypeAdapter<HiveReminderModel> {
  @override
  final int typeId = 5;

  @override
  HiveReminderModel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return HiveReminderModel(
      id: fields[0] as String,
      localUserId: fields[1] as String,
      firebaseUid: fields[2] as String?,
      title: fields[3] as String?,
      notes: fields[4] as String?,
      icon: fields[6] as String?,
      isEnabled: fields[7] as bool?,
      time: fields[5] as String?,
      isSynced: fields[8] as bool,
      isDeleted: fields[9] as bool,
      updatedAt: fields[10] as DateTime,
      createdAt: fields[11] as DateTime,
    );
  }

  @override
  void write(BinaryWriter writer, HiveReminderModel obj) {
    writer
      ..writeByte(12)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.localUserId)
      ..writeByte(2)
      ..write(obj.firebaseUid)
      ..writeByte(3)
      ..write(obj.title)
      ..writeByte(4)
      ..write(obj.notes)
      ..writeByte(5)
      ..write(obj.time)
      ..writeByte(6)
      ..write(obj.icon)
      ..writeByte(7)
      ..write(obj.isEnabled)
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
      other is HiveReminderModelAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
