part of 'add_equipment_complaint_bloc.dart';

abstract class AddEquipmentComplaintState extends Equatable {
  const AddEquipmentComplaintState();
}

class AddEquipmentComplaintInitial extends AddEquipmentComplaintState {
  @override
  List<Object> get props => [];
}

class AddEquipmentComplaintPageLoadState extends AddEquipmentComplaintInitial {
  @override
  List<Object> get props => [];
}

class FetchAddEquipmentComplaintState extends AddEquipmentComplaintInitial {
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

  FetchAddEquipmentComplaintState({
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
      ];
}
