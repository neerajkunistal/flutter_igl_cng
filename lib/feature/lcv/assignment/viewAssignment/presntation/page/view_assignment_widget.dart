import 'package:flutter/material.dart';
import 'package:flutter_igl_cng/ExportFile/app_export_file.dart';
import 'package:flutter_igl_cng/feature/lcv/assignment/addAssignment/presentation/page/add_assignment_page.dart';
import 'package:flutter_igl_cng/feature/lcv/assignment/viewAssignment/domain/bloc/view_assignment_bloc.dart';
import 'package:flutter_igl_cng/feature/lcv/assignment/viewAssignment/presntation/widget/view_assignment_filter_widget.dart';
import 'package:flutter_igl_cng/feature/lcv/assignment/viewAssignment/presntation/widget/view_assignment_item_box_widget.dart';
import 'package:flutter_igl_cng/utils/commonClass/user_info.dart';

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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0.0,
        title: TextWidget(
          userData.roleType == RoleType.driver
              ? AppString.history
              : AppString.assignmentList,
          color: AppColor.white,
          fontSize: AppFont.font_16,
        ),
        actions: [
          userData.roleType == RoleType.admin ||
                  userData.roleType == RoleType.manager ||
                  userData.roleType == RoleType.cngStation
              ? IconButton(
                  onPressed: () {
                    Navigator.of(context).push(MaterialPageRoute(
                        builder: (context) => const AddAssignmentPage()));
                  },
                  icon: Icon(
                    Icons.add,
                    color: AppColor.white,
                  ))
              : const SizedBox.shrink(),
          Padding(
              padding: EdgeInsets.only(right: 20.0),
              child: GestureDetector(
                child: Icon(
                  Icons.sort,
                  size: 26.0,
                  color: Colors.white,
                ),
                onTap: () async {
                  ViewAssignmentFilterWidget(context: context).filterSearch();
                },
              )),
        ],
      ),
      body: BlocBuilder<ViewAssignmentBloc, ViewAssignmentState>(
        builder: (context, state) {
          if (state is FetchViewAssignmentDataState) {
            return _itemBuilder(dataState: state);
          } else {
            return const Center(
              child: CenterLoaderWidget(),
            );
          }
        },
      ),
    );
  }

  Widget _itemBuilder({required FetchViewAssignmentDataState dataState}) {
    return dataState.assignmentList.isNotEmpty
        ? ListView.builder(
            itemCount: dataState.assignmentList.length,
            shrinkWrap: true,
            itemBuilder: (context, index) {
              return ViewAssignmentItemBoxWidget(
                  index: index,
                  assignmentData: dataState.assignmentList[index]);
            })
        : Center(
            child: TextWidget(userData.roleType == RoleType.driver
                ? "No History Found"
                : "No Assignment Data"),
          );
  }
}
