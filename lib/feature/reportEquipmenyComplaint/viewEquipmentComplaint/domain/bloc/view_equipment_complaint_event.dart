part of 'view_equipment_complaint_bloc.dart';

abstract class ViewEquipmentComplaintEvent extends Equatable {
  const ViewEquipmentComplaintEvent();
}

class ViewEquipmentComplaintPageLoadEvent extends ViewEquipmentComplaintEvent {
  final BuildContext context;

  const ViewEquipmentComplaintPageLoadEvent({required this.context});

  @override
  List<Object?> get props => [context];
}
