part of 'navigation_route_bloc.dart';

abstract class NavigationRouteEvent extends Equatable {
  const NavigationRouteEvent();
}

class NavigationRoutePageLoadEvent extends NavigationRouteEvent {
  final BuildContext context;

  const NavigationRoutePageLoadEvent({required this.context});

  @override
  List<Object?> get props => [context];
}

class NavigationRouteSetPolyLineEvent extends NavigationRouteEvent {
  final Set<Polyline> polyline;

  const NavigationRouteSetPolyLineEvent({required this.polyline});

  @override
  List<Object?> get props => [polyline];
}

class NavigationRouteRefreshPageEvent extends NavigationRouteEvent {
  final BuildContext context;

  const NavigationRouteRefreshPageEvent({required this.context});

  @override
  List<Object?> get props => [context];
}
