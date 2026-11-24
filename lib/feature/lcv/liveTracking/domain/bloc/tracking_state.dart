part of 'tracking_bloc.dart';

abstract class TrackingState extends Equatable {
  const TrackingState();
}

class TrackingInitial extends TrackingState {
  @override
  List<Object> get props => [];
}

class TrackingPageLoadState extends TrackingInitial {
  @override
  List<Object> get props => [];
}

class FetchTrackingDataState extends TrackingInitial {
  final bool isLoader;
  final List<TrackingModel> trackingList;
  final Set<Marker> markerTrackingPoints;
  final LatLng latLng;

  FetchTrackingDataState({
    required this.isLoader,
    required this.trackingList,
    required this.markerTrackingPoints,
    required this.latLng,
  });

  @override
  List<Object> get props => [
        isLoader,
        trackingList,
        markerTrackingPoints,
        latLng,
      ];
}
