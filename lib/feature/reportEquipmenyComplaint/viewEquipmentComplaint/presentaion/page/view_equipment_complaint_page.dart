import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_igl_cng/ExportFile/app_export_file.dart';
import 'package:flutter_igl_cng/feature/login/domain/models/login_model.dart';
import 'package:flutter_igl_cng/feature/miComplaint/presentation/page/mi_complaint_page.dart';
import 'package:flutter_igl_cng/feature/reportEquipmenyComplaint/addEquipmentComplaint/presentation/page/add_equipment_complaint_page.dart';
import 'package:flutter_igl_cng/feature/reviewComplaint/presentation/page/review_complaint_page.dart';
import 'package:flutter_igl_cng/feature/reviewComplaint/presentation/widget/review_complaint_item_box.dart';
import 'package:flutter_igl_cng/utils/commonClass/fade_route.dart';
import 'package:flutter_igl_cng/utils/commonClass/user_info.dart';
import 'package:flutter_igl_cng/utils/commonWidgets/date_range_pop_widget.dart';
import 'package:syncfusion_flutter_datepicker/datepicker.dart';

class ViewEquipmentComplaintPage extends StatefulWidget {
  const ViewEquipmentComplaintPage({super.key});

  @override
  State<ViewEquipmentComplaintPage> createState() =>
      _ViewEquipmentComplaintPageState();
}

class _ViewEquipmentComplaintPageState
    extends State<ViewEquipmentComplaintPage> {
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
      appBar: AppBar(
        title: Row(
          children: [
            Expanded(child: _searchController()),
            IconButton(
                onPressed: () {
                  showDialog(
                      context: context,
                      builder: (mContext) {
                        return  DateRangePopWidget(
                          onSubmit: (value) {
                            Navigator.pop(context);
                            PickerDateRange? date = value as PickerDateRange?;
                            BlocProvider.of<ViewEquipmentComplaintBloc>(context)
                                .add(ViewEquipmentComplaintSelectedDateRangeEvent(
                                fromDate: date!.startDate.toString(),
                                toDate: date.endDate.toString(),
                                context: context));
                          },
                        );
                      });
                },
                icon: Icon(
                  Icons.filter_alt_outlined,
                  color: AppColor.white,
                ))
          ],
        ),
      ),
      body:
          BlocBuilder<ViewEquipmentComplaintBloc, ViewEquipmentComplaintState>(
        builder: (context, state) {
          if (state is FetchViewEquipmentComplaintDataState) {
            return Column(
              children: [
                _tabWidget(dataState: state),
                Expanded(child: _listBuilder(dataState: state)),
              ],
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
  void _onSelectionChanged(DateRangePickerSelectionChangedArgs args) {
    print("Done Date=========");
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
          BlocProvider.of<ViewEquipmentComplaintBloc>(context)
              .add(ViewEquipmentComplaintPageLoadEvent(context: context));
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
      height: MediaQuery.of(context).size.width * 0.13,
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
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          userData.roleType != RoleType.shiftEngineer
           || userData.roleType != RoleType.mi
              ? Expanded(
            child: TextButton(
                style: dataState.selectedTabIndex == 0 ?
                ButtonStyle(
                    backgroundColor: MaterialStateProperty.all<Color>(
                        AppColor.themeColor ),
                    shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                        RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10.0),
                            side:  BorderSide(color: AppColor.themeColor )
                        )
                    )
                ) : null,
                onPressed: () {
                  BlocProvider.of<ViewEquipmentComplaintBloc>(context)
                      .add(const ViewEquipmentComplaintSelectedTabIndexEvent(selectedTabIndex: 0));
                }, child:  TextWidget(
              "New",
              color: dataState.selectedTabIndex == 0
                  ? AppColor.white
                  : AppColor.black,
              fontWeight: dataState.selectedTabIndex == 0
                  ? FontWeight.w700
                  : FontWeight.w400,
              fontSize: AppFont.font_13,)),
          ) : const SizedBox.shrink(),

          Expanded(
            child: TextButton(
                style: dataState.selectedTabIndex == 1 ?
                ButtonStyle(
                    backgroundColor: MaterialStateProperty.all<Color>(
                        AppColor.themeColor ),
                    shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                        RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10.0),
                            side:  BorderSide(color: AppColor.themeColor )
                        )
                    )
                ) : null,
                onPressed: () {
                  BlocProvider.of<ViewEquipmentComplaintBloc>(context)
                      .add(const ViewEquipmentComplaintSelectedTabIndexEvent(selectedTabIndex: 1));
                }, child:  TextWidget(
              "MI",
              color: dataState.selectedTabIndex == 1
                  ? AppColor.white
                  : AppColor.black,
              fontWeight: dataState.selectedTabIndex == 1
                  ? FontWeight.w700
                  : FontWeight.w400,
              fontSize: AppFont.font_13,)),
          ),

          Expanded(
            child: TextButton(
                style: dataState.selectedTabIndex == 2 ?
                ButtonStyle(
                    backgroundColor: MaterialStateProperty.all<Color>(
                        AppColor.themeColor ),
                    shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                        RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10.0),
                            side:  BorderSide(color: AppColor.themeColor )
                        )
                    )
                ) : null,
                onPressed: () {
                  BlocProvider.of<ViewEquipmentComplaintBloc>(context)
                      .add(const ViewEquipmentComplaintSelectedTabIndexEvent(selectedTabIndex: 2));
                }, child:  TextWidget(
              "Vendor",
              color: dataState.selectedTabIndex == 2
                  ? AppColor.white
                  : AppColor.black,
              fontWeight: dataState.selectedTabIndex == 2
                  ? FontWeight.w700
                  : FontWeight.w400,
              fontSize: AppFont.font_13,)),
          ),

          userData.roleType == RoleType.stationUser
              || userData.roleType == RoleType.shiftEngineer
              ? Expanded(
            child: TextButton(
                style: dataState.selectedTabIndex == 3 ?
                ButtonStyle(
                    backgroundColor: MaterialStateProperty.all<Color>(
                        AppColor.themeColor ),
                    shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                        RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10.0),
                            side:  BorderSide(color: AppColor.themeColor )
                        )
                    )
                ) : null,
                onPressed: () {
                  BlocProvider.of<ViewEquipmentComplaintBloc>(context)
                      .add(const ViewEquipmentComplaintSelectedTabIndexEvent(selectedTabIndex: 3));
                }, child:  TextWidget(
              "Complete",
              color: dataState.selectedTabIndex == 3
                  ? AppColor.white
                  : AppColor.black,
              fontWeight: dataState.selectedTabIndex == 3
                  ? FontWeight.w700
                  : FontWeight.w400,
              fontSize: AppFont.font_13,)),
          ) : const SizedBox.shrink(),
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
                          dataState.reviewComplaintList[index].action
                                  .toString() ==
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
                          dataState.reviewComplaintList[index].action
                                  .toString() == "4" ) {
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
                          dataState.reviewComplaintList[index].action
                                  .toString() !=
                              "3" &&
                          dataState.reviewComplaintList[index].complaintStatus
                                  .toString() !=
                              "2") {
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
                          dataState.reviewComplaintList[index].action
                                  .toString() ==
                              "3") {
                        SnackBarErrorWidget(context)
                            .show(message: "Complaint already closed");
                      } else if (userLogin.roleType == RoleType.mi &&
                          dataState.reviewComplaintList[index].complaintStatus
                                  .toString() ==
                              "2") {
                        SnackBarErrorWidget(context)
                            .show(message: "Complaint already Reject");
                      }
                    },
                    child: ReviewComplaintItemBox(
                      reviewComplaintData: dataState.reviewComplaintList[index],
                    ));
              })
          : const Center(
              child: TextWidget("No Data"),
            ),
    );
  }
}
