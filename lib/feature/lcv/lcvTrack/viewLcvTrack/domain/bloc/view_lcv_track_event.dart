part of 'view_lcv_track_bloc.dart';

abstract class ViewLcvTrackEvent extends Equatable {
  const ViewLcvTrackEvent();
}

class ViewLcvTruckDeleteStationEvent extends ViewLcvTrackEvent {
  final BuildContext context;
  final int index;

  const ViewLcvTruckDeleteStationEvent(
      {required this.context, required this.index});

  @override
  List<Object?> get props => [context, index];
}

class ViewLcvTruckPageLoadEvent extends ViewLcvTrackEvent {
  final BuildContext context;

  const ViewLcvTruckPageLoadEvent({required this.context});

  @override
  List<Object?> get props => [context];
}
