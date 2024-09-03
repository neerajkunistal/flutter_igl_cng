part of 'lcv_truck_live_route_bloc.dart';

abstract class LcvTruckLiveRouteEvent extends Equatable {
  const LcvTruckLiveRouteEvent();
}

class LcvTruckLiveRoutePageLoadEvent extends LcvTruckLiveRouteEvent {
  final BuildContext context;
  final String driverUserId;
  final String routeId;

  const LcvTruckLiveRoutePageLoadEvent(
      {required this.context,
      required this.driverUserId,
      required this.routeId});

  @override
  List<Object?> get props => [context, driverUserId, routeId];
}
