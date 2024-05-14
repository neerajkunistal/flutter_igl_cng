import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_igl_cng/ExportFile/app_export_file.dart';
import 'package:flutter_igl_cng/feature/acknowledge/domain/model/aasign_type_model.dart';
import 'package:flutter_igl_cng/feature/acknowledge/domain/model/vendor_model.dart';

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
        title: TextWidget(
          "Complaint Assign",
          color: AppColor.white,
        ),
      ),
      body: BlocBuilder<AcknowledgeBloc, AcknowledgeState>(
        builder: (context, state) {
          if (state is FetchAcknowledgeDataState) {
            return state.isUserLoader == false
                ? Container(
                    margin: EdgeInsets.all(MediaQuery.of(context).size.width * 0.03),
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
                          _assignTypeDropDown(dataState: state, context: context),
                          SizedBox(
                            height: MediaQuery.of(context).size.width * 0.04,
                          ),
                          _userDropDown(dataState: state, context: context),
                          _vendorDropDown(dataState: state, context: context),
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
                : const Center(child: CenterLoaderWidget(),);
          } else {
            return const Center(child: CenterLoaderWidget());
          }
        },
      ),
    );
  }

  Widget _closeButton({required BuildContext context}) {
    return Row(
      children: [
        Expanded(
          flex: 1,
          child: Padding(
            padding: EdgeInsets.only(
              left: MediaQuery.of(context).size.width * 0.05,
              right: MediaQuery.of(context).size.width * 0.05,
              top: MediaQuery.of(context).size.width * 0.05,
            ),
            child: TextWidget(
              "Complaint Assign",
              fontSize: AppFont.font_16,
              fontWeight: FontWeight.w700,
              textAlign: TextAlign.center,
              color: AppColor.black,
            ),
          ),
        ),
      ],
    );
  }

  Widget _assignTypeDropDown(
      {required FetchAcknowledgeDataState dataState,
        required BuildContext context}) {
    return DropdownWidget(
      hint: AppString.assignType,
      dropdownValue: dataState.assignTypeData.id != null
          ? dataState.assignTypeData
          : null,
      onChanged: (value) {
        BlocProvider.of<AcknowledgeBloc>(context)
            .add(AcknowledgeSelectAssignTypeEvent(assignTypeData: value));
      },
      items: dataState.assignTypeList
          .map<DropdownMenuItem<AssignTypeModel>>(
              (AssignTypeModel assignTypeData) {
            return DropdownMenuItem<AssignTypeModel>(
              value: assignTypeData,
              child: Text(assignTypeData.name.toString()),
            );
          }).toList(),
    );
  }

  Widget _userDropDown(
      {required FetchAcknowledgeDataState dataState,
      required BuildContext context}) {
    return dataState.assignTypeData.id == "2" ?
    DropdownWidget(
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
    ): const SizedBox.shrink();
  }

  Widget _vendorDropDown(
      {required FetchAcknowledgeDataState dataState,
        required BuildContext context}) {
    return dataState.assignTypeData.id == "3" ?
    DropdownWidget(
      hint: AppString.vendor,
      dropdownValue: dataState.vendorData.id != null
          ? dataState.vendorData
          : null,
      onChanged: (value) {
        BlocProvider.of<AcknowledgeBloc>(context)
            .add(AcknowledgeSelectVendorEvent(vendorData: value));
      },
      items: dataState.vendorList
          .map<DropdownMenuItem<VendorModel>>(
              (VendorModel vendorData) {
            return DropdownMenuItem<VendorModel>(
              value: vendorData,
              child: TextWidget("${vendorData.name.toString()}-(${vendorData.code.toString()})"),
            );
          }).toList(),
    ): const SizedBox.shrink();
  }

  Widget _remarkController({required FetchAcknowledgeDataState dataState}) {
    return Padding(
      padding: const EdgeInsets.all(0.0),
      child: TextFieldWidget(
        labelText: AppString.remark,
        controller: dataState.remarkController,
      ),
    );
  }

  Widget _actionButton(
      {required FetchAcknowledgeDataState dataState,
      required BuildContext context}) {
    return dataState.isLoader == false ?
    ButtonWidget(text: AppString.assign,
        onPressed: () {
         BlocProvider.of<AcknowledgeBloc>(context).add(
             AcknowledgeUserSubmitEvent(context: context, acknowledgeData: widget.acknowledgeData));
        }): const DottedLoaderWidget();
  }
}
