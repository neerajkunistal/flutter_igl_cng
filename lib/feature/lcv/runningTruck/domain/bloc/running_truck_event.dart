part of 'running_truck_bloc.dart';

abstract class RunningTruckEvent extends Equatable {
  const RunningTruckEvent();
}

class RunningTruckPageLoadEvent extends RunningTruckEvent {
  final BuildContext context;

  const RunningTruckPageLoadEvent({required this.context});

  @override
  List<Object?> get props => [context];
}
