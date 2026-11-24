part of 'running_truck_bloc.dart';

abstract class RunningTruckEvent extends Equatable {
  const RunningTruckEvent();
}

class RunningTruckSearchEvent extends RunningTruckEvent {
  final String keyword;
  final BuildContext context;
  const RunningTruckSearchEvent({
    required this.keyword,
    required this.context,
  });
  @override
  List<Object?> get props => [
    keyword,
    context
  ];
}

class RunningTruckPageLoadEvent extends RunningTruckEvent {
  final BuildContext context;

  const RunningTruckPageLoadEvent({required this.context});

  @override
  List<Object?> get props => [context];
}
