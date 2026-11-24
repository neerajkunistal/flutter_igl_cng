part of 'view_cng_scm_bloc.dart';

abstract class ViewCngScmState extends Equatable {
  const ViewCngScmState();
}

class ViewCngScmInitial extends ViewCngScmState {
  @override
  List<Object> get props => [];
}

class ViewCngScmPageLoadState extends ViewCngScmInitial {
  @override
  List<Object> get props => [];
}

class FetchViewCngScmDataState extends ViewCngScmInitial {
  final List<CngScmModel> cngScmList;

  FetchViewCngScmDataState({required this.cngScmList});

  @override
  List<Object> get props => [];
}
