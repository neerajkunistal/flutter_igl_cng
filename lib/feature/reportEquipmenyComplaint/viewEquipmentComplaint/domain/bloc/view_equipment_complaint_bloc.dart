import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_igl_cng/ExportFile/app_export_file.dart';
import 'package:flutter_igl_cng/feature/miComplaint/helper/mi_complaint_helper.dart';
import 'package:flutter_igl_cng/feature/reportEquipmenyComplaint/viewEquipmentComplaint/helper/complaint_filter_helper.dart';
import 'package:flutter_igl_cng/feature/reportEquipmenyComplaint/viewEquipmentComplaint/helper/view_equipment_complaint.dart';
import 'package:flutter_igl_cng/feature/scrap/addScrap/domain/bloc/add_scrap_bloc.dart';
import 'package:flutter_igl_cng/feature/sparePart/addSparePart/domain/bloc/add_spare_part_bloc.dart';
import 'package:flutter_igl_cng/utils/commonClass/user_info.dart';
import 'package:vibration/vibration.dart';

part 'view_equipment_complaint_event.dart';
part 'view_equipment_complaint_state.dart';

class ViewEquipmentComplaintBloc
    extends Bloc<ViewEquipmentComplaintEvent, ViewEquipmentComplaintState> {
  List<ReviewComplaintModel> reviewComplaintList = [];
  List<ReviewComplaintModel> reviewComplaintWithOutFilterList = [];

  List<ReviewComplaintModel> reviewSelfComplaintList = [];
  List<ReviewComplaintModel> reviewSelfComplaintWithOutFilterList = [];

  int _selectTabIndex = 0;

  int get selectTabIndex => _selectTabIndex;

  LoginDataModel userData = LoginDataModel();

  DateTime startDate = DateTime.now();
  DateTime endDate = DateTime.now();

  List<int> complaintCount = [];

  bool isLoader =  false;

  ReviewComplaintModel reviewComplaintData =  ReviewComplaintModel();
  int index = 0;

  TextEditingController remarkController = TextEditingController();
  TextEditingController dateController = TextEditingController();
  TextEditingController timeController = TextEditingController();
  TextEditingController rectifyByController = TextEditingController();

  ViewEquipmentComplaintBloc() : super(ViewEquipmentComplaintInitial()) {
    on<ViewEquipmentComplaintPageLoadEvent>(_pageLoad);
    on<ViewEquipmentComplaintSelectedTabIndexEvent>(_selectTab);
    on<ViewEquipmentComplaintSelectedDateRangeEvent>(_selectDateRangeFilter);
    on<ViewEquipmentComplaintSearchEvent>(_search);
    on<ViewEquipmentComplaintClosureEvent>(_closureComplaint);
    on<ViewEquipmentComplaintSelectedComplaintEvent>(_selectComplaint);
    on<ViewEquipmentComplaintSelectDateData>(_selectDate);
    on<ViewEquipmentComplaintSelectTimeData>(_selectTime);
  }

  _pageLoad(ViewEquipmentComplaintPageLoadEvent event, emit) async {
    emit(ViewEquipmentComplaintPageLoadState());
    reviewComplaintList = [];
    complaintCount = [];
    isLoader =  false;
    remarkController.text = "";
    dateController.text = "";
    timeController.text = "";
    dateController.text = "";
    rectifyByController.text = "";
    userData = UserInfo.instanceInit()!.userData!;
    reviewComplaintData =  ReviewComplaintModel();
    index = 0;
    _selectTabIndex = 0;

    startDate = DateTime.now().subtract(const Duration(days: 5));
    endDate = DateTime.now();

    String formattedDate = DateFormat('dd-MM-yyyy').format(DateTime.now());
    dateController.text = formattedDate;

    timeController.text = DateFormat('HH:mm:ss').format(DateTime.now()).toString();

    var res = userData.roleType == RoleType.mi
        ? await MiComplaintHelper.fetchMiComplaint(
            fromDate: startDate.toString(), toDate: endDate.toString())
        : await ReviewComplaintHelper.fetchReviewComplaint(
            fromDate: startDate.toString(), toDate: endDate.toString());

    _selectTabIndex = userData.roleType == RoleType.stationUser ? 0 : 1;

    if (userData.roleType == RoleType.shiftEngineer) {
      var reviewSelfComplaintRes =
          await ViewEquipmentComplaintHelper.fetchReviewAndSelfComplaint();
      if (reviewSelfComplaintRes != null) {
        reviewSelfComplaintList = reviewSelfComplaintRes;
        reviewSelfComplaintWithOutFilterList = reviewSelfComplaintRes;
      }
    }

    if (res != null) {
      reviewComplaintList = res;
      reviewComplaintWithOutFilterList = res;
    }

    if (selectTabIndex == 0) {
      reviewComplaintList =  ComplaintFilterHelper.newFilter(complaintList: reviewComplaintWithOutFilterList);
    }
    else if (selectTabIndex == 1) {
      reviewComplaintList = ComplaintFilterHelper.miFilter(complaintList: reviewComplaintWithOutFilterList);
    }
    else if (selectTabIndex == 2) {
      reviewComplaintList =  ComplaintFilterHelper.vendorFilter(
          complaintList: reviewComplaintWithOutFilterList);
    }
    else if (selectTabIndex == 3) {
      reviewComplaintList = ComplaintFilterHelper.completeFilter(complaintList: reviewComplaintWithOutFilterList);
    }
    else if (selectTabIndex == 4) {
      reviewComplaintList = ComplaintFilterHelper.ackFilter(complaintList: reviewComplaintWithOutFilterList);
    }
    else if (selectTabIndex == 5) {
      reviewComplaintList = ComplaintFilterHelper.closerFilter(complaintList: reviewComplaintWithOutFilterList);
    }
    else if (selectTabIndex == 6) {
      reviewComplaintList = ComplaintFilterHelper.selfFilter(complaintList: reviewComplaintWithOutFilterList);
    }

    complaintCount = [];
    complaintCount.add(ComplaintFilterHelper.newFilter(complaintList: reviewComplaintWithOutFilterList).length);
    complaintCount.add(ComplaintFilterHelper.miFilter(complaintList: reviewComplaintWithOutFilterList).length);
    complaintCount.add(ComplaintFilterHelper.vendorFilter(
        complaintList: reviewComplaintWithOutFilterList).length);
    complaintCount.add(ComplaintFilterHelper.completeFilter(complaintList: reviewComplaintWithOutFilterList).length);
    complaintCount.add(ComplaintFilterHelper.ackFilter(complaintList: reviewComplaintWithOutFilterList).length);
    complaintCount.add(ComplaintFilterHelper.closerFilter(complaintList: reviewComplaintWithOutFilterList).length);
    complaintCount.add(ComplaintFilterHelper.selfFilter(complaintList: reviewComplaintWithOutFilterList).length);
    _eventComplete(emit);
  }

  _search(ViewEquipmentComplaintSearchEvent event, emit) async {
    await Future.delayed(const Duration(milliseconds: 600));
    String keyword = event.keyword;

    List<ReviewComplaintModel> tempList = reviewComplaintWithOutFilterList;

    if (selectTabIndex == 0) {
      tempList =  ComplaintFilterHelper.newFilter(complaintList: reviewComplaintWithOutFilterList);
    }
    else if (selectTabIndex == 1) {
      tempList = ComplaintFilterHelper.miFilter(complaintList: reviewComplaintWithOutFilterList);
    }
    else if (selectTabIndex == 2) {
      tempList =  ComplaintFilterHelper.vendorFilter(
          complaintList: reviewComplaintWithOutFilterList);
    }
    else if (selectTabIndex == 3) {
      tempList = ComplaintFilterHelper.completeFilter(complaintList: reviewComplaintWithOutFilterList);
    }
    else if (selectTabIndex == 4) {
      tempList = ComplaintFilterHelper.ackFilter(complaintList: reviewComplaintWithOutFilterList);
    }
    else if (selectTabIndex == 5) {
      tempList = ComplaintFilterHelper.closerFilter(complaintList: reviewComplaintWithOutFilterList);
    }
    else if (selectTabIndex == 6) {
      tempList = ComplaintFilterHelper.selfFilter(complaintList: reviewComplaintWithOutFilterList);
    }

    complaintCount = [];
    complaintCount.add(ComplaintFilterHelper.newFilter(complaintList: reviewComplaintWithOutFilterList).length);
    complaintCount.add(ComplaintFilterHelper.miFilter(complaintList: reviewComplaintWithOutFilterList).length);
    complaintCount.add(ComplaintFilterHelper.vendorFilter(
        complaintList: reviewComplaintWithOutFilterList).length);
    complaintCount.add(ComplaintFilterHelper.completeFilter(complaintList: reviewComplaintWithOutFilterList).length);
    complaintCount.add(ComplaintFilterHelper.ackFilter(complaintList: reviewComplaintWithOutFilterList).length);
    complaintCount.add(ComplaintFilterHelper.closerFilter(complaintList: reviewComplaintWithOutFilterList).length);
    complaintCount.add(ComplaintFilterHelper.selfFilter(complaintList: reviewComplaintWithOutFilterList).length);

    if (keyword.isNotEmpty) {
      reviewComplaintList = tempList
          .where((element) => element.tokenNo
              .toString()
              .toLowerCase()
              .contains(keyword.toLowerCase()))
          .toList();

      if (reviewComplaintList.isEmpty) {
        reviewComplaintList = tempList
            .where((element) => element.createdByUser
                .toString()
                .toLowerCase()
                .contains(keyword.toLowerCase()))
            .toList();
      }

      if (reviewComplaintList.isEmpty) {
        reviewComplaintList = tempList
            .where((element) => element.complaintDateTime
                .toString()
                .toLowerCase()
                .contains(keyword.toLowerCase()))
            .toList();
      }

      if (reviewComplaintList.isEmpty) {
        reviewComplaintList = tempList
            .where((element) => element.complaintDescription
                .toString()
                .toLowerCase()
                .contains(keyword.toLowerCase()))
            .toList();
      }

      if (reviewComplaintList.isEmpty) {
        reviewComplaintList = tempList
            .where((element) => element.equipmentName
                .toString()
                .toLowerCase()
                .contains(keyword.toLowerCase()))
            .toList();
      } else if (selectTabIndex == 5) {
        reviewComplaintList = reviewComplaintWithOutFilterList
            .where((element) => element.tokenNo
                .toString()
                .toLowerCase()
                .contains(keyword.toLowerCase()))
            .toList();

        if (reviewComplaintList.isEmpty) {
          reviewComplaintList = reviewComplaintWithOutFilterList
              .where((element) => element.createdByUser
                  .toString()
                  .toLowerCase()
                  .contains(keyword.toLowerCase()))
              .toList();
        }

        if (reviewComplaintList.isEmpty) {
          reviewComplaintList = reviewComplaintWithOutFilterList
              .where((element) => element.complaintDateTime
                  .toString()
                  .toLowerCase()
                  .contains(keyword.toLowerCase()))
              .toList();
        }

        if (reviewComplaintList.isEmpty) {
          reviewComplaintList = reviewComplaintWithOutFilterList
              .where((element) => element.complaintDescription
                  .toString()
                  .toLowerCase()
                  .contains(keyword.toLowerCase()))
              .toList();
        }

        if (reviewComplaintList.isEmpty) {
          reviewComplaintList = reviewComplaintWithOutFilterList
              .where((element) => element.equipmentName
                  .toString()
                  .toLowerCase()
                  .contains(keyword.toLowerCase()))
              .toList();
        }
        complaintCount.add(reviewSelfComplaintList.where((element) => element.assignType.toString() != "1").toList().length);
        complaintCount.add(reviewSelfComplaintList.where((element) => element.assignType.toString() == "1").toList().length);
      }
    } else {
      reviewComplaintList = tempList;
    }
    _eventComplete(emit);
  }

  _selectTab(ViewEquipmentComplaintSelectedTabIndexEvent event, emit) async {
    if (await Vibration.hasAmplitudeControl() != null) {
      Vibration.vibrate(duration: 100);
    }

    _selectTabIndex = event.selectedTabIndex;
    if (selectTabIndex == 0) {
      reviewComplaintList =  ComplaintFilterHelper.newFilter(complaintList: reviewComplaintWithOutFilterList);
    }
    else if (selectTabIndex == 1) {
      reviewComplaintList = ComplaintFilterHelper.miFilter(complaintList: reviewComplaintWithOutFilterList);
    }
    else if (selectTabIndex == 2) {
      reviewComplaintList =  ComplaintFilterHelper.vendorFilter(
          complaintList: reviewComplaintWithOutFilterList);
    }
    else if (selectTabIndex == 3) {
      reviewComplaintList = ComplaintFilterHelper.completeFilter(complaintList: reviewComplaintWithOutFilterList);
    }
    else if (selectTabIndex == 4) {
      reviewComplaintList = ComplaintFilterHelper.ackFilter(complaintList: reviewComplaintWithOutFilterList);
    }
    else if (selectTabIndex == 5) {
      reviewComplaintList = ComplaintFilterHelper.closerFilter(complaintList: reviewComplaintWithOutFilterList);
    }
    else if (selectTabIndex == 6) {
      reviewComplaintList = ComplaintFilterHelper.selfFilter(complaintList: reviewComplaintWithOutFilterList);
    }

    complaintCount = [];
    complaintCount.add(ComplaintFilterHelper.newFilter(complaintList: reviewComplaintWithOutFilterList).length);
    complaintCount.add(ComplaintFilterHelper.miFilter(complaintList: reviewComplaintWithOutFilterList).length);
    complaintCount.add(ComplaintFilterHelper.vendorFilter(
        complaintList: reviewComplaintWithOutFilterList).length);
    complaintCount.add(ComplaintFilterHelper.completeFilter(complaintList: reviewComplaintWithOutFilterList).length);
    complaintCount.add(ComplaintFilterHelper.ackFilter(complaintList: reviewComplaintWithOutFilterList).length);
    complaintCount.add(ComplaintFilterHelper.closerFilter(complaintList: reviewComplaintWithOutFilterList).length);
    complaintCount.add(ComplaintFilterHelper.selfFilter(complaintList: reviewComplaintWithOutFilterList).length);
    _eventComplete(emit);
  }

  _selectDateRangeFilter(
      ViewEquipmentComplaintSelectedDateRangeEvent event, emit) async {
    if (await Vibration.hasAmplitudeControl() != null) {
      Vibration.vibrate(duration: 100);
    }
    reviewComplaintList = [];
    reviewComplaintWithOutFilterList = [];
    reviewSelfComplaintList = [];
    reviewSelfComplaintWithOutFilterList = [];
    startDate = event.fromDate;
    endDate = event.toDate;
    _eventComplete(emit);
    emit(ViewEquipmentComplaintPageLoadState());
    var res = userData.roleType == RoleType.mi
        ? await MiComplaintHelper.fetchMiComplaint(
            fromDate: event.fromDate.toString(),
            toDate: event.toDate.toString())
        : await ReviewComplaintHelper.fetchReviewComplaint(
            fromDate: event.fromDate.toString(),
            toDate: event.toDate.toString());
    if (res != null) {
      reviewComplaintList = res;
      reviewComplaintWithOutFilterList = res;
      reviewComplaintList = reviewComplaintWithOutFilterList
          .where((element) => userData.roleType == RoleType.stationUser
              ? element.ackStatus.toString() == "0"
              : element.assignType.toString() == "2" &&
                  element.miAssignType.toString() == "0" &&
                  element.complaintStatus.toString() == "0")
          .toList();

    }

    if (userData.roleType == RoleType.shiftEngineer) {
      var reviewSelfComplaintRes =
          await ViewEquipmentComplaintHelper.fetchReviewAndSelfComplaint();
      if (reviewSelfComplaintRes != null) {
        reviewSelfComplaintList = reviewSelfComplaintRes;
        reviewSelfComplaintWithOutFilterList = reviewSelfComplaintRes;
      }
    }

    if (selectTabIndex == 0) {
      reviewComplaintList =  ComplaintFilterHelper.newFilter(complaintList: reviewComplaintWithOutFilterList);
    }
    else if (selectTabIndex == 1) {
      reviewComplaintList = ComplaintFilterHelper.miFilter(complaintList: reviewComplaintWithOutFilterList);
    }
    else if (selectTabIndex == 2) {
      reviewComplaintList =  ComplaintFilterHelper.vendorFilter(
          complaintList: reviewComplaintWithOutFilterList);
    }
    else if (selectTabIndex == 3) {
      reviewComplaintList = ComplaintFilterHelper.completeFilter(complaintList: reviewComplaintWithOutFilterList);
    }
    else if (selectTabIndex == 4) {
      reviewComplaintList = ComplaintFilterHelper.ackFilter(complaintList: reviewComplaintWithOutFilterList);
    }
    else if (selectTabIndex == 5) {
      reviewComplaintList = ComplaintFilterHelper.closerFilter(complaintList: reviewComplaintWithOutFilterList);
    }
    else if (selectTabIndex == 6) {
      reviewComplaintList = ComplaintFilterHelper.selfFilter(complaintList: reviewComplaintWithOutFilterList);
    }

    complaintCount = [];
    complaintCount.add(ComplaintFilterHelper.newFilter(complaintList: reviewComplaintWithOutFilterList).length);
    complaintCount.add(ComplaintFilterHelper.miFilter(complaintList: reviewComplaintWithOutFilterList).length);
    complaintCount.add(ComplaintFilterHelper.vendorFilter(
        complaintList: reviewComplaintWithOutFilterList).length);
    complaintCount.add(ComplaintFilterHelper.completeFilter(complaintList: reviewComplaintWithOutFilterList).length);
    complaintCount.add(ComplaintFilterHelper.ackFilter(complaintList: reviewComplaintWithOutFilterList).length);
    complaintCount.add(ComplaintFilterHelper.closerFilter(complaintList: reviewComplaintWithOutFilterList).length);
    complaintCount.add(ComplaintFilterHelper.selfFilter(complaintList: reviewComplaintWithOutFilterList).length);

    _eventComplete(emit);
  }

  _selectComplaint(ViewEquipmentComplaintSelectedComplaintEvent event, emit) {
    index =  event.index;
    reviewComplaintData =  reviewComplaintList[index];
    _eventComplete(emit);
  }

  _selectDate(ViewEquipmentComplaintSelectDateData event, emit) async {
    try {
      final DateTime? picked = await showDatePicker(
          context: event.context,
          initialDate: DateTime.now(),
          firstDate: DateTime(2015, 8),
          lastDate: DateTime.now());
      if (picked != null) {
        String formattedDate = DateFormat('dd-MM-yyyy').format(picked);
        dateController.text = formattedDate;
      }
    } catch (e) {
      if (kDebugMode) {
        print(e.toString());
      }
    }
  }

  _selectTime(ViewEquipmentComplaintSelectTimeData event, emit) async {
    try {
      DateTime initialDate = timeController.text.toString().isNotEmpty
          ? DateFormat('HH:mm:ss').parse(timeController.text.toString())
          : DateTime.now();

      final DateTime? time = await showCupertinoDatePicker(
        context: event.context,
        initialDateTime: initialDate,
        mode: CupertinoDatePickerMode.dateAndTime,
      );

      if (time != null) {
        timeController.text = DateFormat('HH:mm:ss').format(time).toString();
        _eventComplete(emit);
      }
    } catch (e) {
      if (kDebugMode) {
        print(e.toString());
      }
    }
  }


  _closureComplaint(ViewEquipmentComplaintClosureEvent event, emit) async {
    var textFiledValidation =  await ViewEquipmentComplaintHelper.closureComplaintTextFiledValidation(context: event.context,
        date: dateController.text.toString(),
        time: timeController.text.toString(),
        rectifiedBy: rectifyByController.text.toString(),
        remark: remarkController.text.toString());
    if(textFiledValidation == false){
      return;
    }

     isLoader =  true;
     reviewComplaintList[event.index].isSelected =  true;
     _eventComplete(emit);
     var res =  await ViewEquipmentComplaintHelper.closureComplaint(
          context: !event.context.mounted ? event.context :event.context,
         reviewComplaintData: reviewComplaintData,
         date: dateController.text.toString(),
         time: timeController.text.toString(),
         rectifiedBy: rectifyByController.text.toString(),
         remark: remarkController.text.toString(),
        scrapList: BlocProvider.of<AddScrapBloc>(!event.context.mounted ? event.context : event.context).scrapList,
        partList: BlocProvider.of<AddSparePartBloc>(!event.context.mounted ? event.context : event.context).partList,
     );
     if(res != null){
       if (!event.context.mounted) return;
       Navigator.pop(event.context, "Completed");
     } else {
       isLoader =  false;
       reviewComplaintList[event.index].isSelected =  false;
       _eventComplete(emit);
     }
  }

  _eventComplete(Emitter<ViewEquipmentComplaintState> emit) {
    emit(FetchViewEquipmentComplaintDataState(
        reviewComplaintList: reviewComplaintList,
        selectedTabIndex: selectTabIndex,
        startDate: startDate,
        endDate: endDate,
        isLoader:  isLoader,
        complaintCount: complaintCount,
        remarkController: remarkController,
        index: index,
        reviewComplaintData: reviewComplaintData,
        dateController: dateController,
        rectifyByController: rectifyByController,
        timeController: timeController,
    ));
  }
}
