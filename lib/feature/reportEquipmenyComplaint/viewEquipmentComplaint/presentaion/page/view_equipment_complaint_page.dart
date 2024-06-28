import 'package:flutter/material.dart';
import 'package:flutter_igl_cng/ExportFile/app_export_file.dart';
import 'package:flutter_igl_cng/feature/login/domain/models/login_model.dart';
import 'package:flutter_igl_cng/feature/miComplaint/presentation/page/mi_complaint_page.dart';
import 'package:flutter_igl_cng/feature/reportEquipmenyComplaint/addEquipmentComplaint/presentation/page/add_equipment_complaint_page.dart';
import 'package:flutter_igl_cng/feature/reviewComplaint/presentation/page/review_complaint_page.dart';
import 'package:flutter_igl_cng/feature/reviewComplaint/presentation/widget/review_complaint_item_box.dart';
import 'package:flutter_igl_cng/utils/commonClass/fade_route.dart';
import 'package:flutter_igl_cng/utils/commonClass/user_info.dart';
import 'package:flutter_igl_cng/utils/commonWidgets/date_range_pop_widget.dart';

class ViewEquipmentComplaintPage extends StatefulWidget {
  final String? title;
  const ViewEquipmentComplaintPage({super.key, this.title});

  @override
  State<ViewEquipmentComplaintPage> createState() =>
      _ViewEquipmentComplaintPageState();
}

class _ViewEquipmentComplaintPageState extends State<ViewEquipmentComplaintPage>
    with SingleTickerProviderStateMixin {

  @override
  void initState() {
    BlocProvider.of<ViewEquipmentComplaintBloc>(context)
        .add(ViewEquipmentComplaintPageLoadEvent(context: context));
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    LoginDataModel userData = UserInfo.instanceInit()!.userData!;
    return Scaffold(
      floatingActionButtonLocation: FloatingActionButtonLocation.startFloat,
      floatingActionButton: userData.roleType == RoleType.stationUser
          ? _floatingActionButton()
          : const SizedBox.shrink(),
      appBar: PreferredSize(
        preferredSize: Size.fromHeight( widget.title != null
            ? MediaQuery.of(context).size.height * 0.13 : MediaQuery.of(context).size.height * 0.07),
        child: AppBar(
          title: TextWidget(widget.title ?? "", color: AppColor.white,
            fontSize: AppFont.font_15, fontWeight: FontWeight.w600,),
          bottom: PreferredSize(
            preferredSize: Size.fromHeight(MediaQuery.of(context).size.height * 0.13),
            child: Row(
                children: [
                  SizedBox(
                    width: MediaQuery.of(context).size.width * 0.08,
                  ),
                  Expanded(child: _searchController()),
                  IconButton(
                      onPressed: () async {
                        DateTime startDate =
                            BlocProvider.of<ViewEquipmentComplaintBloc>(
                                    !context.mounted ? context : context)
                                .startDate;
                        DateTime endDate =
                            BlocProvider.of<ViewEquipmentComplaintBloc>(
                                    !context.mounted ? context : context)
                                .endDate;
                        var selectedDate =  await DateRangeWidget.showDateRange(
                            startDate: startDate, endDate: endDate, context : context);
                          if(selectedDate != null){
                            BlocProvider.of<ViewEquipmentComplaintBloc>(
                                !context.mounted ? context : context)
                                .add(
                                ViewEquipmentComplaintSelectedDateRangeEvent(
                                    fromDate: selectedDate.start,
                                    toDate: selectedDate.end,
                                    context: !context.mounted ? context : context));
                          }
                      },
                      icon: Icon(
                        Icons.filter_alt_outlined,
                        color: AppColor.white,
                      ))
                ],
              ),
          ),
        ),
      ),
      body:
          BlocBuilder<ViewEquipmentComplaintBloc, ViewEquipmentComplaintState>(
        builder: (context, state) {
          if (state is FetchViewEquipmentComplaintDataState) {
            return RefreshIndicator(
              onRefresh: _handleRefresh,
              child: Column(
                children: [
                  _tabWidget(dataState: state),
                  Expanded(child: _listBuilder(dataState: state)),
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
    );
  }

  DateTimeRange? _initialDateTimeRange(Map<dynamic, dynamic> arguments) {
    if (arguments['initialStartDate'] != null &&
        arguments['initialEndDate'] != null) {
      return DateTimeRange(
        start: DateTime.fromMillisecondsSinceEpoch(
            arguments['initialStartDate'] as int),
        end: DateTime.fromMillisecondsSinceEpoch(
            arguments['initialEndDate'] as int),
      );
    }

    return null;
  }

  Future<void> _handleRefresh() async {
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

  Widget _floatingActionButton() {
    return FloatingActionButton(
      shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(15.0))),
      backgroundColor: AppColor.themeColor,
      onPressed: () async {
        var res = await Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) => const AddEquipmentComplaintPage()),
        );
        if (res != null && res.toString() == "complete") {
          if (!context.mounted) return;
          BlocProvider.of<ViewEquipmentComplaintBloc>(
                  !context.mounted ? context : context)
              .add(ViewEquipmentComplaintPageLoadEvent(
                  context: !context.mounted ? context : context));
        }
      },
      child: Icon(
        Icons.add,
        color: AppColor.white,
      ),
    );
  }

  Widget _searchController() {
    return SizedBox(
      height: MediaQuery.of(context).size.width * 0.10,
      child: TextField(
        onChanged: (keyword) {
          BlocProvider.of<ViewEquipmentComplaintBloc>(context)
              .add(ViewEquipmentComplaintSearchEvent(keyword: keyword));
        },
        style: TextStyle(
          color: const Color(0xff020202),
          fontSize: AppFont.font_12,
          fontWeight: FontWeight.w400,
          letterSpacing: 0.5,
        ),
        decoration: InputDecoration(
          filled: true,
          fillColor: const Color(0xfff1f1f1),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(50),
            borderSide: BorderSide.none,
          ),
          hintText: "Search...",
          hintStyle: TextStyle(
              color: const Color(0xffb2b2b2),
              fontSize: AppFont.font_12,
              fontWeight: FontWeight.w400,
              letterSpacing: 0.5,
              decorationThickness: 6),
          prefixIcon: const Icon(
            Icons.search,
          ),
          prefixIconColor: AppColor.themeColor,
        ),
      ),
    );
  }

  Widget _tabWidget({required FetchViewEquipmentComplaintDataState dataState}) {
    LoginDataModel userData = UserInfo.instanceInit()!.userData!;
    return Container(
      height: MediaQuery.of(context).size.width * 0.10,
      margin: const EdgeInsets.only(left: 10.0, right: 10.0, top: 5.0),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        color: AppColor.themeNormalLightColor,
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

          userData.roleType == RoleType.shiftEngineer
              || userData.roleType == RoleType.mi
           ? TextButton(
              style: dataState.selectedTabIndex == 1
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
              )) : const SizedBox.shrink(),

          userData.roleType == RoleType.shiftEngineer ||
              userData.roleType == RoleType.mi
          ? TextButton(
              style: dataState.selectedTabIndex == 2
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
              )) : const SizedBox.shrink(),


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
        ],
      ),
    );
  }

  Widget _listBuilder(
      {required FetchViewEquipmentComplaintDataState dataState}) {
    return Container(
      margin: const EdgeInsets.all(10.0),
      child: dataState.reviewComplaintList.isNotEmpty
          ? ListView.builder(
              itemCount: dataState.reviewComplaintList.length,
              shrinkWrap: true,
              itemBuilder: (context, index) {
                return GestureDetector(
                    onTap: () async {
                      LoginDataModel userLogin =
                          UserInfo.instanceInit()!.userData!;
                      if (userLogin.roleType == RoleType.stationUser &&
                          dataState.reviewComplaintList[index].complaintStatus
                                  .toString() ==
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
                          color: AppColor.grey,
                        ),
                        const TextWidget(
                          "No Data\nTab to refresh",
                          textAlign: TextAlign.center,
                        ),
                      ],
                    )),
              ),
            ),
    );
  }
}
