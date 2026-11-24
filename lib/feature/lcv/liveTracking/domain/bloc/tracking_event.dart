part of 'tracking_bloc.dart';

abstract class TrackingEvent extends Equatable {
  const TrackingEvent();
}

class TrackingPageLoadEvent extends TrackingEvent {
  final BuildContext context;

  const TrackingPageLoadEvent({required this.context});

  @override
  List<Object?> get props => [context];
}
