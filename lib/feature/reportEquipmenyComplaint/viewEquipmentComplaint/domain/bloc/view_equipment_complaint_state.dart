part of 'view_equipment_complaint_bloc.dart';

abstract class ViewEquipmentComplaintState extends Equatable {
  const ViewEquipmentComplaintState();
}

class ViewEquipmentComplaintInitial extends ViewEquipmentComplaintState {
  @override
  List<Object> get props => [];
}

class ViewEquipmentComplaintPageLoadState extends ViewEquipmentComplaintInitial {
  @override
  List<Object> get props => [];
}

class FetchViewEquipmentComplaintDataState extends ViewEquipmentComplaintState {
  final List<ReviewComplaintModel> reviewComplaintList;
  FetchViewEquipmentComplaintDataState({required this.reviewComplaintList});

  @override
  List<Object> get props => [reviewComplaintList];
}