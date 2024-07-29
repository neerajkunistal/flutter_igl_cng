import 'package:flutter/material.dart';
import 'package:flutter_igl_cng/ExportFile/app_export_file.dart';

class AddAcknowledgePage extends StatefulWidget {
  const AddAcknowledgePage({super.key});

  @override
  State<AddAcknowledgePage> createState() => _AddAcknowledgePageState();
}

class _AddAcknowledgePageState extends State<AddAcknowledgePage> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: TextWidget(
          "Update Acknowledge",
          color: AppColor.white,
        ),
      ),
      body: BlocBuilder<AddAcknowledgeComplaintBloc,
          AddAcknowledgeComplaintState>(
        builder: (context, state) {
          if (state is FetchAddAcknowledgeComplaintState) {
            return _itemWidget(dataState: state);
          } else {
            return const Center(
              child: CenterLoaderWidget(),
            );
          }
        },
      ),
    );
  }

  Widget _itemWidget({required FetchAddAcknowledgeComplaintState dataState}) {
    return Container(
      margin: const EdgeInsets.all(10),
      child: SingleChildScrollView(
        child: Column(
          children: [
            AcknowledgeItemBoxWidget(
                acknowledgeData: dataState.acknowledgeData, index: 0),
            _verticalSpace(),
            _complaintTypeDropDown(dataState: dataState),
            _verticalSpace(),
            dataState.complaintTypeData.id.toString() == "2"
                ? _equipmentDropDown(dataState: dataState)
                : const SizedBox.shrink(),
            dataState.complaintTypeData.id.toString() == "2"
                ? _verticalSpace()
                : const SizedBox.shrink(),
            dataState.complaintTypeData.id.toString() == "1"
                ? _generalDropDown(dataState: dataState)
                : const SizedBox.shrink(),
            dataState.complaintTypeData.id.toString() == "1"
                ? _verticalSpace()
                : const SizedBox.shrink(),

/*            dataState.generalComplaintData.name != null &&
                    dataState.generalComplaintData.name
                            .toString()
                            .toLowerCase() ==
                        "others"
                ? _generalDescriptionController(dataState: dataState)
                : const SizedBox.shrink(),

            dataState.generalComplaintData.name != null &&
                    dataState.generalComplaintData.name
                            .toString()
                            .toLowerCase() ==
                        "others"
                ? _verticalSpace()
                : const SizedBox.shrink(),*/

            Row(
              children: [
                Expanded(child: _dateController(dataState: dataState)),
                SizedBox(
                  width: MediaQuery.of(context).size.width * 0.02,
                ),
                Expanded(child: _timeController(dataState: dataState)),
              ],
            ),
            _verticalSpace(),
            _descriptionRemark(dataState: dataState),
            _radioButton(dataState: dataState),
            _verticalSpace(),
            _complaintStatusRadioButton(dataState: dataState),
            _verticalSpace(),
            _remark(dataState: dataState),
            _verticalSpace(),
            _verticalSpace(),
            dataState.acknowledgeData.ackStatus == "0"
                ? _button(dataState: dataState)
                : const SizedBox.shrink(),
          ],
        ),
      ),
    );
  }

  Widget _complaintTypeDropDown(
      {required FetchAddAcknowledgeComplaintState dataState}) {
    return DropdownWidget(
      hint: AppString.editComplaintType,
      dropdownValue: dataState.complaintTypeData.id != null
          ? dataState.complaintTypeData
          : null,
      onChanged: dataState.acknowledgeData.ackStatus.toString() == "0"
          ? (value) {
              if (dataState.acknowledgeData.ackStatus.toString() == "0") {
                BlocProvider.of<AddAcknowledgeComplaintBloc>(context).add(
                    AddAcknowledgeComplaintSelectComplaintDataEvent(
                        complaintTypeData: value));
              }
            }
          : null,
      items: dataState.complaintTypeList
          .map<DropdownMenuItem<ComplaintTypeModel>>(
              (ComplaintTypeModel complaintTypeData) {
        return DropdownMenuItem<ComplaintTypeModel>(
          value: complaintTypeData,
          child: TextWidget(complaintTypeData.alias.toString()),
        );
      }).toList(),
    );
  }

  Widget _equipmentDropDown(
      {required FetchAddAcknowledgeComplaintState dataState}) {
    return DropdownWidget(
      hint: AppString.editEquipment,
      dropdownValue: dataState.equipmentTypeData.description != null
          ? dataState.equipmentTypeData
          : null,
      onChanged: dataState.acknowledgeData.ackStatus.toString() == "0"
          ? (value) {
              if (dataState.acknowledgeData.ackStatus.toString() == "0") {
                BlocProvider.of<AddAcknowledgeComplaintBloc>(context).add(
                    AddAcknowledgeComplaintSelectEquipmentDataEvent(
                        equipmentTypeData: value));
              }
            }
          : null,
      items: dataState.equipmentTypeList
          .map<DropdownMenuItem<EquipmentTypeModel>>(
              (EquipmentTypeModel equipmentTypeData) {
        return DropdownMenuItem<EquipmentTypeModel>(
          value: equipmentTypeData,
          child: Text("${equipmentTypeData.descriptionKva.toString()} (${equipmentTypeData.equipmentCode.toString()})",),
        );
      }).toList(),
    );
  }

  Widget _generalDropDown(
      {required FetchAddAcknowledgeComplaintState dataState}) {
    return DropdownWidget(
      hint: AppString.selectGeneral,
      dropdownValue: dataState.generalComplaintData.name != null
          ? dataState.generalComplaintData
          : null,
      onChanged: dataState.acknowledgeData.ackStatus.toString() == "0"
          ? (value) {
              if (dataState.acknowledgeData.ackStatus.toString() == "0") {
                BlocProvider.of<AddAcknowledgeComplaintBloc>(context).add(
                    AddAcknowledgeComplaintSelectGeneralDataEvent(
                        generalComplaintData: value));
              }
            }
          : null,
      items: dataState.generalComplaintList
          .map<DropdownMenuItem<GeneralComplaintModel>>(
              (GeneralComplaintModel generalComplaintData) {
        return DropdownMenuItem<GeneralComplaintModel>(
          value: generalComplaintData,
          child: Text(generalComplaintData.name.toString()),
        );
      }).toList(),
    );
  }

  Widget _radioButton({required FetchAddAcknowledgeComplaintState dataState}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        Row(
          children: [
            Radio(
              value: "1",
              groupValue: dataState.breakDownvalue,
              onChanged: (val) {
                if (dataState.acknowledgeData.ackStatus.toString() == "0") {
                  BlocProvider.of<AddAcknowledgeComplaintBloc>(context).add(
                      AddAcknowledgeComplaintSelectBreakDownEvent(
                          breakeDown: val.toString()));
                }
              },
            ),
            const TextWidget("Breakdown"),
          ],
        ),
        Row(
          children: [
            Radio(
              value: "2",
              groupValue: dataState.breakDownvalue,
              onChanged: (val) {
                if (dataState.acknowledgeData.ackStatus.toString() == "0") {
                  BlocProvider.of<AddAcknowledgeComplaintBloc>(context).add(
                      AddAcknowledgeComplaintSelectBreakDownEvent(
                          breakeDown: val.toString()));
                }
              },
            ),
            const TextWidget("No Breakdown"),
          ],
        ),
      ],
    );
  }

  Widget _complaintStatusRadioButton(
      {required FetchAddAcknowledgeComplaintState dataState}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        const TextWidget("Status*"),
        Row(
          children: [
            Radio(
              value: "1",
              groupValue: dataState.complaintStatus,
              onChanged: (val) {
                if (dataState.acknowledgeData.ackStatus.toString() == "0") {
                  BlocProvider.of<AddAcknowledgeComplaintBloc>(context).add(
                      AddAcknowledgeComplaintSelectStatusData(
                          complaintStatus: val.toString()));
                }
              },
            ),
            const TextWidget("Acknowledge"),
          ],
        ),
        Row(
          children: [
            Radio(
              value: "0",
              groupValue: dataState.complaintStatus,
              onChanged: (val) {
                if (dataState.acknowledgeData.ackStatus.toString() == "0") {
                  BlocProvider.of<AddAcknowledgeComplaintBloc>(context).add(
                      AddAcknowledgeComplaintSelectStatusData(
                          complaintStatus: val.toString()));
                }
              },
            ),
            const TextWidget("Not Acknowledge"),
          ],
        ),
      ],
    );
  }


  Widget _dateController(
      {required FetchAddAcknowledgeComplaintState dataState}) {
    return TextFieldWidget(
      enabled: false,
      isRequired: true,
      labelText: "Edit Date",
      controller: dataState.dateController,
      onTap: () {
        if (dataState.acknowledgeData.ackStatus.toString() == "0") {
          BlocProvider.of<AddAcknowledgeComplaintBloc>(context)
              .add(AddAcknowledgeComplaintSelectDateData(context: context));
        }
      },
    );
  }

  Widget _timeController(
      {required FetchAddAcknowledgeComplaintState dataState}) {
    return TextFieldWidget(
      enabled: false,
      isRequired: true,
      labelText: "Edit Time",
      controller: dataState.timeController,
      onTap: () {
        if (dataState.acknowledgeData.ackStatus.toString() == "0") {
          BlocProvider.of<AddAcknowledgeComplaintBloc>(context)
              .add(AddAcknowledgeComplaintSelectTimeData(context: context));
        }
      },
    );
  }

  Widget _descriptionRemark(
      {required FetchAddAcknowledgeComplaintState dataState}) {
    return TextFieldWidget(
      enabled:
          dataState.acknowledgeData.ackStatus.toString() == "0" ? true : false,
      labelText: AppString.editDescription,
      controller: dataState.descriptionController,
    );
  }

  Widget _remark({required FetchAddAcknowledgeComplaintState dataState}) {
    return TextFieldWidget(
      isRequired: dataState.complaintStatus.toString() == "0" ? true : false,
      enabled:
          dataState.acknowledgeData.ackStatus.toString() == "0" ? true : false,
      labelText: AppString.remark,
      controller: dataState.remarkController,
    );
  }

  void mediaType({required BuildContext context}) {
    showModalBottomSheet(
      context: context, // Also default
      builder: (context) {
        return Container(
          height: MediaQuery.of(context).size.height * 0.18,
          margin: const EdgeInsets.all(10),
          child: Column(
            children: [
              TextButton(
                  onPressed: () {
                    BlocProvider.of<AddAcknowledgeComplaintBloc>(context).add(
                        AddAcknowledgeComplaintAddImageEvent(
                            context: context, mediaType: 1));
                  },
                  child: TextWidget(
                    "Camera",
                    fontSize: AppFont.font_16,
                  )),
              const Divider(),
              TextButton(
                  onPressed: () {
                    BlocProvider.of<AddAcknowledgeComplaintBloc>(context).add(
                        AddAcknowledgeComplaintAddImageEvent(
                            context: context, mediaType: 2));
                  },
                  child: TextWidget(
                    "Gallery",
                    fontSize: AppFont.font_16,
                  )),
            ],
          ),
        );
      },
    );
  }

  Widget _button({required FetchAddAcknowledgeComplaintState dataState}) {
    return dataState.isLoader == false
        ? ButtonWidget(
            text: AppString.submit,
            height:
                AppConfig.getDeviceType(context: context) == DeviceType.tablet
                    ? MediaQuery.of(context).size.height * 0.13
                    : null,
            onPressed: () {
              BlocProvider.of<AddAcknowledgeComplaintBloc>(context)
                  .add(AddAcknowledgeComplaintSubmitEvent(context: context));
            })
        : const DottedLoaderWidget();
  }

  Widget _verticalSpace() {
    return SizedBox(
      height: MediaQuery.of(context).size.height * 0.02,
    );
  }
}
