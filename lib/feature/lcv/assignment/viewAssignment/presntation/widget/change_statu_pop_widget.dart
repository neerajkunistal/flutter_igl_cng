import 'package:flutter/material.dart';
import 'package:flutter_igl_cng/ExportFile/app_export_file.dart';
import 'package:flutter_igl_cng/feature/lcv/assignment/viewAssignment/domain/bloc/view_assignment_bloc.dart';
import 'package:flutter_igl_cng/feature/lcv/assignment/viewAssignment/domain/model/assignment_change_status_model.dart';

class ChangeStatusPopWidget extends StatelessWidget {
  final int index;

  const ChangeStatusPopWidget({super.key, required this.index});

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: BlocBuilder<ViewAssignmentBloc, ViewAssignmentState>(
        builder: (context, state) {
          if (state is FetchViewAssignmentDataState) {
            return _itemBuilder(dataState: state, context: context);
          } else {
            return const Center(
              child: CenterLoaderWidget(),
            );
          }
        },
      ),
    );
  }

  Widget _itemBuilder(
      {required FetchViewAssignmentDataState dataState,
      required BuildContext context}) {
    return Center(
      child: Container(
        height: MediaQuery.of(context).size.height / 2.3,
        margin: EdgeInsets.all(MediaQuery.of(context).size.width * 0.03),
        child: Card(
          color: AppColor.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          child: Padding(
            padding: EdgeInsets.all(MediaQuery.of(context).size.width * 0.03),
            child: Column(
              children: [
                Align(
                    alignment: Alignment.centerRight,
                    child: IconButton(
                      icon: Icon(
                        Icons.close,
                        color: AppColor.grey,
                      ),
                      onPressed: () {
                        Navigator.pop(context);
                      },
                    )),
                SizedBox(
                  height: MediaQuery.of(context).size.width * 0.02,
                ),
                _statusDropDown(context: context, dataState: dataState),
                SizedBox(
                  height: MediaQuery.of(context).size.width * 0.03,
                ),
                _remarkTextField(dataState: dataState),
                SizedBox(
                  height: MediaQuery.of(context).size.width * 0.03,
                ),
                _submitButton(context: context, dataState: dataState),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _statusDropDown(
      {required BuildContext context,
      required FetchViewAssignmentDataState dataState}) {
    return DropdownWidget(
      hint: AppString.selectStatus,
      dropdownValue: dataState.assignmentChangeStatusData.id != null
          ? dataState.assignmentChangeStatusData
          : null,
      onChanged: (value) {
        BlocProvider.of<ViewAssignmentBloc>(context)
            .add(ViewAssignmentChangeStatusEvent(
          assignmentChangeStatusData: value,
        ));
      },
      items: dataState.assignmentChangeStatusList
          .map<DropdownMenuItem<AssignmentChangeStatusModel>>(
              (AssignmentChangeStatusModel assignmentChangeStatusData) {
        return DropdownMenuItem<AssignmentChangeStatusModel>(
          value: assignmentChangeStatusData,
          child: Text(assignmentChangeStatusData.status.toString()),
        );
      }).toList(),
    );
  }

  Widget _remarkTextField({required FetchViewAssignmentDataState dataState}) {
    return TextFieldWidget(
      isRequired: true,
      maxLine: 3,
      labelText: AppString.remark,
      controller: dataState.remarkController,
    );
  }

  Widget _submitButton(
      {required BuildContext context,
      required FetchViewAssignmentDataState dataState}) {
    return dataState.isLoader == false
        ? ButtonWidget(
            text: AppString.submit,
            onPressed: () {
              BlocProvider.of<ViewAssignmentBloc>(context).add(
                  ViewAssignmentUpdateStatusEvent(
                      index: index, context: context));
            })
        : const DottedLoaderWidget();
  }
}
