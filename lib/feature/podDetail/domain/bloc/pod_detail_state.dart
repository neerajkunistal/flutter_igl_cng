part of 'pod_detail_bloc.dart';

sealed class PodDetailState extends Equatable {
  const PodDetailState();
}

final class PodDetailInitial extends PodDetailState {
  @override
  List<Object> get props => [];
}

final class PodDetailPageLoadState extends PodDetailInitial {
  @override
  List<Object> get props => [];
}

final class FetchPodDetailDataState extends PodDetailInitial {
  final bool isLoader;
  final List<PodDetailModel> podDetailList;
  final TextEditingController searchController;

  FetchPodDetailDataState({
    required this.isLoader,
    required this.podDetailList,
    required this.searchController,
  });

  @override
  List<Object> get props => [ isLoader, podDetailList, searchController ];
}