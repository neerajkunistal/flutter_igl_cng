part of 'view_assignment_bloc.dart';

abstract class ViewAssignmentState extends Equatable {
  const ViewAssignmentState();
}

class ViewAssignmentInitial extends ViewAssignmentState {
  @override
  List<Object> get props => [];
}

class ViewAssignmentPageLoadState extends ViewAssignmentInitial {
  @override
  List<Object> get props => [];
}

class FetchViewAssignmentDataState extends ViewAssignmentInitial {
  final List<AssignmentModel> assignmentList;
  final List<AssignmentChangeStatusModel> assignmentChangeStatusList;
  final AssignmentChangeStatusModel assignmentChangeStatusData;
  final bool isLoader;
  final TextEditingController remarkController;
  final TextEditingController fromDateTextFieldController;
  final TextEditingController toDateTextFieldController;
  final List<DriverModel> lcvDriverList;
  final DriverModel lcvDriverData;
  final bool isDriverList;

  FetchViewAssignmentDataState({
    required this.assignmentList,
    required this.assignmentChangeStatusList,
    required this.assignmentChangeStatusData,
    required this.isLoader,
    required this.remarkController,
    required this.fromDateTextFieldController,
    required this.toDateTextFieldController,
    required this.lcvDriverList,
    required this.lcvDriverData,
    required this.isDriverList,
  });

  @override
  List<Object> get props => [
        assignmentList,
        assignmentChangeStatusList,
        assignmentChangeStatusData,
        isLoader,
        remarkController,
        fromDateTextFieldController,
        toDateTextFieldController,
        lcvDriverList,
        lcvDriverData,
        isDriverList,
      ];
}
