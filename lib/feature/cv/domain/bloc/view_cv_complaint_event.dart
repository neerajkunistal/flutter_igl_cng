part of 'view_cv_complaint_bloc.dart';

sealed class ViewCvComplaintEvent extends Equatable {
  const ViewCvComplaintEvent();
}

class ViewCvComplaintPageLoadEvent extends ViewCvComplaintEvent {
  @override
  List<Object?> get props => [];
}

class ViewCvComplaintSelectComplaintStatusEvent extends ViewCvComplaintEvent {
  final ComplaintStatus complaintStatusData;

  const ViewCvComplaintSelectComplaintStatusEvent(
      {required this.complaintStatusData});

  @override
  List<Object?> get props => [complaintStatusData];
}

class ViewCvComplaintSelectListEvent extends ViewCvComplaintEvent {
  final int listIndex;
  const ViewCvComplaintSelectListEvent(
      {required this.listIndex});
  @override
  List<Object?> get props => [listIndex];
}

class ViewCvComplaintSelectFileEvent extends ViewCvComplaintEvent {
  final BuildContext context;
  final int mediaType;

  const ViewCvComplaintSelectFileEvent(
      {required this.context, required this.mediaType});

  @override
  List<Object?> get props => [context, mediaType];
}

class ViewCvComplaintSubmitEvent extends ViewCvComplaintEvent {
  final BuildContext context;
  final CngModel cngData;

  const ViewCvComplaintSubmitEvent(
      {required this.context, required this.cngData});

  @override
  List<Object?> get props => [context, cngData];
}

class ViewCvComplaintSelectCngDataEvent extends ViewCvComplaintEvent {
  final CngModel cngData;

  const ViewCvComplaintSelectCngDataEvent(
      {required this.cngData});

  @override
  List<Object?> get props => [cngData];
}

class ViewCvComplaintSearchDataEvent extends ViewCvComplaintEvent {
  final String keyword;

  const ViewCvComplaintSearchDataEvent({required this.keyword});

  @override
  List<Object?> get props => [keyword];
}

class ViewCvComplaintSelectedDateRangeEvent extends ViewCvComplaintEvent {
  final BuildContext context;
  final DateTime fromDate;
  final DateTime toDate;

  const ViewCvComplaintSelectedDateRangeEvent(
      {required this.context, required this.fromDate, required this.toDate});

  @override
  List<Object?> get props => [context];
}

class ViewCvComplaintMeasurementSelectFileEvent extends ViewCvComplaintEvent {
  final BuildContext context;
  final int mediaType;

  const ViewCvComplaintMeasurementSelectFileEvent(
      {required this.context, required this.mediaType});

  @override
  List<Object?> get props => [context, mediaType];
}

class ViewCvComplaintMeasurementDeleteFileEvent extends ViewCvComplaintEvent {
  final int index;

  const ViewCvComplaintMeasurementDeleteFileEvent(
      {required this.index});

  @override
  List<Object?> get props => [index];
}

class ViewCvComplaintDeleteEstimatePhotoFileEvent extends ViewCvComplaintEvent {
  final int index;

  const ViewCvComplaintDeleteEstimatePhotoFileEvent(
      {required this.index});

  @override
  List<Object?> get props => [index];
}

class ViewCvComplaintMeasurementSheetSelectFileEvent extends ViewCvComplaintEvent {
  final BuildContext context;
  final int mediaType;

  const ViewCvComplaintMeasurementSheetSelectFileEvent(
      {required this.context, required this.mediaType});

  @override
  List<Object?> get props => [context, mediaType];
}

class ViewCvComplaintFetchStationEvent extends ViewCvComplaintEvent {
  final BuildContext context;
  const ViewCvComplaintFetchStationEvent({required this.context});
  @override
  List<Object?> get props => [context];
}

class ViewCvComplaintSelectStationEvent extends ViewCvComplaintEvent {
  final StationModel stationData;
  const ViewCvComplaintSelectStationEvent({required this.stationData});
  @override
  List<Object?> get props => [stationData];
}

class ViewCvComplaintSearchStationEvent extends ViewCvComplaintEvent {
  final String keyword;

  const ViewCvComplaintSearchStationEvent({required this.keyword});

  @override
  List<Object?> get props => [keyword];
}

class ViewCvComplaintAddParticularEvent extends ViewCvComplaintEvent {
  final BuildContext context;
  const ViewCvComplaintAddParticularEvent({required this.context});
  @override
  List<Object?> get props => [context];
}

class ViewCvComplaintRemoveParticularEvent extends ViewCvComplaintEvent {
  final int index;
  const ViewCvComplaintRemoveParticularEvent({required this.index});
  @override
  List<Object?> get props => [index];
}

class ViewCvComplaintSelectControlRoomDataEvent extends ViewCvComplaintEvent {
  final ControlRoomModel controlRoomData;

  const ViewCvComplaintSelectControlRoomDataEvent(
      {required this.controlRoomData,});

  @override
  List<Object?> get props => [controlRoomData];
}

class ViewCvComplaintSelectMeasureDataEvent extends ViewCvComplaintEvent {
  final MeasureTypeModel measureTypeData;

  const ViewCvComplaintSelectMeasureDataEvent(
      {required this.measureTypeData,});

  @override
  List<Object?> get props => [measureTypeData];
}


class ViewCvComplaintSelectUnitNameEvent extends ViewCvComplaintEvent {
  final UnitName unitNameData;

  const ViewCvComplaintSelectUnitNameEvent(
      {required this.unitNameData,});

  @override
  List<Object?> get props => [unitNameData];
}


class ViewCvComplaintFilterSubmitEvent extends ViewCvComplaintEvent {
  final bool isFilterSubmit;

  const ViewCvComplaintFilterSubmitEvent(
      {required this.isFilterSubmit,});

  @override
  List<Object?> get props => [isFilterSubmit];
}


class ViewCvComplaintSubmitMeasurementEvent extends ViewCvComplaintEvent {
  final BuildContext context;
  final CngModel cngData;

  const ViewCvComplaintSubmitMeasurementEvent(
      {required this.context, required this.cngData});

  @override
  List<Object?> get props => [context, cngData];
}
