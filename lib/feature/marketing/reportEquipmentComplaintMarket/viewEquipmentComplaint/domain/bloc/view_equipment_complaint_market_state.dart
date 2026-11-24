part of 'view_equipment_complaint_market_bloc.dart';

abstract class ViewEquipmentComplaintMarketState extends Equatable {
  const ViewEquipmentComplaintMarketState();
}

class ViewEquipmentComplaintMarketInitial extends ViewEquipmentComplaintMarketState {
  @override
  List<Object> get props => [];
}

class ViewEquipmentComplaintMarketPageLoadState
    extends ViewEquipmentComplaintMarketInitial {
  @override
  List<Object> get props => [];
}

class FetchViewEquipmentComplaintMarketDataState extends ViewEquipmentComplaintMarketState {
  final List<ReviewComplaintModel> reviewComplaintList;
  final int selectedTabIndex;
  final DateTime startDate;
  final DateTime endDate;
  final List<int> complaintCount;
  final bool isLoader;
  final TextEditingController remarkController;
  final int index;
  final ReviewComplaintModel reviewComplaintData;
  final TextEditingController dateController;
  final TextEditingController timeController;
  final TextEditingController rectifyByController;
  final List<ComplaintMarketModel> listOfComplaintData;

  const FetchViewEquipmentComplaintMarketDataState({
    required this.reviewComplaintList,
    required this.selectedTabIndex,
    required this.endDate,
    required this.startDate,
    required this.complaintCount,
    required this.isLoader,
    required this.remarkController,
    required this.index,
    required this.reviewComplaintData,
    required this.rectifyByController,
    required this.dateController,
    required this.timeController,
    required this.listOfComplaintData,
  });

  @override
  List<Object> get props => [
    reviewComplaintList,
    selectedTabIndex,
    endDate,
    startDate,
    complaintCount,
    isLoader,
    remarkController,
    index,
    rectifyByController,
    dateController,
    timeController,
    listOfComplaintData,
  ];
}
