import 'package:flutter/material.dart';
import 'package:flutter_igl_cng/ExportFile/app_export_file.dart';
import 'package:flutter_igl_cng/commonWidget/search_bar_widget.dart';
import 'package:flutter_igl_cng/feature/miComplaint/presentation/page/mi_complaint_page.dart';
import 'package:flutter_igl_cng/feature/reportEquipmenyComplaint/viewEquipmentComplaint/presentaion/page/view_equipment_complaint_detail_page.dart';
import 'package:flutter_igl_cng/feature/reviewComplaint/presentation/page/review_complaint_page.dart';
import 'package:flutter_igl_cng/feature/reviewComplaint/presentation/widget/review_complaint_item_box.dart';
import 'package:flutter_igl_cng/utils/commonClass/fade_route.dart';
import 'package:flutter_igl_cng/utils/commonClass/user_info.dart';
import 'package:flutter_igl_cng/utils/commonWidgets/date_range_pop_widget.dart';

class ViewEquipmentWidget extends StatelessWidget {
  const ViewEquipmentWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        _searchWidget(context: context),
        SizedBox(
          height: MediaQuery.of(context).size.height * 0.02,
        ),
        Expanded(
          child: Container(
            decoration: BoxDecoration(
              borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(20),
                  topRight: Radius.circular(20)),
              color: Colors.white.withOpacity(.4),
            ),
            child: BlocBuilder<ViewEquipmentComplaintBloc,
                ViewEquipmentComplaintState>(
              builder: (context, state) {
                if (state is FetchViewEquipmentComplaintDataState) {
                  return RefreshIndicator(
                    onRefresh: () async {
                      _handleRefresh(context: context);
                    },
                    child: Column(
                      children: [
                        SizedBox(
                          height: MediaQuery.of(context).size.height * 0.03,
                        ),
                        _tabWidget(dataState: state, context: context),
                        Expanded(child: _listBuilder(dataState: state, context: context)),
                      ],
                    ),
                  );
                } else {
                  return const Center(
                    child: CenterLoaderWidget(),
                  );
                }
              },
            ),
          ),
        ),
      ],
    );
  }


  Future<void> _handleRefresh({required BuildContext context}) async {
    await Future.delayed(const Duration(seconds: 1));
    DateTime startDate = BlocProvider.of<ViewEquipmentComplaintBloc>(
        !context.mounted ? context : context)
        .startDate;
    DateTime endDate = BlocProvider.of<ViewEquipmentComplaintBloc>(
        !context.mounted ? context : context)
        .endDate;
    BlocProvider.of<ViewEquipmentComplaintBloc>(
        !context.mounted ? context : context)
        .add(ViewEquipmentComplaintSelectedDateRangeEvent(
        fromDate: startDate,
        toDate: endDate,
        context: !context.mounted ? context : context));
  }

  Widget _searchWidget({required BuildContext context}) {
    return SearchBarWidget(
      onPressed: () async {
        DateTime startDate =
            BlocProvider.of<ViewEquipmentComplaintBloc>(
                !context.mounted ? context : context)
                .startDate;
        DateTime endDate =
            BlocProvider.of<ViewEquipmentComplaintBloc>(
                !context.mounted ? context : context)
                .endDate;
        var selectedDate = await DateRangeWidget.showDateRange(
            startDate: startDate,
            endDate: endDate,
            context: context);
        if (selectedDate != null) {
          BlocProvider.of<ViewEquipmentComplaintBloc>(
              !context.mounted ? context : context)
              .add(ViewEquipmentComplaintSelectedDateRangeEvent(
              fromDate: selectedDate.start,
              toDate: selectedDate.end,
              context: !context.mounted ? context : context));
        }
      },
      onChanged: (keyword) {
        BlocProvider.of<ViewEquipmentComplaintBloc>(context)
            .add(ViewEquipmentComplaintSearchEvent(keyword: keyword));
      },
    );
  }

  Widget _tabWidget({required FetchViewEquipmentComplaintDataState dataState,
    required BuildContext context}) {
    LoginDataModel userData = UserInfo.instanceInit()!.userData!;
    return Container(
      height: MediaQuery.of(context).size.width * 0.10,
      margin: const EdgeInsets.only(left: 10.0, right: 10.0, top: 5.0),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        color: AppColor.white,
      ),
      child: ListView(
        scrollDirection: Axis.horizontal,
        shrinkWrap: true,
        children: [
          userData.roleType == RoleType.stationUser
              ? TextButton(
              style: dataState.selectedTabIndex == 0
                  ? ButtonStyle(
                  backgroundColor: MaterialStateProperty.all<Color>(
                      AppColor.themeColor),
                  shape:
                  MaterialStateProperty.all<RoundedRectangleBorder>(
                      RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10.0),
                          side: BorderSide(
                              color: AppColor.themeColor))))
                  : null,
              onPressed: () {
                BlocProvider.of<ViewEquipmentComplaintBloc>(context).add(
                    const ViewEquipmentComplaintSelectedTabIndexEvent(
                        selectedTabIndex: 0));
              },
              child: TextWidget(
                "New-${dataState.complaintCount[0]}",
                color: dataState.selectedTabIndex == 0
                    ? AppColor.white
                    : AppColor.black,
                fontWeight: dataState.selectedTabIndex == 0
                    ? FontWeight.w700
                    : FontWeight.w400,
                fontSize: AppFont.font_11,
              ))
              : const SizedBox.shrink(),
          userData.roleType == RoleType.stationUser
              ? TextButton(
              style: dataState.selectedTabIndex == 4
                  ? ButtonStyle(
                  backgroundColor: MaterialStateProperty.all<Color>(
                      AppColor.themeColor),
                  shape:
                  MaterialStateProperty.all<RoundedRectangleBorder>(
                      RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10.0),
                          side: BorderSide(
                              color: AppColor.themeColor))))
                  : null,
              onPressed: () {
                BlocProvider.of<ViewEquipmentComplaintBloc>(context).add(
                    const ViewEquipmentComplaintSelectedTabIndexEvent(
                        selectedTabIndex: 4));
              },
              child: TextWidget(
                "Ack-${dataState.complaintCount[4]}",
                color: dataState.selectedTabIndex == 4
                    ? AppColor.white
                    : AppColor.black,
                fontWeight: dataState.selectedTabIndex == 4
                    ? FontWeight.w700
                    : FontWeight.w400,
                fontSize: AppFont.font_11,
              ))
              : const SizedBox.shrink(),
          userData.roleType == RoleType.shiftEngineer ||
              userData.roleType == RoleType.mi
              ? TextButton(
              style: dataState.selectedTabIndex == 1
                  ? ButtonStyle(
                  backgroundColor: MaterialStateProperty.all<Color>(
                      AppColor.themeColor),
                  shape:
                  MaterialStateProperty.all<RoundedRectangleBorder>(
                      RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10.0),
                          side: BorderSide(
                              color: AppColor.themeColor))))
                  : null,
              onPressed: () {
                BlocProvider.of<ViewEquipmentComplaintBloc>(context).add(
                    const ViewEquipmentComplaintSelectedTabIndexEvent(
                        selectedTabIndex: 1));
              },
              child: TextWidget(
                "MI-${dataState.complaintCount[1]}",
                color: dataState.selectedTabIndex == 1
                    ? AppColor.white
                    : AppColor.black,
                fontWeight: dataState.selectedTabIndex == 1
                    ? FontWeight.w700
                    : FontWeight.w400,
                fontSize: AppFont.font_11,
              ))
              : const SizedBox.shrink(),
          userData.roleType == RoleType.shiftEngineer ||
              userData.roleType == RoleType.mi
              ? TextButton(
              style: dataState.selectedTabIndex == 2
                  ? ButtonStyle(
                  backgroundColor: MaterialStateProperty.all<Color>(
                      AppColor.themeColor),
                  shape:
                  MaterialStateProperty.all<RoundedRectangleBorder>(
                      RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10.0),
                          side: BorderSide(
                              color: AppColor.themeColor))))
                  : null,
              onPressed: () {
                BlocProvider.of<ViewEquipmentComplaintBloc>(context).add(
                    const ViewEquipmentComplaintSelectedTabIndexEvent(
                        selectedTabIndex: 2));
              },
              child: TextWidget(
                "Vendor-${dataState.complaintCount[2]}",
                color: dataState.selectedTabIndex == 2
                    ? AppColor.white
                    : AppColor.black,
                fontWeight: dataState.selectedTabIndex == 2
                    ? FontWeight.w700
                    : FontWeight.w400,
                fontSize: AppFont.font_11,
              ))
              : const SizedBox.shrink(),
          TextButton(
              style: dataState.selectedTabIndex == 3
                  ? ButtonStyle(
                  backgroundColor:
                  MaterialStateProperty.all<Color>(AppColor.themeColor),
                  shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                      RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10.0),
                          side: BorderSide(color: AppColor.themeColor))))
                  : null,
              onPressed: () {
                BlocProvider.of<ViewEquipmentComplaintBloc>(context).add(
                    const ViewEquipmentComplaintSelectedTabIndexEvent(
                        selectedTabIndex: 3));
              },
              child: TextWidget(
                "Complete-${dataState.complaintCount[3]}",
                color: dataState.selectedTabIndex == 3
                    ? AppColor.white
                    : AppColor.black,
                fontWeight: dataState.selectedTabIndex == 3
                    ? FontWeight.w700
                    : FontWeight.w400,
                fontSize: AppFont.font_11,
              )),
          userData.roleType == RoleType.shiftEngineer
              ? TextButton(
              style: dataState.selectedTabIndex == 5
                  ? ButtonStyle(
                  backgroundColor: MaterialStateProperty.all<Color>(
                      AppColor.themeColor),
                  shape:
                  MaterialStateProperty.all<RoundedRectangleBorder>(
                      RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10.0),
                          side: BorderSide(
                              color: AppColor.themeColor))))
                  : null,
              onPressed: () {
                BlocProvider.of<ViewEquipmentComplaintBloc>(context).add(
                    const ViewEquipmentComplaintSelectedTabIndexEvent(
                        selectedTabIndex: 5));
              },
              child: TextWidget(
                "REV-${dataState.complaintCount[5]}",
                color: dataState.selectedTabIndex == 5
                    ? AppColor.white
                    : AppColor.black,
                fontWeight: dataState.selectedTabIndex == 5
                    ? FontWeight.w700
                    : FontWeight.w400,
                fontSize: AppFont.font_11,
              ))
              : const SizedBox.shrink(),
        ],
      ),
    );
  }

  Widget _listBuilder(
      {required FetchViewEquipmentComplaintDataState dataState, required BuildContext context}) {
    return Container(
      margin: const EdgeInsets.all(10.0),
      child: dataState.reviewComplaintList.isNotEmpty
          ? ListView.builder(
          padding: EdgeInsets.zero,
          itemCount: dataState.reviewComplaintList.length,
          shrinkWrap: true,
          itemBuilder: (context, index) {
            return GestureDetector(
                onTap: () async {
                  LoginDataModel userLogin =
                  UserInfo.instanceInit()!.userData!;
                  if(dataState.reviewComplaintList[index].complaintStatus.toString() == "1"){
                    return;
                  }
                  else if(dataState.reviewComplaintList[index].miAssignToUser.toString().isEmpty &&
                      dataState.reviewComplaintList[index].complaintStatus.toString() == "0" &&
                      userLogin.roleType == RoleType.stationUser ) {
                    BlocProvider.of<ViewEquipmentComplaintBloc>(context).add(
                        ViewEquipmentComplaintSelectedComplaintEvent(index: index));
                    var result = await Navigator.push(context,
                        FadeRoute(page: const ViewEquipmentComplaintDetailPage()));
                    if (result.toString() == "Completed") {
                      BlocProvider.of<ViewEquipmentComplaintBloc>(
                          !context.mounted ? context : context)
                          .add(ViewEquipmentComplaintPageLoadEvent(
                          context:
                          !context.mounted ? context : context));
                    }
                  }
                  else if (userLogin.roleType == RoleType.stationUser &&
                      dataState.reviewComplaintList[index].complaintStatus.toString() ==
                          "0" &&
                      dataState.reviewComplaintList[index].assignType.toString() ==
                          "3") {
                    BlocProvider.of<ReviewComplaintBloc>(context).add(
                        ReviewComplaintPageLoadEvent(
                            context: context,
                            reviewComplaintData:
                            dataState.reviewComplaintList[index]));
                    var result = await Navigator.push(context,
                        FadeRoute(page: const ReviewComaplintPage()));
                    if (!context.mounted) result;
                    if (result.toString() == "Completed") {
                      BlocProvider.of<ViewEquipmentComplaintBloc>(
                          !context.mounted ? context : context)
                          .add(ViewEquipmentComplaintPageLoadEvent(
                          context:
                          !context.mounted ? context : context));
                    }
                  } else if (userLogin.roleType == RoleType.stationUser &&
                      dataState.reviewComplaintList[index].complaintStatus
                          .toString() ==
                          "0" &&
                      dataState.reviewComplaintList[index].miAssignType.toString() ==
                          "3") {
                    BlocProvider.of<ReviewComplaintBloc>(context).add(
                        ReviewComplaintPageLoadEvent(
                            context: context,
                            reviewComplaintData:
                            dataState.reviewComplaintList[index]));
                    var result = await Navigator.push(context,
                        FadeRoute(page: const ReviewComaplintPage()));
                    if (!context.mounted) result;
                    if (result.toString() == "Completed") {
                      BlocProvider.of<ViewEquipmentComplaintBloc>(
                          !context.mounted ? context : context)
                          .add(ViewEquipmentComplaintPageLoadEvent(
                          context:
                          !context.mounted ? context : context));
                    }
                  } else if (userLogin.roleType == RoleType.shiftEngineer &&
                      dataState.reviewComplaintList[index].assignType.toString() ==
                          "3") {
                    BlocProvider.of<ReviewComplaintBloc>(context).add(
                        ReviewComplaintPageLoadEvent(
                            context: context,
                            reviewComplaintData:
                            dataState.reviewComplaintList[index]));
                    var result = await Navigator.push(context,
                        FadeRoute(page: const ReviewComaplintPage()));
                    if (!context.mounted) result;
                    if (result.toString() == "Completed") {
                      BlocProvider.of<ViewEquipmentComplaintBloc>(
                          !context.mounted ? context : context)
                          .add(ViewEquipmentComplaintPageLoadEvent(
                          context:
                          !context.mounted ? context : context));
                    }
                  } else if (userLogin.roleType == RoleType.shiftEngineer &&
                      dataState.reviewComplaintList[index].miAssignType.toString() ==
                          "3") {
                    BlocProvider.of<ReviewComplaintBloc>(context).add(
                        ReviewComplaintPageLoadEvent(
                            context: context,
                            reviewComplaintData:
                            dataState.reviewComplaintList[index]));
                    var result = await Navigator.push(context,
                        FadeRoute(page: const ReviewComaplintPage()));
                    if (!context.mounted) result;
                    if (result.toString() == "Completed") {
                      BlocProvider.of<ViewEquipmentComplaintBloc>(
                          !context.mounted ? context : context)
                          .add(ViewEquipmentComplaintPageLoadEvent(
                          context:
                          !context.mounted ? context : context));
                    }
                  } else if (userLogin.roleType == RoleType.shiftEngineer &&
                      dataState.selectedTabIndex == 5) {
                    BlocProvider.of<ReviewComplaintBloc>(context).add(
                        ReviewComplaintPageLoadEvent(
                            context: context,
                            reviewComplaintData:
                            dataState.reviewComplaintList[index]));
                    var result = await Navigator.push(context,
                        FadeRoute(page: const ReviewComaplintPage()));
                    if (!context.mounted) result;
                    if (result.toString() == "Completed") {
                      BlocProvider.of<ViewEquipmentComplaintBloc>(
                          !context.mounted ? context : context)
                          .add(ViewEquipmentComplaintPageLoadEvent(
                          context:
                          !context.mounted ? context : context));
                    }
                  } else if (userLogin.roleType == RoleType.mi &&
                      dataState.reviewComplaintList[index].action.toString() !=
                          "3" &&
                      dataState.reviewComplaintList[index].complaintStatus
                          .toString() !=
                          "1") {
                    BlocProvider.of<MiComplaintBloc>(context).add(
                        MiComplaintPageLoadEvent(
                            context: context,
                            reviewComplaintData:
                            dataState.reviewComplaintList[index]));
                    final result = await Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const MiComplaintPage()),
                    );
                    if (!context.mounted) result;
                    if (result.toString() == "Completed") {
                      BlocProvider.of<ViewEquipmentComplaintBloc>(
                          !context.mounted ? context : context)
                          .add(ViewEquipmentComplaintPageLoadEvent(
                          context:
                          !context.mounted ? context : context));
                    }
                  } else if (userLogin.roleType == RoleType.mi &&
                      dataState.reviewComplaintList[index].action.toString() ==
                          "3") {
                    SnackBarErrorWidget(context)
                        .show(message: "Complaint already closed");
                  } else if (userLogin.roleType == RoleType.mi &&
                      dataState.reviewComplaintList[index].complaintStatus.toString() == "2") {
                    SnackBarErrorWidget(context)
                        .show(message: "Complaint already Reject");
                  }
                },
                child: ReviewComplaintItemBox(
                  index: index,
                  reviewComplaintData: dataState.reviewComplaintList[index],
                ));
          })
          : Center(
        child: SizedBox(
          height: MediaQuery.of(context).size.height * 0.10,
          child: GestureDetector(
              onTap: () async {
                BlocProvider.of<ViewEquipmentComplaintBloc>(context).add(
                    ViewEquipmentComplaintSelectedDateRangeEvent(
                        fromDate: dataState.startDate,
                        toDate: dataState.endDate,
                        context: context));
              },
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.refresh,
                    color: AppColor.white,
                  ),
                  TextWidget(
                    "No Data\nTab to refresh",
                    color: AppColor.white,
                    textAlign: TextAlign.center,
                  ),
                ],
              )),
        ),
      ),
    );
  }
}
