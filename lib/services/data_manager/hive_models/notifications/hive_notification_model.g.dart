// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'hive_notification_model.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class HiveNotificationModelAdapter extends TypeAdapter<HiveNotificationModel> {
  @override
  final int typeId = 6;

  @override
  HiveNotificationModel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return HiveNotificationModel(
      id: fields[0] as String,
      localUserId: fields[1] as String,
      firebaseUid: fields[2] as String?,
      title: fields[3] as String,
      body: fields[4] as String,
      type: fields[5] as NotificationType,
      isRead: fields[6] as bool,
      createdAt: fields[7] as DateTime,
      actionData: fields[8] as String?,
      imageUrl: fields[9] as String?,
    );
  }

  @override
  void write(BinaryWriter writer, HiveNotificationModel obj) {
    writer
      ..writeByte(10)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.localUserId)
      ..writeByte(2)
      ..write(obj.firebaseUid)
      ..writeByte(3)
      ..write(obj.title)
      ..writeByte(4)
      ..write(obj.body)
      ..writeByte(5)
      ..write(obj.type)
      ..writeByte(6)
      ..write(obj.isRead)
      ..writeByte(7)
      ..write(obj.createdAt)
      ..writeByte(8)
      ..write(obj.actionData)
      ..writeByte(9)
      ..write(obj.imageUrl);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is HiveNotificationModelAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
