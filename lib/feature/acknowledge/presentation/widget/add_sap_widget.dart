import 'package:flutter/material.dart';
import 'package:flutter_igl_cng/ExportFile/app_export_file.dart';

class AddSapWidget extends StatelessWidget {
  final FetchAddAcknowledgeComplaintState dataState;
  const AddSapWidget({super.key,
  required this.dataState,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        _verticalSpace(context: context),
        _departmentDropDown(dataState: dataState, context: context),
        _verticalSpace(context: context),
        _plannerTypeDropDown(dataState: dataState, context: context),
        _verticalSpace(context: context),
        _workCenterTypeDropDown(dataState: dataState, context: context),
        _verticalSpace(context: context),
        _personResponsibleController(dataState: dataState),
        _verticalSpace(context: context),
      ],
    );
  }

  Widget _departmentDropDown(
      {required FetchAddAcknowledgeComplaintState dataState,
        required BuildContext context}) {
    return DropdownWidget(
      isRequired: true,
      hint: AppString.department,
      dropdownValue:
      dataState.departmentData.id != null ? dataState.departmentData : null,
      onChanged: dataState.acknowledgeData.ackStatus.toString() == "0"
          ? (value) {
        if (dataState.acknowledgeData.ackStatus.toString() == "0") {
          BlocProvider.of<AddAcknowledgeComplaintBloc>(context)
              .add(AddAcknowledgeComplaintSelectDepartmentEvent(departmentData: value));
        }
      } : null,
      items: dataState.departmentList.map<DropdownMenuItem<DepartmentModel>>(
              (DepartmentModel departmentData) {
            return DropdownMenuItem<DepartmentModel>(
              value: departmentData,
              child: TextWidget(departmentData.name.toString()),
            );
          }).toList(),
    );
  }

  Widget _plannerTypeDropDown(
      {required FetchAddAcknowledgeComplaintState dataState,
        required BuildContext context}) {
    return DropDownSearchWidget(
      isRequired: true,
      enabled: dataState.acknowledgeData.ackStatus.toString() == "0" ? true : false,
      selectedItem:
      dataState.plannerData.id != null ? dataState.plannerData : null,
      hint: AppString.plannerGroup,
      items: dataState.plannerList,
      itemAsString: (plannerData) => plannerData.plannerGroup.toString(),
      onChanged: dataState.acknowledgeData.ackStatus.toString() == "0"
          ? (value) {
        if (dataState.acknowledgeData.ackStatus.toString() == "0") {
          BlocProvider.of<AddAcknowledgeComplaintBloc>(context)
              .add(AddAcknowledgeComplaintSelectedPlannerEvent(plannerData: value));
        }
      } : null,
    );
  }

  Widget _workCenterTypeDropDown(
      {required FetchAddAcknowledgeComplaintState dataState,
        required BuildContext context}) {
    return DropDownSearchWidget(
      isRequired: true,
      enabled: dataState.acknowledgeData.ackStatus.toString() == "0" ? true : false,
      selectedItem:
      dataState.workCenterData.id != null ? dataState.workCenterData : null,
      hint: AppString.mainWorkCenter,
      items: dataState.workCenterList,
      itemAsString: (workCenterData) => workCenterData.workCenter.toString(),
      onChanged: dataState.acknowledgeData.ackStatus.toString() == "0"
          ? (value) {
        if (dataState.acknowledgeData.ackStatus.toString() == "0") {
          BlocProvider.of<AddAcknowledgeComplaintBloc>(context)
              .add(AddAcknowledgeComplaintSelectedWorkCenterEvent(workCenterData: value));
        }
      } : null,
    );
  }

  Widget _personResponsibleController({required FetchAddAcknowledgeComplaintState dataState}) {
    return Padding(
      padding: const EdgeInsets.all(0.0),
      child: TextFieldWidget(
        isRequired: true,
        enabled: dataState.acknowledgeData.ackStatus.toString() == "0" ? true : false,
        labelText: AppString.personResponsible,
        controller: dataState.personResponsibleController,
      ),
    );
  }


  Widget _verticalSpace({required BuildContext context}) {
    return SizedBox(
      height: MediaQuery.of(context).size.width * 0.04,
    );
  }
}
