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

class AddEquipmentComplaintSelectEquipmentTypeDataEvent
    extends AddEquipmentComplaintEvent {
  final EquipmentTypeModel equipmentTypeData;

  const AddEquipmentComplaintSelectEquipmentTypeDataEvent(
      {required this.equipmentTypeData});

  @override
  List<Object?> get props => [equipmentTypeData];
}

class AddEquipmentComplaintSelectEquipmentDataEvent
    extends AddEquipmentComplaintEvent {
  final EquipmentModel equipmentData;

  const AddEquipmentComplaintSelectEquipmentDataEvent(
      {required this.equipmentData});

  @override
  List<Object?> get props => [equipmentData];
}

class AddEquipmentComplaintAddImageEvent extends AddEquipmentComplaintEvent {
  final BuildContext context;
  final int mediaType;
  final int index;

  const AddEquipmentComplaintAddImageEvent(
      {required this.context, required this.mediaType, required this.index});

  @override
  List<Object?> get props => [context, mediaType, index];
}

class AddEquipmentComplaintAddVideoEvent extends AddEquipmentComplaintEvent {
  final BuildContext context;
  final int mediaType;
  final int index;

  const AddEquipmentComplaintAddVideoEvent(
      {required this.context, required this.mediaType, required this.index});

  @override
  List<Object?> get props => [context, mediaType, index];
}

class AddEquipmentComplaintRemoveImageEvent extends AddEquipmentComplaintEvent {
  final int index;

  const AddEquipmentComplaintRemoveImageEvent(
      { required this.index});

  @override
  List<Object?> get props => [index];
}

class AddEquipmentComplaintRemoveVideoEvent extends AddEquipmentComplaintEvent {
  final int index;

  const AddEquipmentComplaintRemoveVideoEvent(
      { required this.index});

  @override
  List<Object?> get props => [index];
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
