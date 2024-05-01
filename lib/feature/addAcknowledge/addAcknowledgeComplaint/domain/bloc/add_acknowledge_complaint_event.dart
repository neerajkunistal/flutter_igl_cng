
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:flutter_igl_cng/feature/acknowledge/domain/model/acknowledge_model.dart';
import 'package:flutter_igl_cng/feature/addAcknowledge/addAcknowledgeComplaint/domain/model/acknowledge_user_model.dart';
import 'package:flutter_igl_cng/feature/addAcknowledge/addAcknowledgeComplaint/domain/model/complaint_model.dart';
import 'package:flutter_igl_cng/feature/addAcknowledge/addAcknowledgeComplaint/domain/model/department_model.dart';
import 'package:flutter_igl_cng/feature/reportEquipmenyComplaint/addEquipmentComplaint/domain/model/complaint_type_model.dart';
import 'package:flutter_igl_cng/feature/reportEquipmenyComplaint/addEquipmentComplaint/domain/model/equipment_type_model.dart';
import 'package:flutter_igl_cng/feature/reviewComplaint/domain/model/review_complaint_model.dart';

abstract class AddAcknowledgeComplaintEvent extends Equatable {
  const AddAcknowledgeComplaintEvent();
}


class AddAcknowledgeComplaintPageLoadEvent extends AddAcknowledgeComplaintEvent {
  final BuildContext context;
  final AcknowledgeModel acknowledgeData;
  const AddAcknowledgeComplaintPageLoadEvent({required this.context, required this.acknowledgeData});
  @override
  List<Object?> get props => [context, acknowledgeData];
}

class AddAcknowledgeComplaintSelectDataEvent extends AddAcknowledgeComplaintEvent {
  final BuildContext context;
  const AddAcknowledgeComplaintSelectDataEvent({required this.context});
  @override
  List<Object?> get props => [context];
}

class AddAcknowledgeComplaintSelectComplaintDataEvent extends AddAcknowledgeComplaintEvent {
  final ComplaintTypeModel complaintTypeData;
  const AddAcknowledgeComplaintSelectComplaintDataEvent({required this.complaintTypeData});
  @override
  List<Object?> get props => [complaintTypeData];
}

class AddAcknowledgeComplaintSelectEquipmentDataEvent extends AddAcknowledgeComplaintEvent {
  final EquipmentTypeModel equipmentTypeData;
  const AddAcknowledgeComplaintSelectEquipmentDataEvent({required this.equipmentTypeData});
  @override
  List<Object?> get props => [equipmentTypeData];
}

class AddAcknowledgeComplaintSelectComplaintEvent extends AddAcknowledgeComplaintEvent {
  final ComplaintModel complaintData;
  const AddAcknowledgeComplaintSelectComplaintEvent({required this.complaintData});
  @override
  List<Object?> get props => [complaintData];
}

class AddAcknowledgeComplaintSelectReviewComplaintEvent extends AddAcknowledgeComplaintEvent {
  final ReviewComplaintModel reviewComplaintData;
  const AddAcknowledgeComplaintSelectReviewComplaintEvent({required this.reviewComplaintData});
  @override
  List<Object?> get props => [reviewComplaintData];
}

class AddAcknowledgeComplaintSelectDepartmentEvent extends AddAcknowledgeComplaintEvent {
  final DepartmentModel departmentData;
  const AddAcknowledgeComplaintSelectDepartmentEvent({required this.departmentData});
  @override
  List<Object?> get props => [departmentData];
}

class AddAcknowledgeComplaintSelectUserEvent extends AddAcknowledgeComplaintEvent {
  final AcknowledgeUserModel acknowledgeUserData;
  const AddAcknowledgeComplaintSelectUserEvent({required this.acknowledgeUserData});
  @override
  List<Object?> get props => [acknowledgeUserData];
}

class AddAcknowledgeComplaintSelectAcknowledgeComplaintEvent extends AddAcknowledgeComplaintEvent {
  final AcknowledgeModel acknowledgeData;
  const AddAcknowledgeComplaintSelectAcknowledgeComplaintEvent({required this.acknowledgeData});
  @override
  List<Object?> get props => [acknowledgeData];
}

class AddAcknowledgeComplaintSelectBreakDownEvent extends AddAcknowledgeComplaintEvent {
  final String breakeDown;
  const AddAcknowledgeComplaintSelectBreakDownEvent({required this.breakeDown});
  @override
  List<Object?> get props => [breakeDown];
}

class AddAcknowledgeComplaintAddImageEvent extends AddAcknowledgeComplaintEvent {
  final BuildContext context;
  final int mediaType;
  const AddAcknowledgeComplaintAddImageEvent({required this.context, required this.mediaType});
  @override
  List<Object?> get props => [context, mediaType];
}

class AddAcknowledgeComplaintSelectTimeData extends AddAcknowledgeComplaintEvent {
  final BuildContext context;
  const AddAcknowledgeComplaintSelectTimeData({required this.context});
  @override
  List<Object?> get props => [context];
}

class AddAcknowledgeComplaintSelectDateData extends AddAcknowledgeComplaintEvent {
  final BuildContext context;
  const AddAcknowledgeComplaintSelectDateData({required this.context});
  @override
  List<Object?> get props => [context];
}

class AddAcknowledgeComplaintSubmitEvent extends AddAcknowledgeComplaintEvent {
  final BuildContext context;
  const AddAcknowledgeComplaintSubmitEvent({required this.context});
  @override
  List<Object?> get props => [context];
}
