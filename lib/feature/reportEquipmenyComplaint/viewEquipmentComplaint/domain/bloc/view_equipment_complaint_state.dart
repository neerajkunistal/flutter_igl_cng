part of 'view_equipment_complaint_bloc.dart';

abstract class ViewEquipmentComplaintState extends Equatable {
  const ViewEquipmentComplaintState();
}

class ViewEquipmentComplaintInitial extends ViewEquipmentComplaintState {
  @override
  List<Object> get props => [];
}

class ViewEquipmentComplaintPageLoadState
    extends ViewEquipmentComplaintInitial {
  @override
  List<Object> get props => [];
}

class FetchViewEquipmentComplaintDataState extends ViewEquipmentComplaintState {
  final List<ReviewComplaintModel> reviewComplaintList;
  final int selectedTabIndex;
  final DateTime startDate;
  final DateTime endDate;
  final List<int> complaintCount;

  const FetchViewEquipmentComplaintDataState(
      {required this.reviewComplaintList,
       required this.selectedTabIndex,
       required this.endDate,
       required this.startDate,
       required this.complaintCount,
      });

  @override
  List<Object> get props => [
    reviewComplaintList,
    selectedTabIndex,
    endDate,
    startDate,
    complaintCount,
  ];
}
