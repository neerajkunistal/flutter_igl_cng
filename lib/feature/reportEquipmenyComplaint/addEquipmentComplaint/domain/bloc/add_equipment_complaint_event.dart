part of 'add_equipment_complaint_bloc.dart';

abstract class AddEquipmentComplaintEvent extends Equatable {
  const AddEquipmentComplaintEvent();
}

class AddEquipmentComplaintPageLoadEvent extends AddEquipmentComplaintEvent {
  final BuildContext context;

  const AddEquipmentComplaintPageLoadEvent({required this.context});

  @override
  List<Object?> get props => [context];
}

class AddEquipmentComplaintSelectComplaintDataEvent
    extends AddEquipmentComplaintEvent {
  final ComplaintTypeModel complaintTypeData;

  const AddEquipmentComplaintSelectComplaintDataEvent(
      {required this.complaintTypeData});

  @override
  List<Object?> get props => [complaintTypeData];
}

class AddEquipmentComplaintSelectGeneralDataEvent
    extends AddEquipmentComplaintEvent {
  final GeneralComplaintModel generalComplaintData;

  const AddEquipmentComplaintSelectGeneralDataEvent(
      {required this.generalComplaintData});

  @override
  List<Object?> get props => [generalComplaintData];
}

class AddEquipmentComplaintSelectEquipmentDataEvent
    extends AddEquipmentComplaintEvent {
  final EquipmentTypeModel equipmentTypeData;

  const AddEquipmentComplaintSelectEquipmentDataEvent(
      {required this.equipmentTypeData});

  @override
  List<Object?> get props => [equipmentTypeData];
}

class AddEquipmentComplaintAddImageEvent extends AddEquipmentComplaintEvent {
  final BuildContext context;
  final int mediaType;

  const AddEquipmentComplaintAddImageEvent(
      {required this.context, required this.mediaType});

  @override
  List<Object?> get props => [context, mediaType];
}

class AddEquipmentComplaintSelectTimeData extends AddEquipmentComplaintEvent {
  final BuildContext context;

  const AddEquipmentComplaintSelectTimeData({required this.context});

  @override
  List<Object?> get props => [context];
}

class AddEquipmentComplaintSelectDateData extends AddEquipmentComplaintEvent {
  final BuildContext context;

  const AddEquipmentComplaintSelectDateData({required this.context});

  @override
  List<Object?> get props => [context];
}

class AddEquipmentComplaintSubmitEvent extends AddEquipmentComplaintEvent {
  final BuildContext context;

  const AddEquipmentComplaintSubmitEvent({required this.context});

  @override
  List<Object?> get props => [context];
}
