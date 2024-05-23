part of 'mi_complaint_bloc.dart';

abstract class MiComplaintEvent extends Equatable {
  const MiComplaintEvent();
}

class MiComplaintPageLoadEvent extends MiComplaintEvent {
  final BuildContext context;
  final ReviewComplaintModel reviewComplaintData;

  const MiComplaintPageLoadEvent(
      {required this.context, required this.reviewComplaintData});

  @override
  List<Object?> get props => [context, reviewComplaintData];
}

class MiComplaintSelectComplaintData extends MiComplaintEvent {
  final ReviewComplaintModel reviewComplaintData;

  const MiComplaintSelectComplaintData({required this.reviewComplaintData});

  @override
  List<Object?> get props => [reviewComplaintData];
}

class MiComplaintSelectVendorData extends MiComplaintEvent {
  final VendorModel vendorData;

  const MiComplaintSelectVendorData({required this.vendorData});

  @override
  List<Object?> get props => [vendorData];
}

class MiComplaintSelectSpareData extends MiComplaintEvent {
  final SparesModel sparesData;
  final int index;

  const MiComplaintSelectSpareData(
      {required this.sparesData, required this.index});

  @override
  List<Object?> get props => [sparesData, index];
}

class MiComplaintSelectApprovalData extends MiComplaintEvent {
  final String approvalValue;

  const MiComplaintSelectApprovalData({required this.approvalValue});

  @override
  List<Object?> get props => [approvalValue];
}

class MiComplaintSelectActionData extends MiComplaintEvent {
  final ActionModel actionData;
  final BuildContext context;

  const MiComplaintSelectActionData(
      {required this.actionData, required this.context});

  @override
  List<Object?> get props => [actionData, context];
}

class MiComplaintSelectUomData extends MiComplaintEvent {
  final UomTypeModel uomTypeData;
  final int index;

  const MiComplaintSelectUomData(
      {required this.uomTypeData, required this.index});

  @override
  List<Object?> get props => [uomTypeData, index];
}

class MiComplaintAddImageEvent extends MiComplaintEvent {
  final BuildContext context;
  final int mediaType;

  const MiComplaintAddImageEvent(
      {required this.context, required this.mediaType});

  @override
  List<Object?> get props => [context, mediaType];
}

class MiComplaintSelectTimeData extends MiComplaintEvent {
  final BuildContext context;

  const MiComplaintSelectTimeData({required this.context});

  @override
  List<Object?> get props => [context];
}

class MiComplaintSelectDateData extends MiComplaintEvent {
  final BuildContext context;

  const MiComplaintSelectDateData({required this.context});

  @override
  List<Object?> get props => [context];
}

class MiComplaintAddSparesPartData extends MiComplaintEvent {
  final BuildContext context;

  const MiComplaintAddSparesPartData({required this.context});

  @override
  List<Object?> get props => [context];
}

class MiComplaintDeleteSparesPartData extends MiComplaintEvent {
  final int index;

  const MiComplaintDeleteSparesPartData({required this.index});

  @override
  List<Object?> get props => [index];
}

class MiComplaintSubmitData extends MiComplaintEvent {
  final BuildContext context;

  const MiComplaintSubmitData({required this.context});

  @override
  List<Object?> get props => [context];
}
