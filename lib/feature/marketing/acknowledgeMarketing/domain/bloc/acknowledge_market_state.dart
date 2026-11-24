part of 'acknowledge_market_bloc.dart';

abstract class AcknowledgeMarketState extends Equatable {
  const AcknowledgeMarketState();
}

class AcknowledgeMarketInitial extends AcknowledgeMarketState {
  @override
  List<Object> get props => [];
}

class AcknowledgeMarketPageLoadState extends AcknowledgeMarketInitial {
  @override
  List<Object> get props => [];
}

class FetchAcknowledgeMarketDataState extends AcknowledgeMarketInitial {
  final bool isLoader;
  final List<AcknowledgeModel> acknowledgeList;
  final List<AcknowledgeUserModel> acknowledgeUserList;
  final AcknowledgeUserModel acknowledgeUserData;
  final bool isUserLoader;
  final TextEditingController remarkController;
  final TextEditingController closeDateController;
  final TextEditingController closedTimeController;
  final List<VendorModel> vendorList;
  final VendorModel vendorData;
  final List<AssignTypeModel> assignTypeList;
  final AssignTypeModel assignTypeData;
  final List<DepartmentModel> departmentList;
  final DepartmentModel departmentData;
  final List<SapCodeModel> sapCodeList;
  final SapCodeModel sapCodeData;
  final int selectTabIndex;
  final DateTime startDate;
  final DateTime endDate;
  final List<int> complaintCount;
  final TextEditingController plannerGroupController;
  final TextEditingController mainWorkCenterController;
  final TextEditingController personResponsibleController;
  final List<PlannerModel> plannerList;
  final PlannerModel plannerData;
  final List<WorkCenterModel> workCenterList;
  final WorkCenterModel workCenterData;
  final List<ComplaintMarketModel> listOfComplaintData;

  FetchAcknowledgeMarketDataState({
    required this.acknowledgeList,
    required this.isLoader,
    required this.acknowledgeUserList,
    required this.isUserLoader,
    required this.acknowledgeUserData,
    required this.remarkController,
    required this.vendorList,
    required this.vendorData,
    required this.assignTypeList,
    required this.assignTypeData,
    required this.departmentData,
    required this.departmentList,
    required this.sapCodeData,
    required this.sapCodeList,
    required this.selectTabIndex,
    required this.startDate,
    required this.endDate,
    required this.complaintCount,
    required this.closeDateController,
    required this.closedTimeController,
    required this.personResponsibleController,
    required this.mainWorkCenterController,
    required this.plannerGroupController,
    required this.workCenterList,
    required this.workCenterData,
    required this.plannerData,
    required this.plannerList,
    required this.listOfComplaintData,
  });

  @override
  List<Object> get props => [
    closeDateController,
    closedTimeController,
    acknowledgeList,
    isLoader,
    acknowledgeUserList,
    isUserLoader,
    acknowledgeUserData,
    remarkController,
    vendorList,
    vendorData,
    assignTypeList,
    assignTypeData,
    departmentData,
    departmentList,
    sapCodeData,
    sapCodeList,
    selectTabIndex,
    startDate,
    endDate,
    complaintCount,
    personResponsibleController,
    mainWorkCenterController,
    plannerGroupController,
    workCenterList,
    workCenterData,
    plannerData,
    plannerList,
    listOfComplaintData,
  ];
}
