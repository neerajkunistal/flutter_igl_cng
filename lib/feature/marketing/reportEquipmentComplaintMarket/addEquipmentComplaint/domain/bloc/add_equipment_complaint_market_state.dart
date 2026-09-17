part of 'add_equipment_complaint_market_bloc.dart';

abstract class AddEquipmentComplaintMarketState extends Equatable {
  const AddEquipmentComplaintMarketState();
}

class AddEquipmentComplaintMarketInitial extends AddEquipmentComplaintMarketState {
  @override
  List<Object> get props => [];
}

class AddEquipmentComplaintMarketPageLoadState extends AddEquipmentComplaintMarketInitial {
  @override
  List<Object> get props => [];
}

class FetchAddEquipmentComplaintMarketState extends AddEquipmentComplaintMarketInitial {
  final List<ComplaintTypeModel> complaintTypeList;
  final ComplaintTypeModel complaintTypeData;
  final EquipmentTypeModel equipmentTypeData;
  final List<EquipmentTypeModel> equipmentTypeList;
  final TextEditingController descriptionController;
  final TextEditingController reportByController;
  final TextEditingController dateController;
  final TextEditingController timeController;
  final bool isLoader;
  final bool isFileLoader;
  final List<File> files;
  final List<File> videoFiles;
  final List<GeneralComplaintModel> generalComplaintList;
  final GeneralComplaintModel generalComplaintData;
  final TextEditingController generalDescriptionController;
  final EquipmentModel equipmentData;
  final List<EquipmentModel> equipmentList;
  final List<ComplaintDescriptionModel> complaintDescriptionList;
  final ComplaintDescriptionModel complaintDescriptionData;

  // Marketing additions
  final List<FacilityModel> facilityList;
  final FacilityModel facilityData;
  final List<MarketCategoryModel> categoryList;
  final MarketCategoryModel categoryData;
  final List<SubCategoryModel> subCategoryList;
  final SubCategoryModel subCategoryData;
  final TextEditingController facilityOtherController;
  final TextEditingController marketingDescriptionController;
  final TextEditingController userNameController;
  final TextEditingController mobileController;

  FetchAddEquipmentComplaintMarketState({
    required this.files,
    required this.isLoader,
    required this.isFileLoader,
    required this.descriptionController,
    required this.complaintTypeData,
    required this.complaintTypeList,
    required this.equipmentTypeData,
    required this.equipmentTypeList,
    required this.reportByController,
    required this.dateController,
    required this.timeController,
    required this.generalComplaintData,
    required this.generalComplaintList,
    required this.generalDescriptionController,
    required this.videoFiles,
    required this.equipmentData,
    required this.equipmentList,
    required this.complaintDescriptionList,
    required this.complaintDescriptionData,
    required this.facilityList,
    required this.facilityData,
    required this.categoryList,
    required this.categoryData,
    required this.subCategoryList,
    required this.subCategoryData,
    required this.facilityOtherController,
    required this.marketingDescriptionController,
    required this.userNameController,
    required this.mobileController,
  });

  @override
  List<Object> get props => [
    files,
    isLoader,
    isFileLoader,
    descriptionController,
    complaintTypeData,
    complaintTypeList,
    equipmentTypeData,
    equipmentTypeList,
    reportByController,
    dateController,
    timeController,
    generalComplaintData,
    generalComplaintList,
    generalDescriptionController,
    videoFiles,
    equipmentList,
    equipmentData,
    complaintDescriptionList,
    complaintDescriptionData,
    facilityList,
    facilityData,
    categoryList,
    categoryData,
    subCategoryList,
    subCategoryData,
    facilityOtherController,
    marketingDescriptionController,
    userNameController,
    mobileController,
  ];
}
