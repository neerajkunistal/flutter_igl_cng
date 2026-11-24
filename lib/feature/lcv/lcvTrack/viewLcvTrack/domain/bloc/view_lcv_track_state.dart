part of 'view_lcv_track_bloc.dart';

abstract class ViewLcvTrackState extends Equatable {
  const ViewLcvTrackState();
}

class ViewLcvTrackInitial extends ViewLcvTrackState {
  @override
  List<Object> get props => [];
}

class ViewLcvTrackPageLoadState extends ViewLcvTrackInitial {
  @override
  List<Object> get props => [];
}

class FetchViewLcvTrackDataState extends ViewLcvTrackInitial {
  final List<LcvTruckModel> lcvTruckList;

  FetchViewLcvTrackDataState({required this.lcvTruckList});

  @override
  List<Object> get props => [lcvTruckList];
}
