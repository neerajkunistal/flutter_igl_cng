import 'package:flutter/material.dart';
import 'package:flutter_igl_cng/ExportFile/app_export_file.dart';
import 'package:flutter_igl_cng/feature/acknowledge/domain/model/aasign_type_model.dart';

class ComplaintAssignWidget extends StatefulWidget {
  final AcknowledgeModel acknowledgeData;

  const ComplaintAssignWidget({
    super.key,
    required this.acknowledgeData,
  });

  @override
  State<ComplaintAssignWidget> createState() => _ComplaintAssignWidgetState();
}

class _ComplaintAssignWidgetState extends State<ComplaintAssignWidget> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Align(
          alignment: Alignment.centerLeft,
          child: TextWidget(
            "Complaint Assign",
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
          )
        ],
      ),
      body: BlocBuilder<AcknowledgeBloc, AcknowledgeState>(
        builder: (context, state) {
          if (state is FetchAcknowledgeDataState) {
            return state.isUserLoader == false
                ? Container(
                    margin: EdgeInsets.all(
                        MediaQuery.of(context).size.width * 0.03),
                    color: Colors.transparent,
                    child: SingleChildScrollView(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisSize: MainAxisSize.max,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          SizedBox(
                            height: MediaQuery.of(context).size.width * 0.04,
                          ),
                          _assignTypeDropDown(
                              dataState: state, context: context),
                          SizedBox(
                            height: MediaQuery.of(context).size.width * 0.04,
                          ),
                          _departmentDropDown(
                              dataState: state, context: context),
                          state.assignTypeData.id == "2"
                              ? SizedBox(
                                  height:
                                      MediaQuery.of(context).size.width * 0.04,
                                )
                              : const SizedBox.shrink(),
                          _userDropDown(dataState: state, context: context),
                          SizedBox(
                            height: MediaQuery.of(context).size.width * 0.04,
                          ),
                          _vendorDropDown(dataState: state, context: context),
                          SizedBox(
                            height: MediaQuery.of(context).size.width * 0.04,
                          ),
                          Row(
                            children: [
                              Expanded(
                                  child: _dateController(dataState: state)),
                              SizedBox(
                                width: MediaQuery.of(context).size.width * 0.02,
                              ),
                              Expanded(
                                  child: _timeController(dataState: state)),
                            ],
                          ),
                          SizedBox(
                            height: MediaQuery.of(context).size.width * 0.04,
                          ),
                          _plannerTypeDropDown(dataState: state, context: context),
                          SizedBox(
                            height: MediaQuery.of(context).size.width * 0.04,
                          ),
                          _workCenterTypeDropDown(dataState: state, context: context),
                          SizedBox(
                            height: MediaQuery.of(context).size.width * 0.04,
                          ),
                          _personResponsibleController(dataState: state),
                          SizedBox(
                            height: MediaQuery.of(context).size.width * 0.04,
                          ),
                          _remarkController(dataState: state),
                          SizedBox(
                            height: MediaQuery.of(context).size.width * 0.04,
                          ),
                          _actionButton(dataState: state, context: context),
                        ],
                      ),
                    ))
                : const Center(
                    child: CenterLoaderWidget(),
                  );
          } else {
            return const Center(child: CenterLoaderWidget());
          }
        },
      ),
    );
  }

  Widget _assignTypeDropDown(
      {required FetchAcknowledgeDataState dataState,
      required BuildContext context}) {
    return DropdownWidget(
      hint: AppString.assignType,
      dropdownValue:
          dataState.assignTypeData.id != null ? dataState.assignTypeData : null,
      onChanged: (value) {
        BlocProvider.of<AcknowledgeBloc>(context)
            .add(AcknowledgeSelectAssignTypeEvent(assignTypeData: value));
      },
      items: dataState.assignTypeList.map<DropdownMenuItem<AssignTypeModel>>(
          (AssignTypeModel assignTypeData) {
        return DropdownMenuItem<AssignTypeModel>(
          value: assignTypeData,
          child: Text(assignTypeData.name.toString()),
        );
      }).toList(),
    );
  }

  Widget _departmentDropDown(
      {required FetchAcknowledgeDataState dataState,
      required BuildContext context}) {
    return DropdownWidget(
      hint: AppString.department,
      dropdownValue:
          dataState.departmentData.id != null ? dataState.departmentData : null,
      onChanged: (value) {
        BlocProvider.of<AcknowledgeBloc>(context)
            .add(AcknowledgeSelectDepartmentEvent(departmentData: value));
      },
      items: dataState.departmentList.map<DropdownMenuItem<DepartmentModel>>(
          (DepartmentModel departmentData) {
        return DropdownMenuItem<DepartmentModel>(
          value: departmentData,
          child: TextWidget(departmentData.name.toString()),
        );
      }).toList(),
    );
  }

  Widget _userDropDown(
      {required FetchAcknowledgeDataState dataState,
      required BuildContext context}) {
    return dataState.assignTypeData.id == "2"
        ? DropdownWidget(
            hint: AppString.assignUSer,
            dropdownValue: dataState.acknowledgeUserData.id != null
                ? dataState.acknowledgeUserData
                : null,
            onChanged: (value) {
              BlocProvider.of<AcknowledgeBloc>(context)
                  .add(AcknowledgeSelectUserEvent(acknowledgeUserData: value));
            },
            items: dataState.acknowledgeUserList
                .map<DropdownMenuItem<AcknowledgeUserModel>>(
                    (AcknowledgeUserModel acknowledgeUserData) {
              return DropdownMenuItem<AcknowledgeUserModel>(
                value: acknowledgeUserData,
                child: TextWidget(acknowledgeUserData.name.toString()),
              );
            }).toList(),
          )
        : const SizedBox.shrink();
  }

  Widget _dateController({required FetchAcknowledgeDataState dataState}) {
    return TextFieldWidget(
      enabled: false,
      isRequired: true,
      labelText: AppString.date,
      controller: dataState.closeDateController,
      onTap: () {
        BlocProvider.of<AcknowledgeBloc>(context)
            .add(AcknowledgeSelectClosedDateEvent(context: context));
      },
    );
  }

  Widget _timeController({required FetchAcknowledgeDataState dataState}) {
    return TextFieldWidget(
      enabled: false,
      isRequired: true,
      labelText: AppString.time,
      controller: dataState.closedTimeController,
      onTap: () {
        BlocProvider.of<AcknowledgeBloc>(context)
            .add(AcknowledgeSelectClosedTimeEvent(context: context));
      },
    );
  }

  Widget _vendorDropDown(
      {required FetchAcknowledgeDataState dataState,
      required BuildContext context}) {
    return dataState.assignTypeData.id == "3"
        ? DropDownSearchWidget(
            selectedItem:
                dataState.vendorData.id != null ? dataState.vendorData : null,
            hint: AppString.vendor,
            items: dataState.vendorList,
            itemAsString: (vendorData) =>
                "${vendorData.name.toString()}-(${vendorData.code.toString()})",
            onChanged: (value) {
              BlocProvider.of<AcknowledgeBloc>(context)
                  .add(AcknowledgeSelectVendorEvent(vendorData: value));
            },
          )
        : const SizedBox.shrink();
  }

  Widget _plannerTypeDropDown(
      {required FetchAcknowledgeDataState dataState,
        required BuildContext context}) {
    return DropDownSearchWidget(
      isRequired: true,
      selectedItem:
      dataState.plannerData.id != null ? dataState.plannerData : null,
      hint: AppString.plannerGroup,
      items: dataState.plannerList,
      itemAsString: (plannerData) => plannerData.plannerGroup.toString(),
      onChanged: (value) {
        BlocProvider.of<AcknowledgeBloc>(context)
            .add(AcknowledgeComplaintSelectedPlannerEvent(plannerData: value));
      },
    );
  }

  Widget _workCenterTypeDropDown(
      {required FetchAcknowledgeDataState dataState,
        required BuildContext context}) {
    return DropDownSearchWidget(
      isRequired: true,
      selectedItem:
      dataState.workCenterData.id != null ? dataState.workCenterData : null,
      hint: AppString.mainWorkCenter,
      items: dataState.workCenterList,
      itemAsString: (workCenterData) => workCenterData.workCenter.toString(),
      onChanged: (value) {
        BlocProvider.of<AcknowledgeBloc>(context)
            .add(AcknowledgeComplaintSelectedWorkCenterEvent(workCenterData: value));
      },
    );
  }

  Widget _personResponsibleController({required FetchAcknowledgeDataState dataState}) {
    return Padding(
      padding: const EdgeInsets.all(0.0),
      child: TextFieldWidget(
        labelText: AppString.personResponsible,
        controller: dataState.personResponsibleController,
      ),
    );
  }

  Widget _remarkController({required FetchAcknowledgeDataState dataState}) {
    return Padding(
      padding: const EdgeInsets.all(0.0),
      child: TextFieldWidget(
        labelText: AppString.workDescription,
        controller: dataState.remarkController,
      ),
    );
  }

  Widget _actionButton(
      {required FetchAcknowledgeDataState dataState,
      required BuildContext context}) {
    return dataState.isLoader == false
        ? ButtonWidget(
            text: AppString.assign,
            onPressed: () {
              BlocProvider.of<AcknowledgeBloc>(context).add(
                  AcknowledgeUserSubmitEvent(
                      context: context,
                      acknowledgeData: widget.acknowledgeData));
            })
        : const DottedLoaderWidget();
  }
}
