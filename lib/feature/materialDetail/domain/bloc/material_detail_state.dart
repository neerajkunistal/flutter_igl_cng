part of 'material_detail_bloc.dart';

sealed class MaterialDetailState extends Equatable {
  const MaterialDetailState();
}

final class MaterialDetailInitial extends MaterialDetailState {
  @override
  List<Object> get props => [];
}

final class MaterialDetailPageLoadState extends MaterialDetailInitial {
  @override
  List<Object> get props => [];
}

final class FetchMaterialDetailDataState extends MaterialDetailInitial {
  final bool isLoader;
  final List<MaterialDetailModel> materialDetailList;
  final TextEditingController searchController;

  FetchMaterialDetailDataState({
    required this.isLoader,
    required this.materialDetailList,
    required this.searchController,
  });

  @override
  List<Object> get props => [ isLoader, materialDetailList, searchController ];
}
