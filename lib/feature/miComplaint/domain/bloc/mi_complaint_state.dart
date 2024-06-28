part of 'mi_complaint_bloc.dart';

abstract class MiComplaintState extends Equatable {
  const MiComplaintState();
}

class MiComplaintInitial extends MiComplaintState {
  @override
  List<Object> get props => [];
}

class MiComplaintPageLoadState extends MiComplaintInitial {
  @override
  List<Object> get props => [];
}

class FetchMiComplaintDataState extends MiComplaintInitial {
  final List<ReviewComplaintModel> reviewComplaintList;
  final ReviewComplaintModel reviewComplaintData;
  final List<SparesModel> sparesList;
  final SparesModel sparesData;
  final String approvalValue;
  final String action;
  final TextEditingController observationController;
  final TextEditingController descriptionController;
  final TextEditingController rectifyByController;
  final File file;
  final bool isLoader;
  final List<ActionModel> actionList;
  final ActionModel actionData;
  final TextEditingController dateController;
  final TextEditingController timeController;
  final TextEditingController qtyController;
  final List<UomTypeModel> uomTypeList;
  final UomTypeModel uomTypeData;
  final List<SparesPartModel> sparesPartList;
  final List<VendorModel> vendorList;
  final VendorModel vendorData;

  FetchMiComplaintDataState({
    required this.approvalValue,
    required this.reviewComplaintData,
    required this.reviewComplaintList,
    required this.observationController,
    required this.file,
    required this.descriptionController,
    required this.action,
    required this.sparesData,
    required this.sparesList,
    required this.isLoader,
    required this.actionData,
    required this.actionList,
    required this.timeController,
    required this.dateController,
    required this.uomTypeList,
    required this.uomTypeData,
    required this.qtyController,
    required this.sparesPartList,
    required this.vendorList,
    required this.vendorData,
    required this.rectifyByController,
  });

  @override
  List<Object> get props => [
        approvalValue,
        reviewComplaintData,
        reviewComplaintList,
        observationController,
        file,
        descriptionController,
        action,
        sparesData,
        sparesList,
        isLoader,
        actionData,
        actionList,
        timeController,
        dateController,
        uomTypeList,
        uomTypeData,
        qtyController,
        sparesPartList,
        vendorList,
        vendorData,
        rectifyByController,
      ];
}
