import 'package:equatable/equatable.dart';
import 'package:flutter_igl_cng/feature/lcv/cngStation/viewCNGStation/domain/model/cng_stattion_model.dart';

abstract class CngStationState extends Equatable {
  const CngStationState();
}

class CngStationInitial extends CngStationState {
  @override
  List<Object> get props => [];
}

class CngStationPageLoadState extends CngStationInitial {
  @override
  List<Object> get props => [];
}

class FetchCngStationDataState extends CngStationInitial {
  final List<CngStationModel> cngStationList;

  FetchCngStationDataState({required this.cngStationList});

  @override
  List<Object> get props => [cngStationList];
}
