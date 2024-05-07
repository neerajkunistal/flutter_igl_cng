import 'package:flutter/cupertino.dart';
import 'package:flutter_igl_cng/ExportFile/app_export_file.dart';
import 'package:flutter_igl_cng/feature/login/domain/models/login_model.dart';
import 'package:flutter_igl_cng/feature/miComplaint/helper/mi_complaint_helper.dart';
import 'package:flutter_igl_cng/utils/commonClass/user_info.dart';

part 'view_equipment_complaint_event.dart';
part 'view_equipment_complaint_state.dart';

class ViewEquipmentComplaintBloc extends Bloc<ViewEquipmentComplaintEvent, ViewEquipmentComplaintState> {

  List<ReviewComplaintModel> reviewComplaintList = [];

  ViewEquipmentComplaintBloc() : super(ViewEquipmentComplaintInitial()) {
    on<ViewEquipmentComplaintPageLoadEvent>(_pageLoad);
  }

  _pageLoad(ViewEquipmentComplaintPageLoadEvent event, emit) async {
    emit(ViewEquipmentComplaintPageLoadState());
    reviewComplaintList = [];
    LoginDataModel userData =  UserInfo.instanceInit()!.userData!;
    var res =   userData.roleType == RoleType.mi
        ? await MiComplaintHelper.fetchMiComplaint()
        : await ReviewComplaintHelper.fetchReviewComplaint(type: userData.roleType == RoleType.shiftEngineer ? "0" :  "1");

    if(res != null){
      reviewComplaintList = res;
    }
    _eventComplete(emit);
  }

  _eventComplete(Emitter<ViewEquipmentComplaintState>emit) {
    emit(FetchViewEquipmentComplaintDataState(reviewComplaintList: reviewComplaintList));
  }
}
