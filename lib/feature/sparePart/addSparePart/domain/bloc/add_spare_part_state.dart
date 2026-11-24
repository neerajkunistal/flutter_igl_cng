part of 'add_spare_part_bloc.dart';

sealed class AddSparePartState extends Equatable {
  const AddSparePartState();
}

final class AddSparePartInitial extends AddSparePartState {
  @override
  List<Object> get props => [];
}

final class AddSparePartPageLoadState extends AddSparePartInitial {
  @override
  List<Object> get props => [];
}

final class FetchAddSparePartDataState extends AddSparePartInitial {
  final SparesModel sparesData;
  final UomTypeModel uomTypeData;
  final TextEditingController qtyController;
  final TextEditingController materialCodeController;
  final TextEditingController remarkCodeController;
  final bool isLoader;
  final List<SparesModel> sparePartList;
  final List<PartModel> partList;

  FetchAddSparePartDataState({
   required this.remarkCodeController,
   required this.materialCodeController,
   required this.qtyController,
   required this.sparesData,
   required this.uomTypeData,
   required this.isLoader,
   required this.sparePartList,
   required this.partList,
});

  @override
  List<Object> get props => [
    remarkCodeController,
    materialCodeController,
    qtyController,
    sparesData,
    uomTypeData,
    isLoader,
    sparePartList,
    partList,
  ];
}