part of 'add_lcv_track_bloc.dart';

abstract class AddLcvTrackEvent extends Equatable {
  const AddLcvTrackEvent();
}

class AddLcvTruckPageLoadEvent extends AddLcvTrackEvent {
  final BuildContext context;

  const AddLcvTruckPageLoadEvent({required this.context});

  @override
  List<Object?> get props => [context];
}

class AddLcvTruckSelectFuelTypeEvent extends AddLcvTrackEvent {
  final FuelTypeModel fuelTypeData;

  const AddLcvTruckSelectFuelTypeEvent({required this.fuelTypeData});

  @override
  List<Object?> get props => [fuelTypeData];
}

class AddLcvTruckEditEvent extends AddLcvTrackEvent {
  final LcvTruckModel lcvTruckData;
  final bool isEdit;

  const AddLcvTruckEditEvent(
      {required this.isEdit, required this.lcvTruckData});

  @override
  List<Object?> get props => [lcvTruckData, isEdit];
}

class AddLcvTruckSubmitEvent extends AddLcvTrackEvent {
  final BuildContext context;

  const AddLcvTruckSubmitEvent({required this.context});

  @override
  List<Object?> get props => [context];
}
