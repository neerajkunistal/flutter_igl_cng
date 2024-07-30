part of 'add_scrap_bloc.dart';

sealed class AddScrapState extends Equatable {
  const AddScrapState();
}

final class AddScrapInitial extends AddScrapState {
  @override
  List<Object> get props => [];
}

final class AddScrapPageLoadState extends AddScrapInitial {
  @override
  List<Object> get props => [];
}

final class FetchAddScrapDataState extends AddScrapInitial {
  final bool isLoader;
  final List<ScrapUnitTypeModel> scrapUnitTypeList;
  final ScrapUnitTypeModel scrapUnitTypeData;
  final TextEditingController srNumberController;
  final TextEditingController descriptionController;
  final TextEditingController unitController;
  final List<File> filesList;
  final List<ScrapModel> scrapList;

  FetchAddScrapDataState({
   required this.filesList,
   required this.scrapUnitTypeData,
   required this.isLoader,
   required this.descriptionController,
   required this.scrapUnitTypeList,
   required this.srNumberController,
   required this.unitController,
   required this.scrapList,
  });

  @override
  List<Object> get props => [
    filesList,
    scrapUnitTypeData,
    isLoader,
    descriptionController,
    scrapUnitTypeList,
    srNumberController,
    unitController,
    scrapList,
  ];
}

