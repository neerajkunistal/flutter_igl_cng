part of 'add_acknowledge_complaint_bloc.dart';

abstract class AddAcknowledgeComplaintState extends Equatable {
  const AddAcknowledgeComplaintState();
}

class AddAcknowledgeComplaintInitial extends AddAcknowledgeComplaintState {
  @override
  List<Object> get props => [];
}

class AddAcknowledgeComplaintPageLoadState extends AddAcknowledgeComplaintInitial {
  @override
  List<Object> get props => [];
}

class FetchAddAcknowledgeComplaintState extends AddAcknowledgeComplaintInitial {
  final List<ComplaintTypeModel> complaintTypeList;
  final ComplaintTypeModel complaintTypeData;
  final EquipmentTypeModel equipmentTypeData;
  final List<EquipmentTypeModel> equipmentTypeList;
  final TextEditingController descriptionController;
  final TextEditingController remarkController;
  final bool isLoader;
  final File file;
  final List<DepartmentModel> departmentList;
  final DepartmentModel departmentData;
  final List<ComplaintModel> complaintList;
  final ComplaintModel complaintData;
  final List<AcknowledgeModel> acknowledgeList;
  final AcknowledgeModel acknowledgeData;
  final String breakDownvalue;
  final ReviewComplaintModel reviewComplaintData;
  final bool isComplaintLoader;
  final List<AcknowledgeUserModel> acknowledgeUserList;
  final AcknowledgeUserModel acknowledgeUserData;
  final TextEditingController dateController;
  final TextEditingController timeController;
  final List<GeneralComplaintModel> generalComplaintList;
  final GeneralComplaintModel generalComplaintData;
  final TextEditingController generalDescriptionController;
  final String complaintStatus;


  FetchAddAcknowledgeComplaintState({
    required this.file,
    required this.isLoader,
    required this.descriptionController,
    required this.complaintTypeData,
    required this.complaintTypeList,
    required this.equipmentTypeData,
    required this.equipmentTypeList,
    required this.remarkController,
    required this.complaintList,
    required this.acknowledgeData,
    required this.acknowledgeList,
    required this.complaintData,
    required this.departmentData,
    required this.departmentList,
    required this.breakDownvalue,
    required this.reviewComplaintData,
    required this.isComplaintLoader,
    required this.acknowledgeUserData,
    required this.acknowledgeUserList,
    required this.dateController,
    required this.timeController,
    required this.generalComplaintData,
    required this.generalComplaintList,
    required this.generalDescriptionController,
    required this.complaintStatus,
  });


  @override
  List<Object> get props => [
    file,
    isLoader,
    descriptionController,
    complaintTypeData,
    complaintTypeList,
    equipmentTypeData,
    equipmentTypeList,
    remarkController,
    complaintList,
    acknowledgeData,
    acknowledgeList,
    complaintData,
    departmentData,
    departmentList,
    breakDownvalue,
    reviewComplaintData,
    isComplaintLoader,
    acknowledgeUserData,
    acknowledgeUserList,
    dateController,
    timeController,
    generalComplaintData,
    generalComplaintList,
    generalDescriptionController,
    complaintStatus,
  ];
}