part of 'over_speed_alert_bloc.dart';

sealed class OverSpeedAlertEvent extends Equatable {
  const OverSpeedAlertEvent();
}

class OverSpeedAlertPageLoadEvent extends OverSpeedAlertEvent {
  final BuildContext context;
  const OverSpeedAlertPageLoadEvent({required this.context});
  @override
  List<Object?> get props => [context];
}

class OverSpeedAlertMarkReadEvent extends OverSpeedAlertEvent {
  final BuildContext context;
  final int index;
  const OverSpeedAlertMarkReadEvent({required this.context, required this.index});
  @override
  List<Object?> get props => [context, index];
}