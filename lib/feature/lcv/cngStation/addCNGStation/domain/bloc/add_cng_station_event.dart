part of 'add_cng_station_bloc.dart';

abstract class AddCngStationEvent extends Equatable {
  const AddCngStationEvent();
}

class AddCngStationPageLoadEvent extends AddCngStationEvent {
  final BuildContext context;

  const AddCngStationPageLoadEvent({required this.context});

  @override
  List<Object?> get props => [context];
}

class AddCngStationSetAddressEvent extends AddCngStationEvent {
  final dynamic address;

  const AddCngStationSetAddressEvent({required this.address});

  @override
  List<Object?> get props => [address];
}

class AddCngStationEditEvent extends AddCngStationEvent {
  final CngStationModel cngStationData;
  final bool isEdit;

  const AddCngStationEditEvent(
      {required this.isEdit, required this.cngStationData});

  @override
  List<Object?> get props => [cngStationData, isEdit];
}

class AddCngStationSubmitEvent extends AddCngStationEvent {
  final BuildContext context;

  const AddCngStationSubmitEvent({required this.context});

  @override
  List<Object?> get props => [context];
}
