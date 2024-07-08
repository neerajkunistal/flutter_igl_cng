import 'package:flutter/material.dart';
import 'package:flutter_igl_cng/utils/commonClass/singleton.dart';
import 'package:flutter_igl_cng/utils/res/environment_config.dart';

class APIs {
  static BuildContext? context = Singleton.instance.context;

  static final String baseUrl =
      EnvironmentConfig.of(context!)!.generalUrlBaseOnFlavour;

  static get sendNotificationApi => "https://fcm.googleapis.com/fcm/send";

  static get login => "api/auth";

  static get getComplaintTypeApi => "api/onm/complaint-types";

  static get getEquipmentApi => "api/onm/equipments";

  static get addComplaintApi => "api/cng/complaint";

  static get getDepartmentApi => "api/cr/departments";

  static get getComplaintApi => "api/cr/complaint";

  static get getAcknolegeApi => "api/cr/acknowledge";

  static get getReviewComplaintApi => "api/cng/review-complaints";

  static get addReviewComplaintApi => "api/cr/review-complaints";

  static get getMiComplaintApi => "api/cr/mi-complaint";

  static get getSparesApi => "api/cr/spares";

  static get addMiComplaintApi => "api/cr/mi-complaint";

  static get getAssignUserApi => "api/onm/assign-users";

  static get addAcknowlegeApi => "api/cr/se-ack-complaints";

  static get getGeneralComplaintApi => "api/cr/general-complain";

  static get getUomApi => "api/onm/uom";

  static get getVendorApi => "api/onm/vendors";

  static get assignComplaintApi => "api/cr/shift-eng-complaint";

  static get getFirebaseDeviceApi => "api/onm/device-lists";

  static get getSapCodeApi => "api/cr/sap-codes";

  static get getReviewSelfComplaintApi => "api/cr/reviewed-self";

  static get getCivilCategoryApi => "api/onm/civil-categories";

  static get getCrStationApi => "api/cng/cr-station";

  static get addCivilComplaintApi => "api/cng/civil-complaints";

  static get getVendorListApi => "api/cr/vendors";

  static get assignVendorApi => "api/cr/civil-assign";

  static get civilComplaintApproveApi => "api/cr/civil-approve";

  static get estimateComplaintApproveApi => "api/cr/estimate";

  static get civilFinalComplaintApproveApi => "api/cr/final-status";

  static get addEstimateApi => "api/cv/estimate";


  static get forgotPasswordApi => "";
}
