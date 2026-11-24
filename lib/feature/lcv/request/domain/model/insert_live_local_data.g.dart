// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'insert_live_local_data.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class InsertLiveLocalDataAdapter extends TypeAdapter<InsertLiveLocalData> {
  @override
  final int typeId = 1;

  @override
  InsertLiveLocalData read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return InsertLiveLocalData(
      loginId: fields[0] as String?,
      address: fields[3] as String?,
      lat: fields[1] as String?,
      log: fields[2] as String?,
      markerCondition: fields[4] as dynamic,
      date: fields[5] as dynamic,
      isGps: fields[6] as dynamic,
      isNetwork: fields[7] as dynamic,
      batteryStatus: fields[8] as dynamic,
      dateTime: fields[9] as dynamic,
      status: fields[10] as dynamic,
      flightMode: fields[11] as dynamic,
      driverName: fields[12] as dynamic,
      cngStationId: fields[13] as dynamic,
      inOut: fields[14] as dynamic,
      routeId: fields[15] as dynamic,
    );
  }

  @override
  void write(BinaryWriter writer, InsertLiveLocalData obj) {
    writer
      ..writeByte(16)
      ..writeByte(0)
      ..write(obj.loginId)
      ..writeByte(1)
      ..write(obj.lat)
      ..writeByte(2)
      ..write(obj.log)
      ..writeByte(3)
      ..write(obj.address)
      ..writeByte(4)
      ..write(obj.markerCondition)
      ..writeByte(5)
      ..write(obj.date)
      ..writeByte(6)
      ..write(obj.isGps)
      ..writeByte(7)
      ..write(obj.isNetwork)
      ..writeByte(8)
      ..write(obj.batteryStatus)
      ..writeByte(9)
      ..write(obj.dateTime)
      ..writeByte(10)
      ..write(obj.status)
      ..writeByte(11)
      ..write(obj.flightMode)
      ..writeByte(12)
      ..write(obj.driverName)
      ..writeByte(13)
      ..write(obj.cngStationId)
      ..writeByte(14)
      ..write(obj.inOut)
      ..writeByte(15)
      ..write(obj.routeId);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is InsertLiveLocalDataAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
