import 'package:flutter/material.dart';
import 'package:flutter_igl_cng/utils/commonClass/singleton.dart';
import 'package:flutter_igl_cng/utils/res/environment_config.dart';

class APIs {
  static BuildContext? context = Singleton.instance.context;

  static final String baseUrl =
      EnvironmentConfig.of(context!)!.generalUrlBaseOnFlavour;

  static get sendNotificationApi => "https://fcm.googleapis.com/fcm/send";

  static get googlePlaceAPI =>
      "https://maps.googleapis.com/maps/api/place/autocomplete/json?";

  static get googlePlaceDetailsAPI =>
      "https://maps.googleapis.com/maps/api/place/details/json?";

  static get googleLatLongAPI =>
      "https://maps.googleapis.com/maps/api/geocode/json?";

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

  static get addCivilVendorComplaintApi => "api/cv/civil-complaints";

  static get getCivilApproveApi => "api/cr/civil-approve";

  static get getVendorListApi => "api/cr/vendors";

  static get assignVendorApi => "api/cr/civil-assign";

  static get civilComplaintApproveApi => "api/cr/civil-approve";

  static get estimateComplaintApproveApi => "api/cr/estimate";

  static get civilFinalComplaintApproveApi => "api/cr/final-status";

  static get addEstimateApi => "api/cv/estimate";

  static get addMeasurementApi => "api/cv/measurement";

  static get closureComplaintApi => "api/cng/closure";

  static get getUnitTypeApi => "api/onm/unit-type";

  static get getCNGStationListApi => "api/onm/cng-stations";

  static get getControlRoomDataForCiApi => "api/cr/assigned-control-room?";

  static get civilCloserComplaintApi => "api/cr/closure";

  static get registrationApi => "api/saveLCVDriver";

  static get getDriverApi => "api/lcv/getDriver";

  static get getLCVDetailApi => "api/lcv/getLcvDetails";

  static get getCNFStationApi => "api/lcv/getCngStation";

  static get addAssignmentApi => "api/saveAssignment";

  static get updateAssignmentStatus => "api/updateStatus";

  static get getAssignmentApi => "api/getAssignment";

  static get getUserRolesApi => "api/getUserRole";

  static get cngStationRegistrationApi => "api/saveCngStation";

  static get addLcvTruckApi => "api/saveLcv";

  static get addCngStationUser => "api/saveCngUser";

  static get getUserApi => "api/getUsers";

  static get insertLiveLocationApi => "api/insert_location";

  static get updateScmApi => "api/updateScm";

  static get getLocationApi => "api/getLocation";

  static get getCngScmInfoApi => "api/getCngScmInfo";

  static get addCngScmInfoApi => "api/addCngScmInfo";

  static get getRouteApi => "api/getRoute";

  static get getMotherStationsApi => "api/lcv/getMBStation";

  static get getDBStationApi => "api/lcv/getDBStation";

  static get deleteCngUserApi => "api/delete_user";

  static get deleteCngStationTruckApi => "api/delete_lcv";

  static get getIglApi => "api/cr/getExtApiURl";

  static get forgotPasswordApi => "";
}
