import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_igl_cng/ExportFile/app_export_file.dart';
import 'package:flutter_igl_cng/feature/dashboard/domain/model/file_model.dart';
import 'package:flutter_igl_cng/feature/marketing/addAcknowledgeMarket/addAcknowledgeMarketComplaint/domain/model/vendor_model.dart';
import 'package:flutter_igl_cng/feature/reportEquipmenyComplaint/addEquipmentComplaint/domain/model/category_model.dart';
import 'package:flutter_igl_cng/feature/reportEquipmenyComplaint/addEquipmentComplaint/domain/model/complaint_description_model.dart';
import 'package:flutter_igl_cng/feature/reportEquipmenyComplaint/addEquipmentComplaint/domain/model/equipment_model.dart';
import 'package:flutter_igl_cng/feature/reportEquipmenyComplaint/addEquipmentComplaint/domain/model/facility_model.dart';
import 'package:flutter_igl_cng/feature/reportEquipmenyComplaint/addEquipmentComplaint/domain/model/sub_category_model.dart';
import 'package:flutter_igl_cng/services/firebase/notification_helper.dart';
import 'package:flutter_igl_cng/services/firebase/page_id.dart';
import 'package:flutter_igl_cng/utils/commonClass/user_info.dart';

class AddEquipmentComplaintMarkerHelper {
  static Future<dynamic> textFieldValidation(
      {required BuildContext context,
      required ComplaintTypeModel complaintTypeData,
      required EquipmentTypeModel equipmentTypeData,
      required String description,
      required String name,
      required List<File> file,
      required List<File> videoFiles,
      required String date,
      required String time,
      required String generalDescription,
      required GeneralComplaintModel generalComplaintData,
      required ComplaintDescriptionModel complaintDescriptionData,
      required EquipmentComplaintType equipmentComplaintType,
      re}) async {
    try {
      if (complaintTypeData.id == null) {
        SnackBarErrorWidget(context)
            .show(message: "Please select complaint type");
        return false;
      } else if (complaintTypeData.id.toString() == "2" &&
          equipmentTypeData.id == null) {
        SnackBarErrorWidget(context).show(message: "Please select equipment");
        return false;
      } else if (complaintTypeData.id.toString() == "1" &&
          generalComplaintData.id == null) {
        SnackBarErrorWidget(context).show(message: "Please select general");
        return false;
      } else if (time.isEmpty) {
        SnackBarErrorWidget(context).show(message: "Please enter time");
        return false;
      } else if (complaintDescriptionData.description == null &&
          equipmentComplaintType == EquipmentComplaintType.it) {
        SnackBarErrorWidget(context).show(message: "Please select description");
        return false;
      } else if (name.isEmpty) {
        SnackBarErrorWidget(context)
            .show(message: "Please enter reported by name");
        return false;
      }
      return true;
    } catch (_) {}
    return false;
  }

  static Future<dynamic> fetchComplaintTypeData({required EquipmentComplaintType equipmentComplaintType}) async {
    try {
      String url =  APIs.getComplaintMarketingTypeApi;
      var res = await ServerRequest.getData(urlEndPoint: url);
      if (res != null && res['status'] != null && res["status"] == true) {
        return complaintTypeListResponse(res['data']);
      }
      return null;
    } catch (e) {
      if (kDebugMode) {
        print("fetch complaint type data : - ---- ${e.toString()}");
      }
      return null;
    }
  }

  static Future<dynamic> fetchVendorTypeData() async {
    try {
      String url =  APIs.vendorListsApi;
      var res = await ServerRequest.getData(urlEndPoint: url);
      if (res != null && res['status'] != null && res["status"] == true) {
        return vendorMarketListResponse(res['data']);
      }
      return null;
    } catch (e) {
      if (kDebugMode) {
        print("fetch Vendor Type Data : - ---- ${e.toString()}");
      }
      return null;
    }
  }

  static Future<dynamic> fetchEquipmentTypeData(
      {String? complaintId,
      required EquipmentComplaintType equipmentComplaintType}) async {
    try {
      String url = equipmentComplaintType == EquipmentComplaintType.normal
          ? APIs.getEquipmentApi + "/$complaintId"
          : APIs.getEquipmentITApi;
      var res = await ServerRequest.getData(urlEndPoint: url);
      if (res != null &&
          res['status'] != null &&
          res["status"] == true &&
          res['EqpRecord'] != null) {
        List<EquipmentModel> equipmentList =
            equipmentListResponse(res['EqpRecord']);

        if (res['data'] != null) {
          List<EquipmentTypeModel> equipmentTypeList =
              equipmentTypeListResponse(res['data']);
          for (var equipmentData in equipmentList) {
            equipmentData.equipmentTypeList!.addAll(equipmentTypeList);
          }
        }

        return equipmentList;
      }
      return null;
    } catch (e) {
      if (kDebugMode) {
        print("fetch equipment type data : - ---- ${e.toString()}");
      }
      return null;
    }
  }

  static Future<dynamic> fetchGeneralComplaintData() async {
    try {
      String url = APIs.getGeneralComplaintApi;
      var res = await ServerRequest.getData(urlEndPoint: url);
      if (res != null && res['status'] != null && res["status"] == true) {
        return generalComplaintListResponse(res['data']);
      }
      return null;
    } catch (e) {
      if (kDebugMode) {
        print("fetch general complaint type data : - ---- ${e.toString()}");
      }
      return null;
    }
  }

  static Future<dynamic> fetchDescriptionComplaintData() async {
    try {
      String url = APIs.getDescriptionComplaintApi;
      var res = await ServerRequest.getData(urlEndPoint: url);
      if (res != null && res['status'] != null && res["status"] == true) {
        return complaintDescriptionList(res['data']);
      }
      return null;
    } catch (e) {
      if (kDebugMode) {
        print("fetch general complaint type data : - ---- ${e.toString()}");
      }
      return null;
    }
  }

  static Future<dynamic> fetchFacilityData() async {
    try {
      String url = APIs.facilityListApi;
      var res = await ServerRequest.getData(urlEndPoint: url);
      if (res != null && res['status'] != null && res["status"] == true) {
        return facilityTypeListResponse(res['data']);
      }
      return null;
    } catch (e) {
      if (kDebugMode) {
        print("fetch Facility Data : - ---- ${e.toString()}");
      }
      return null;
    }
  }

  static Future<dynamic> fetchCategoryData({required String facilityId}) async {
    try {
      String url = "${APIs.categoryListApi}?facilityId=$facilityId";
      var res = await ServerRequest.getData(urlEndPoint: url);
      if (res != null && res['status'] != null && res["status"] == true) {
        return marketCategoryTypeListResponse(res['data']);
      }
      return null;
    } catch (e) {
      if (kDebugMode) {
        print("fetch Category Data : - ---- ${e.toString()}");
      }
      return null;
    }
  }
  static Future<dynamic> fetchSubCategoryData({required String categoryId}) async {
    try {
      String url = "${APIs.subcategoryListApi}?categoryId=$categoryId";
      var res = await ServerRequest.getData(urlEndPoint: url);
      if (res != null && res['status'] != null && res["status"] == true) {
        return subCategoryTypeListResponse(res['data']);
      }
      return null;
    } catch (e) {
      if (kDebugMode) {
        print("fetch Sub Category Data : - ---- ${e.toString()}");
      }
      return null;
    }
  }

  static Future<dynamic> submitData({
    required BuildContext context,
    required ComplaintTypeModel complaintTypeData,
    required EquipmentTypeModel equipmentTypeData,
    required String description,
    required String name,
    required List<File> file,
    required List<File> videoFiles,
    required String date,
    required String time,
    required String generalDescription,
    required GeneralComplaintModel generalComplaintData,
    required ComplaintDescriptionModel complaintDescriptionData,
    required EquipmentComplaintType equipmentComplaintType,
  }) async {
    try {
      LoginDataModel userData = UserInfo.instanceInit()!.userData!;
      String url = equipmentComplaintType == EquipmentComplaintType.normal
          ? APIs.addComplaintApi
          : APIs.addComplaintITApi;

      var json = {
        "complaintTypeId": complaintTypeData.id != null
            ? complaintTypeData.id.toString()
            : "0",
        "equipmentId": equipmentTypeData.id != null
            ? equipmentTypeData.id.toString()
            : "0",
        "description": equipmentComplaintType == EquipmentComplaintType.normal
            ? description
            : complaintDescriptionData.id.toString(),
        "reportBy": name,
        "complaintDateTime": "$date $time",
        "generalComplaintDesc": generalDescription,
        "generalComplaintId": generalComplaintData.id != null
            ? generalComplaintData.id.toString()
            : "0",
      };

      List<FileModel> fileList = [];
      int i = 0;
      for (var fileData in file) {
        if (fileData.path.isNotEmpty) {
          print(fileData.path.toString());
          fileList.add(FileModel(
              name: "file", file: fileData, keyName: "attachFile[$i]"));
          i++;
        }
      }

      for (var fileData in videoFiles) {
        if (fileData.path.isNotEmpty) {
          fileList.add(
              FileModel(name: "file", file: fileData, keyName: "videoFile"));
        }
      }
      if (!context.mounted) return null;
      var res = await ServerRequest.postDataWithFile(
          urlEndPoint: url, body: json, fileList: fileList, context: context);
      if (res != null &&
          res['status'] != null &&
          res['status'] == true &&
          res['message'] != null) {
        NotificationHelper.sendNotification(
            firebaseDeviceList:
                BlocProvider.of<HomeBloc>(!context.mounted ? context : context)
                    .firebaseDeviceList,
            title: "Complain new ${userData.stationName}",
            body: description,
            pageId: PageId.addComplaint,
            complaintId: "",
            dateTime: DateTime.now().toString());
        if (!context.mounted) return res;
        SnackBarSuccessWidget(context).show(message: res['message'].toString());
        return res;
      } else if (res != null &&
          res['status'] != null &&
          res['status'] == false &&
          res['error'] != null) {
        if (!context.mounted) return null;
        SnackBarErrorWidget(context).show(message: res['error'].toString());
        return null;
      } else if (res != null &&
          res['status'] != null &&
          res['status'] == false &&
          res['errors'] != null) {
        String response = res['errors'].toString();
        if (!context.mounted) return null;
        SnackBarErrorWidget(context).show(
            message:
                response.replaceAll("[{", "").toString().replaceAll("}]", ""));
        return null;
      } else {
        if (!context.mounted) return null;
        SnackBarErrorWidget(context).show(message: "Internal Server Error");
        return null;
      }
    } catch (e) {
      if (kDebugMode) {
        print("submit complaint data : - ---- ${e.toString()}");
      }
      return null;
    }
  }
  static Future<bool> marketingValidation({
    required BuildContext context,
    required FacilityModel facilityData,
    required String facilityOtherDescription,
    required MarketCategoryModel categoryData,
    required SubCategoryModel subCategoryData,
    required String description,
    required String complainantName,
    required String complainantMobile,
  }) async {
    try {
      final isOther = facilityData.name?.toString().toLowerCase() == "others";

      if (facilityData.id == null) {
        SnackBarErrorWidget(context).show(message: "Please select facility");
        return false;
      } else if (isOther && facilityOtherDescription.trim().isEmpty) {
        SnackBarErrorWidget(context).show(message: "Please enter facility description");
        return false;
      } else if (!isOther && categoryData.id == null) {
        SnackBarErrorWidget(context).show(message: "Please select category");
        return false;
      } else if (description.trim().isEmpty) {
        SnackBarErrorWidget(context).show(message: "Please enter description");
        return false;
      } else if (complainantName.trim().isEmpty) {
        SnackBarErrorWidget(context).show(message: "Please enter name");
        return false;
      } else if (complainantMobile.trim().length != 10) {
        SnackBarErrorWidget(context).show(message: "Please enter valid 10-digit mobile");
        return false;
      }
      return true;
    } catch (_) {}
    return false;
  }
  static Future<dynamic> marketingSubmitData({
    required BuildContext context,
    required FacilityModel facilityData,
    required String facilityOtherDescription,
    required MarketCategoryModel categoryData,
    required SubCategoryModel subCategoryData,
    required String description,
    required String complainantName,
    required String complainantMobile,
    required List<File> file,
    required List<File> videoFiles,
  }) async {
try {
    LoginDataModel userData = UserInfo.instanceInit()!.userData!;
    String url = APIs.marketingSubmitComplainApi;

    var json = {
      "facilityId": facilityData.id != null ? facilityData.id.toString() : "0",
      "facilityOtherDescription": facilityOtherDescription,
      "categoryId": categoryData.id != null ? categoryData.id.toString() : "0",
      "subCategoryId": subCategoryData.id != null ? subCategoryData.id.toString() : "0",
      "description": description,
      "complainantName": complainantName,
      "complainantMobile": complainantMobile,
      "stationId": userData.stationId!.isEmpty ? "0" : userData.stationId.toString(),
      "controlRoomId": "0",
    };

      List<FileModel> fileList = [];
      int i = 0;
      for (var fileData in file) {
        if (fileData.path.isNotEmpty) {
          print(fileData.path.toString());
          fileList.add(FileModel(
              name: "file", file: fileData, keyName: "attachFile[$i]"));
          i++;
        }
      }

      for (var fileData in videoFiles) {
        if (fileData.path.isNotEmpty) {
          fileList.add(
              FileModel(name: "file", file: fileData, keyName: "videoFile"));
        }
      }
      if (!context.mounted) return null;
      var res = await ServerRequest.postDataWithFile(
          urlEndPoint: url, body: json, fileList: fileList, context: context);
      if (res != null &&
          res['status'] != null &&
          res['status'] == true &&
          res['message'] != null) {
        NotificationHelper.sendNotification(
            firebaseDeviceList:
            BlocProvider.of<HomeBloc>(!context.mounted ? context : context)
                .firebaseDeviceList,
            title: "Complain new ${userData.stationName}",
            body: description,
            pageId: PageId.addComplaint,
            complaintId: "",
            dateTime: DateTime.now().toString());
        if (!context.mounted) return res;
        SnackBarSuccessWidget(context).show(message: res['message'].toString());
        return res;
      } else if (res != null &&
          res['status'] != null &&
          res['status'] == false &&
          res['error'] != null) {
        if (!context.mounted) return null;
        SnackBarErrorWidget(context).show(message: res['error'].toString());
        return null;
      } else if (res != null &&
          res['status'] != null &&
          res['status'] == false &&
          res['errors'] != null) {
        String response = res['errors'].toString();
        if (!context.mounted) return null;
        SnackBarErrorWidget(context).show(
            message:
            response.replaceAll("[{", "").toString().replaceAll("}]", ""));
        return null;
      } else {
        if (!context.mounted) return null;
        SnackBarErrorWidget(context).show(message: "Internal Server Error");
        return null;
      }
    } catch (e) {
      if (kDebugMode) {
        print("submit complaint data : - ---- ${e.toString()}");
      }
      return null;
    }
    }

}
