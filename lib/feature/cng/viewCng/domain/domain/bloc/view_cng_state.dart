part of 'view_cng_bloc.dart';

sealed class ViewCngState extends Equatable {
  const ViewCngState();
}

final class ViewCngInitial extends ViewCngState {
  @override
  List<Object> get props => [];
}

final class ViewCngPageLoadState extends ViewCngInitial {
  @override
  List<Object> get props => [];
}

final class FetchViewCngDataState extends ViewCngInitial {
  final List<CngModel> cngList;
  final bool isFilterLoader;

  FetchViewCngDataState({required this.cngList, required this.isFilterLoader});

  @override
  List<Object> get props => [cngList, isFilterLoader];
}
