import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_igl_cng/ExportFile/app_export_file.dart';
import 'package:flutter_igl_cng/feature/cng/viewCng/presentation/page/view_cng_detail_page.dart';
import 'package:flutter_igl_cng/feature/lcv/assignment/viewAssignment/domain/bloc/view_assignment_bloc.dart';
import 'package:flutter_igl_cng/feature/lcv/assignment/viewAssignment/presntation/page/view_assignment_detail_page.dart';
import 'package:flutter_igl_cng/feature/lcv/assignment/viewAssignment/presntation/widget/view_assignment_item_box_widget.dart';
import 'package:flutter_igl_cng/utils/commonClass/fade_route.dart';
import 'package:flutter_igl_cng/utils/commonClass/user_info.dart';
import 'package:flutter_igl_cng/utils/commonWidgets/dotted_line_widget.dart';

class ViewAssignmentPage extends StatefulWidget {
  const ViewAssignmentPage({super.key});

  @override
  State<ViewAssignmentPage> createState() => _ViewAssignmentPageState();
}

class _ViewAssignmentPageState extends State<ViewAssignmentPage> {
  final LoginDataModel _userData = UserInfo.instance!.userData!;

  LoginDataModel get userData => _userData;

  @override
  void initState() {
    BlocProvider.of<ViewAssignmentBloc>(context)
        .add(ViewAssignmentPageLoadEvent(context: context));
    super.initState();
  }


  Widget _appBar() {
    return AppBar(
      backgroundColor: Colors.transparent,
      title: Align(
        alignment: Alignment.centerLeft,
        child: TextWidget(
          "Assignment",
          color: AppColor.white,
          fontSize: AppFont.font_15,
          fontWeight: FontWeight.w600,
        ),
      ),
      actions: [
        Image.asset(
          AppConfig.instanceInit()!.client == Client.iglcng
              ? AppIcon.appLogoIgl
              : AppIcon.appLogoIgl,
          height: MediaQuery.of(context).size.width * 0.13,
          width: MediaQuery.of(context).size.width * 0.13,
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    LoginDataModel userData = UserInfo.instance!.userData!;
    return userData.roleType == RoleType.stationUser ?
        Scaffold(
          body: appBackGround(
              context: context,
              child: Column(
                children: [
                  _appBar(),
                  DottedDividerLine(color: AppColor.white),
                  Expanded(child: _widgetBuilder()),
                ],
              )),
        ) : _widgetBuilder();
  }

  Widget _widgetBuilder() {
    return BlocBuilder<ViewAssignmentBloc, ViewAssignmentState>(
      builder: (context, state) {
        if (state is FetchViewAssignmentDataState) {
          return RefreshIndicator(
              onRefresh: _handleRefresh,
              child: _itemBuilder(dataState: state));
        } else {
          return const Center(
            child: CenterLoaderWidget(),
          );
        }
      },
    );
  }

  Future<void> _handleRefresh() async {
    await Future.delayed(const Duration(seconds: 1));
    BlocProvider.of<ViewAssignmentBloc>(!context.mounted ? context : context)
        .add(ViewAssignmentPageLoadEvent(context: !context.mounted ? context : context));
  }

  Widget _itemBuilder({required FetchViewAssignmentDataState dataState}) {
    return dataState.assignmentList.isNotEmpty
        ? ListView.builder(
            itemCount: dataState.assignmentList.length,
            shrinkWrap: true,
            itemBuilder: (context, index) {
              return GestureDetector(
                onTap: () {
                  BlocProvider.of<ViewAssignmentBloc>(context)
                      .add(ViewAssignmentSelectAssignmentEvent(assignmentData:  dataState.assignmentList[index]));
                  Navigator.push(
                    !context.mounted ? context : context,
                    FadeRoute(page: const ViewAssignmentDetailPage()),
                  );
                },
                child: ViewAssignmentItemBoxWidget(
                    index: index,
                    assignmentData: dataState.assignmentList[index]),
              );
            })
        : Center(
            child: InkWell(
              onTap: () {
                BlocProvider.of<ViewAssignmentBloc>(context)
                    .add(ViewAssignmentPageLoadEvent(context: context));
              },
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.refresh, color: AppColor.white,),
                  TextWidget(userData.roleType == RoleType.driver
                      ? "No History Found"
                      : "No Assignment Data",
                     color: AppColor.white,
                  ),
                ],
              ),
            ),
          );
  }
}
