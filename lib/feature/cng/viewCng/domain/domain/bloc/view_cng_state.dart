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
  final List<CngModel> cngAllItemsList;
  final int listIndex;
  final bool isFilterLoader;
  final int tabIndex;

  FetchViewCngDataState({
    required this.cngList,
    required this.cngAllItemsList,
    required this.isFilterLoader,
    required this.tabIndex,
    required this.listIndex,
  });

  @override
  List<Object> get props => [cngList,
    cngAllItemsList,
    isFilterLoader,
    tabIndex,
    listIndex,
  ];
}
