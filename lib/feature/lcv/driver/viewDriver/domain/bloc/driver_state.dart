part of 'driver_bloc.dart';

abstract class DriverState extends Equatable {
  const DriverState();
}

class DriverInitial extends DriverState {
  @override
  List<Object> get props => [];
}

class DriverPageLoadState extends DriverInitial {
  @override
  List<Object> get props => [];
}

class FetchDriverDateState extends DriverInitial {
  final List<DriverModel> driverList;

  FetchDriverDateState({required this.driverList});

  @override
  List<Object> get props => [driverList];
}
