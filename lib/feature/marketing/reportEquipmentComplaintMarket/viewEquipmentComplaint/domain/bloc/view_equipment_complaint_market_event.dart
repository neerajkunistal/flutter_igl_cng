part of 'view_equipment_complaint_market_bloc.dart';

abstract class ViewEquipmentComplaintMarketEvent extends Equatable {
  const ViewEquipmentComplaintMarketEvent();
}

class ViewEquipmentComplaintMarketPageLoadEvent extends ViewEquipmentComplaintMarketEvent {
  final BuildContext context;
  final EquipmentComplaintType equipmentComplaintType;

  const ViewEquipmentComplaintMarketPageLoadEvent({required this.context, required this.equipmentComplaintType});

  @override
  List<Object?> get props => [context, equipmentComplaintType];
}

class ViewEquipmentComplaintMarketSearchEvent extends ViewEquipmentComplaintMarketEvent {
  final String keyword;

  const ViewEquipmentComplaintMarketSearchEvent({required this.keyword});

  @override
  List<Object?> get props => [keyword];
}

class ViewEquipmentComplaintMarketSelectedTabIndexEvent
    extends ViewEquipmentComplaintMarketEvent {
  final int selectedTabIndex;

  const ViewEquipmentComplaintMarketSelectedTabIndexEvent(
      {required this.selectedTabIndex});

  @override
  List<Object?> get props => [selectedTabIndex];
}

class ViewEquipmentComplaintMarketSelectedTabIndexMarketEvent
    extends ViewEquipmentComplaintMarketEvent {
  final int selectedTabIndex;

  const ViewEquipmentComplaintMarketSelectedTabIndexMarketEvent(
      {required this.selectedTabIndex});

  @override
  List<Object?> get props => [selectedTabIndex];
}

class ViewEquipmentComplaintMarketOpenMarketDetailEvent
    extends ViewEquipmentComplaintMarketEvent {
  final BuildContext context;
  final ComplaintMarketModel marketData;
  ViewEquipmentComplaintMarketOpenMarketDetailEvent({
    required this.context,
    required this.marketData,
  });

  @override
  // TODO: implement props
  List<Object?> get props => [context,marketData];
}

class ViewEquipmentComplaintMarketSelectedComplaintEvent
    extends ViewEquipmentComplaintMarketEvent {
  final int index;

  const ViewEquipmentComplaintMarketSelectedComplaintEvent(
      {required this.index});

  @override
  List<Object?> get props => [index];
}

class ViewEquipmentComplaintMarketSelectedDateRangeEvent
    extends ViewEquipmentComplaintMarketEvent {
  final BuildContext context;
  final DateTime fromDate;
  final DateTime toDate;

  const ViewEquipmentComplaintMarketSelectedDateRangeEvent(
      {required this.context, required this.fromDate, required this.toDate});

  @override
  List<Object?> get props => [context];
}

class ViewEquipmentComplaintMarketSelectTimeData extends ViewEquipmentComplaintMarketEvent {
  final BuildContext context;

  const ViewEquipmentComplaintMarketSelectTimeData({required this.context});

  @override
  List<Object?> get props => [context];
}

class ViewEquipmentComplaintMarketSelectDateData extends ViewEquipmentComplaintMarketEvent {
  final BuildContext context;

  const ViewEquipmentComplaintMarketSelectDateData({required this.context});

  @override
  List<Object?> get props => [context];
}

class ViewEquipmentComplaintMarketClosureEvent
    extends ViewEquipmentComplaintMarketEvent {
  final BuildContext context;
  final ReviewComplaintModel reviewComplaintData;
  final int index;

  const ViewEquipmentComplaintMarketClosureEvent(
      {required this.context, required this.reviewComplaintData, required this.index});

  @override
  List<Object?> get props => [context, reviewComplaintData, index];
}
