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
  final bool isLoader;
  final File file;

  FetchAddEquipmentComplaintState({
   required this.file,
   required this.isLoader,
   required this.descriptionController,
   required this.complaintTypeData,
   required this.complaintTypeList,
   required this.equipmentTypeData,
   required this.equipmentTypeList,
   required this.reportByController,
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
    reportByController,
  ];
}