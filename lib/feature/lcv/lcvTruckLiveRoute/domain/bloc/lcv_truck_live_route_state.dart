part of 'lcv_truck_live_route_bloc.dart';

abstract class LcvTruckLiveRouteState extends Equatable {
  const LcvTruckLiveRouteState();
}

class LcvTruckLiveRouteInitial extends LcvTruckLiveRouteState {
  @override
  List<Object> get props => [];
}

class LcvTruckLiveRoutePageLoadState extends LcvTruckLiveRouteInitial {
  @override
  List<Object> get props => [];
}

class FetchLcvTruckLiveRouteDataState extends LcvTruckLiveRouteInitial {
  final bool isLoader;
  final Set<Polyline> polyline;
  final Set<Marker> markerTrackingPoints;
  final LatLng latLng;

  FetchLcvTruckLiveRouteDataState({
    required this.isLoader,
    required this.polyline,
    required this.markerTrackingPoints,
    required this.latLng,
  });

  @override
  List<Object> get props => [
        isLoader,
        polyline,
        markerTrackingPoints,
        latLng,
      ];
}
