// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'assginment_model.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class AssignmentModelAdapter extends TypeAdapter<AssignmentModel> {
  @override
  final int typeId = 2;

  @override
  AssignmentModel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return AssignmentModel(
      id: fields[0] as dynamic,
      motherStation: fields[1] as String?,
      motherStationId: fields[2] as dynamic,
      cngStation: fields[3] as String?,
      orderId: fields[4] as String?,
      driverName: fields[5] as String?,
      vehicleNo: fields[6] as String?,
      scm: fields[7] as String?,
      quantity: fields[8] as String?,
      status: fields[9] as String?,
      createdAt: fields[10] as String?,
      createdFor: fields[12] as String?,
      motherStationAddress: fields[13] as String?,
      motherStationLat: fields[14] as dynamic,
      motherStationLong: fields[15] as dynamic,
      motherStationCity: fields[16] as String?,
      motherStationDistrict: fields[17] as String?,
      motherStationState: fields[18] as String?,
      cngStationAddress: fields[19] as String?,
      cngStationLat: fields[20] as dynamic,
      cngStationLong: fields[21] as dynamic,
      cngStationCity: fields[22] as String?,
      cngStationDistrict: fields[23] as String?,
      cngStationState: fields[24] as String?,
      assignmentStatus: fields[25] as AssignmentStatus?,
      isSelected: fields[27] as bool?,
      receivedScmQuantity: fields[28] as String?,
      currentScmQuantity: fields[29] as String?,
      remark: fields[30] as String?,
      cngStationId: fields[31] as String?,
      driverLicenseId: fields[32] as String?,
      motherStationFirebaseId: fields[33] as String?,
      routeId: fields[34] as String?,
      startDateTime: fields[35] as String?,
      delay: fields[36] as String?,
      scheduleDateTime: fields[37] as String?,
      endSelfPhoto: fields[40] as String?,
      endTruckImage: fields[42] as String?,
      slipPhoto: fields[38] as String?,
      startSelfPhoto: fields[39] as String?,
      startTruckImage: fields[41] as String?,
      driverId: fields[43] as String?,
      notificationDateTime: fields[44] as String?,
    );
  }

  @override
  void write(BinaryWriter writer, AssignmentModel obj) {
    writer
      ..writeByte(43)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.motherStation)
      ..writeByte(2)
      ..write(obj.motherStationId)
      ..writeByte(3)
      ..write(obj.cngStation)
      ..writeByte(4)
      ..write(obj.orderId)
      ..writeByte(5)
      ..write(obj.driverName)
      ..writeByte(6)
      ..write(obj.vehicleNo)
      ..writeByte(7)
      ..write(obj.scm)
      ..writeByte(8)
      ..write(obj.quantity)
      ..writeByte(9)
      ..write(obj.status)
      ..writeByte(10)
      ..write(obj.createdAt)
      ..writeByte(12)
      ..write(obj.createdFor)
      ..writeByte(13)
      ..write(obj.motherStationAddress)
      ..writeByte(14)
      ..write(obj.motherStationLat)
      ..writeByte(15)
      ..write(obj.motherStationLong)
      ..writeByte(16)
      ..write(obj.motherStationCity)
      ..writeByte(17)
      ..write(obj.motherStationDistrict)
      ..writeByte(18)
      ..write(obj.motherStationState)
      ..writeByte(19)
      ..write(obj.cngStationAddress)
      ..writeByte(20)
      ..write(obj.cngStationLat)
      ..writeByte(21)
      ..write(obj.cngStationLong)
      ..writeByte(22)
      ..write(obj.cngStationCity)
      ..writeByte(23)
      ..write(obj.cngStationDistrict)
      ..writeByte(24)
      ..write(obj.cngStationState)
      ..writeByte(25)
      ..write(obj.assignmentStatus)
      ..writeByte(27)
      ..write(obj.isSelected)
      ..writeByte(28)
      ..write(obj.receivedScmQuantity)
      ..writeByte(29)
      ..write(obj.currentScmQuantity)
      ..writeByte(30)
      ..write(obj.remark)
      ..writeByte(31)
      ..write(obj.cngStationId)
      ..writeByte(32)
      ..write(obj.driverLicenseId)
      ..writeByte(33)
      ..write(obj.motherStationFirebaseId)
      ..writeByte(34)
      ..write(obj.routeId)
      ..writeByte(35)
      ..write(obj.startDateTime)
      ..writeByte(36)
      ..write(obj.delay)
      ..writeByte(37)
      ..write(obj.scheduleDateTime)
      ..writeByte(38)
      ..write(obj.slipPhoto)
      ..writeByte(39)
      ..write(obj.startSelfPhoto)
      ..writeByte(40)
      ..write(obj.endSelfPhoto)
      ..writeByte(41)
      ..write(obj.startTruckImage)
      ..writeByte(42)
      ..write(obj.endTruckImage)
      ..writeByte(43)
      ..write(obj.driverId)
      ..writeByte(44)
      ..write(obj.notificationDateTime);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is AssignmentModelAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
