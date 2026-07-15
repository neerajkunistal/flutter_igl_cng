part of 'view_equipment_complaint_bloc.dart';

abstract class ViewEquipmentComplaintEvent extends Equatable {
  const ViewEquipmentComplaintEvent();
}

class ViewEquipmentComplaintPageLoadEvent extends ViewEquipmentComplaintEvent {
  final BuildContext context;
  final EquipmentComplaintType equipmentComplaintType;

  const ViewEquipmentComplaintPageLoadEvent({required this.context, required this.equipmentComplaintType});

  @override
  List<Object?> get props => [context, equipmentComplaintType];
}

class ViewEquipmentComplaintSearchEvent extends ViewEquipmentComplaintEvent {
  final String keyword;

  const ViewEquipmentComplaintSearchEvent({required this.keyword});

  @override
  List<Object?> get props => [keyword];
}

class ViewEquipmentComplaintSelectedTabIndexEvent
    extends ViewEquipmentComplaintEvent {
  final int selectedTabIndex;

  const ViewEquipmentComplaintSelectedTabIndexEvent(
      {required this.selectedTabIndex});

  @override
  List<Object?> get props => [selectedTabIndex];
}

class ViewEquipmentComplaintSelectedComplaintEvent
    extends ViewEquipmentComplaintEvent {
  final int index;

  const ViewEquipmentComplaintSelectedComplaintEvent(
      {required this.index});

  @override
  List<Object?> get props => [index];
}

class ViewEquipmentComplaintSelectedDateRangeEvent
    extends ViewEquipmentComplaintEvent {
  final BuildContext context;
  final DateTime fromDate;
  final DateTime toDate;

  const ViewEquipmentComplaintSelectedDateRangeEvent(
      {required this.context, required this.fromDate, required this.toDate});

  @override
  List<Object?> get props => [context];
}

class ViewEquipmentComplaintSelectTimeData extends ViewEquipmentComplaintEvent {
  final BuildContext context;

  const ViewEquipmentComplaintSelectTimeData({required this.context});

  @override
  List<Object?> get props => [context];
}

class ViewEquipmentComplaintSelectDateData extends ViewEquipmentComplaintEvent {
  final BuildContext context;

  const ViewEquipmentComplaintSelectDateData({required this.context});

  @override
  List<Object?> get props => [context];
}

class ViewEquipmentComplaintClosureEvent
    extends ViewEquipmentComplaintEvent {
  final BuildContext context;
  final ReviewComplaintModel reviewComplaintData;
  final int index;

  const ViewEquipmentComplaintClosureEvent(
      {required this.context, required this.reviewComplaintData, required this.index});

  @override
  List<Object?> get props => [context, reviewComplaintData, index];
}
