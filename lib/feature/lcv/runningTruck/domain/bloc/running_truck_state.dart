part of 'running_truck_bloc.dart';

abstract class RunningTruckState extends Equatable {
  const RunningTruckState();
}

class RunningTruckInitial extends RunningTruckState {
  @override
  List<Object> get props => [];
}

class RunningTruckPageLoadState extends RunningTruckInitial {
  @override
  List<Object> get props => [];
}

class FetchRunningTruckDataState extends RunningTruckInitial {
  final List<AssignmentModel> assignmentList;
  final bool isLoader;
  final LatLng latLng;
  final Set<Marker> markerRunningTruckPoints;
  final List<RunningTruckModel> runningTruckList;

  FetchRunningTruckDataState({
    required this.assignmentList,
    required this.isLoader,
    required this.latLng,
    required this.markerRunningTruckPoints,
    required this.runningTruckList,
  });

  @override
  List<Object> get props => [assignmentList, isLoader, latLng, runningTruckList];
}
