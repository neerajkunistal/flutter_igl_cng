import 'package:flutter/material.dart';
import 'package:flutter_igl_cng/ExportFile/app_export_file.dart';
import 'package:flutter_igl_cng/feature/lcv/assignment/viewAssignment/domain/bloc/view_assignment_bloc.dart';
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
    return BlocBuilder<ViewAssignmentBloc, ViewAssignmentState>(
      builder: (context, state) {
        if (state is FetchViewAssignmentDataState) {
          return _itemBuilder(dataState: state);
        } else {
          return const Center(
            child: CenterLoaderWidget(),
          );
        }
      },
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
