part of 'add_acknowledge_market_complaint_bloc.dart';

abstract class AddAcknowledgeMarketComplaintState extends Equatable {
  const AddAcknowledgeMarketComplaintState();
}

class AddAcknowledgeMarketComplaintInitial extends AddAcknowledgeMarketComplaintState {
  @override
  List<Object> get props => [];
}

class AddAcknowledgeMarketComplaintPageLoadState
    extends AddAcknowledgeMarketComplaintInitial {
  @override
  List<Object> get props => [];
}

class FetchAddAcknowledgeMarketComplaintState extends AddAcknowledgeMarketComplaintInitial {
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
  final ComplaintMarketModel acknowledgeData;
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
  final TextEditingController personResponsibleController;
  final List<PlannerModel> plannerList;
  final PlannerModel plannerData;
  final List<WorkCenterModel> workCenterList;
  final WorkCenterModel workCenterData;
  final List<ComplaintDescriptionModel> complaintDescriptionList;
  final ComplaintDescriptionModel complaintDescriptionData;
  final List<VendorMarketModel> listOfVendorMarketData;
  final VendorMarketModel vendorMarketData;

  FetchAddAcknowledgeMarketComplaintState({
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
    required this.personResponsibleController,
    required this.workCenterList,
    required this.workCenterData,
    required this.plannerData,
    required this.plannerList,
    required this.complaintDescriptionList,
    required this.complaintDescriptionData,
    required this.listOfVendorMarketData,
    required this.vendorMarketData,
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
        personResponsibleController,
        workCenterList,
        workCenterData,
        plannerData,
        plannerList,
        complaintDescriptionList,
        complaintDescriptionData,
    listOfVendorMarketData,
        vendorMarketData,
      ];
}
