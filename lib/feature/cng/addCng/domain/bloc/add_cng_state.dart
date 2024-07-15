part of 'add_cng_bloc.dart';

sealed class AddCngState extends Equatable {
  const AddCngState();
}

final class AddCngInitial extends AddCngState {
  @override
  List<Object> get props => [];
}

final class AddCngPageLoadState extends AddCngInitial {
  @override
  List<Object> get props => [];
}

final class FetchAddCngDataState extends AddCngInitial {
  final bool isLoader;
  final List<CategoryModel> categoryList;
  final CategoryModel categoryData;
  final List<CrStationModel> crStationList;
  final CrStationModel crStationData;
  final TextEditingController descriptionController;
  final TextEditingController dateController;
  final TextEditingController timeController;
  final TextEditingController reportedByController;
  final List<File> fileList;

  FetchAddCngDataState({
    required this.isLoader,
    required this.categoryData,
    required this.categoryList,
    required this.crStationList,
    required this.crStationData,
    required this.dateController,
    required this.fileList,
    required this.descriptionController,
    required this.reportedByController,
    required this.timeController,
  });

  @override
  List<Object> get props => [
        isLoader,
        categoryData,
        categoryList,
        crStationList,
        crStationData,
        dateController,
        fileList,
        descriptionController,
        reportedByController,
        timeController,
      ];
}
