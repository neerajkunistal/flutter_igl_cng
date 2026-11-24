part of 'driver_bloc.dart';

abstract class DriverEvent extends Equatable {
  const DriverEvent();
}

class DriverDeactivateEvent extends DriverEvent {
  final int index;
  final BuildContext context;

  const DriverDeactivateEvent({required this.index, required this.context});

  @override
  List<Object?> get props => [index, context];
}

class DriverPageLoadEvent extends DriverEvent {
  final BuildContext context;

  const DriverPageLoadEvent({required this.context});

  @override
  List<Object?> get props => [context];
}
