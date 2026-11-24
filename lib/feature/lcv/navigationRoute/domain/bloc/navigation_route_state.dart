part of 'navigation_route_bloc.dart';

abstract class NavigationRouteState extends Equatable {
  const NavigationRouteState();
}

class NavigationRouteInitial extends NavigationRouteState {
  @override
  List<Object> get props => [];
}

class NavigationRoutePageLoadState extends NavigationRouteInitial {
  @override
  List<Object> get props => [];
}

class FetchNavigationRouteDataState extends NavigationRouteInitial {
  final Set<Polyline> polyline;
  final LatLng latLng;
  final bool isLoader;
  final Set<Marker> currentLocationMarker;
  final CameraPosition cameraPosition;
  final Completer<GoogleMapController> controller;
  final double totalDistance;
  final String totalTime;

  FetchNavigationRouteDataState({
    required this.latLng,
    required this.isLoader,
    required this.polyline,
    required this.currentLocationMarker,
    required this.cameraPosition,
    required this.controller,
    required this.totalDistance,
    required this.totalTime,
  });

  @override
  List<Object> get props => [
        polyline,
        latLng,
        isLoader,
        currentLocationMarker,
        cameraPosition,
        controller,
        totalDistance,
        totalTime,
      ];
}
