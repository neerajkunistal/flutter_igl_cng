import 'package:flutter_igl_cng/ExportFile/app_export_file.dart';
import 'package:flutter_igl_cng/utils/commonClass/user_info.dart';

class ComplaintFilterHelper {

  static List<ReviewComplaintModel> newFilter({required List<ReviewComplaintModel> complaintList})  {
    List<ReviewComplaintModel> list = [];
    try{
      LoginDataModel userData =  UserInfo.instance!.userData!;
      list = complaintList
          .where((element) => userData.roleType == RoleType.stationUser || userData.roleType == RoleType.stationUserManager
          ? element.ackStatus.toString() == "0" && element.complaintStatus.toString() == "0"
          : element.assignType.toString() == "2" &&
          element.miAssignType.toString() == "0" &&
          element.complaintStatus.toString() == "0")
          .toList();
    }catch(_){}
    return list;
  }

  static List<ReviewComplaintModel> miFilter({required List<ReviewComplaintModel> complaintList})  {
    List<ReviewComplaintModel> list = [];
    try{
      LoginDataModel userData =  UserInfo.instance!.userData!;
      list = complaintList
          .where((element) =>
      element.assignType.toString() == "2" &&
          element.miAssignType.toString() == "0" &&
          element.complaintStatus.toString() == "0")
          .toList();
      if(userData.roleType == RoleType.shiftEngineer){
        List<ReviewComplaintModel> shiftEngineerFilterData = list
            .where((element) => element.stationStatus.toString() != "1")
            .toList();
        list = [];
        list.addAll(shiftEngineerFilterData);
      }
    }catch(_){}
    return list;
  }

  static List<ReviewComplaintModel> completeFilter({required List<ReviewComplaintModel> complaintList})  {
    List<ReviewComplaintModel> list = [];
    try{
      LoginDataModel userData =  UserInfo.instance!.userData!;
      list = complaintList
          .where((element) => element.complaintStatus.toString() == "1")
          .toList();
    }catch(_){}
    return list;
  }

  static List<ReviewComplaintModel> ackFilter({required List<ReviewComplaintModel> complaintList})  {
    List<ReviewComplaintModel> list = [];
    try{
      LoginDataModel userData =  UserInfo.instance!.userData!;
      list = complaintList
          .where((element) =>
      (element.complaintStatus.toString() == "0" ||
          element.complaintStatus.toString() == "3") &&
          element.ackStatus.toString() != "0")
          .toList();
    }catch(_){}
    return list;
  }

  static List<ReviewComplaintModel> closerFilter({required List<ReviewComplaintModel> complaintList})  {
    List<ReviewComplaintModel> list = [];
    try{
      LoginDataModel userData =  UserInfo.instance!.userData!;
      list = complaintList.where((element) => element.assignType.toString() != "1"
          && element.ackStatus.toString() !=  "0"
          && element.stationStatus.toString() != "0" && element.complaintStatus.toString() != "1").toList();
    }catch(_){}
    return list;
  }

  static List<ReviewComplaintModel> selfFilter({required List<ReviewComplaintModel> complaintList})  {
    List<ReviewComplaintModel> list = [];
    try{
      LoginDataModel userData =  UserInfo.instance!.userData!;
      list = complaintList.where((element) => element.assignType.toString() == "1"
          && element.complaintStatus.toString() != "1").toList();
    }catch(_){}
    return list;
  }

  static List<ReviewComplaintModel> vendorFilter({required List<ReviewComplaintModel> complaintList})  {
    List<ReviewComplaintModel> list = [];
    try{
      LoginDataModel userData =  UserInfo.instance!.userData!;
      list = complaintList
          .where((element) =>
      element.miAssignType.toString() == "3" &&
          element.assignType.toString() == "2" &&
          element.complaintStatus.toString() == "0" )
          .toList();
      list.addAll(complaintList
          .where((element) =>
      element.miAssignType.toString() == "0" &&
          element.assignType.toString() == "3" &&
          element.complaintStatus.toString() == "0")
          .toList());
      list.addAll(complaintList
          .where((element) =>
      element.miAssignType.toString() == "3" &&
          element.assignType.toString() == "3" &&
          element.complaintStatus.toString() == "0" )
          .toList());
      if(userData.roleType == RoleType.shiftEngineer){
        List<ReviewComplaintModel> shiftEngineerFilterData = list
            .where((element) => element.stationStatus.toString() != "1")
            .toList();
        list = [];
        list.addAll(shiftEngineerFilterData);
      }
    }catch(_){}
    return list;
  }
}