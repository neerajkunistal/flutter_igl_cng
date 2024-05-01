import 'package:flutter/material.dart';
import 'package:flutter_igl_cng/utils/commonClass/singleton.dart';
import 'package:flutter_igl_cng/utils/res/environment_config.dart';

class APIs {


  static BuildContext? context =  Singleton.instanceInit()?.context;

  static final String baseUrl =
      EnvironmentConfig.of(context!)!.generalUrlBaseOnFlavour;

  static get login => "api/auth";
  static get getComplaintTypeApi => "api/onm/complaint-types";
  static get getEquipmentApi => "api/onm/equipments";
  static get addComplaintApi => "api/cng/complaint";
  static get getDepartmentApi => "api/cr/departments";
  static get getComplaintApi => "api/cr/complaint";
  static get getAcknolegeApi => "api/cr/acknowledge";
  static get addCivilComplaintApi => "api/cr/shift-eng-complaint";
  static get getReviewComplaintApi => "api/cr/review-complaints";
  static get addReviewComplaintApi => "api/cr/review-complaints";
  static get getMiComplaintApi => "api/cr/mi-complaint";
  static get getSparesApi => "api/cr/spares";
  static get addMiComplaintApi => "api/cr/mi-complaint";
  static get getAssignUserApi => "api/onm/assign-users";
  static get addAcknowlegeApi => "api/cr/si-ack-complaints";
  static get getUomApi => "api/onm/uom";
  static get forgotPasswordApi => "";
}