import 'package:flutter/material.dart';
import 'package:flutter_igl_cng/ExportFile/app_export_file.dart';
import 'package:flutter_igl_cng/feature/marketing/acknowledgeMarketing/presentation/widget/acknowledge_market_item_box_widget.dart';
import 'package:flutter_igl_cng/feature/marketing/addAcknowledgeMarket/addAcknowledgeMarketComplaint/domain/bloc/add_acknowledge_market_complaint_bloc.dart';
import 'package:flutter_igl_cng/feature/marketing/addAcknowledgeMarket/addAcknowledgeMarketComplaint/domain/model/vendor_model.dart';

class AddAcknowledgeMarketPage extends StatefulWidget {
  final int selectTabIndex;
  final EquipmentComplaintType equipmentComplaintType;

  const AddAcknowledgeMarketPage({
    super.key,
    required this.equipmentComplaintType,
    required this.selectTabIndex,
  });

  @override
  State<AddAcknowledgeMarketPage> createState() =>
      _AddAcknowledgeMarketPageState();
}

class _AddAcknowledgeMarketPageState extends State<AddAcknowledgeMarketPage> {
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
      body: BlocBuilder<AddAcknowledgeMarketComplaintBloc,
          AddAcknowledgeMarketComplaintState>(
        builder: (context, state) {
          if (state is FetchAddAcknowledgeMarketComplaintState) {
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

  Widget _itemWidget({required FetchAddAcknowledgeMarketComplaintState dataState}) {
    return Container(
      margin: const EdgeInsets.all(10),
      child: SingleChildScrollView(
        child: Column(
          children: [
            AcknowledgeMarketItemBoxWidget(
              acknowledgeData: dataState.acknowledgeData,
              index: 0,
              equipmentComplaintType: widget.equipmentComplaintType,
            ),
            _verticalSpace(),
            if (dataState.acknowledgeData.ackStatus.toString() == "0") ...[
              _complaintTypeDropDown(dataState: dataState),
            ],
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
            Row(
              children: [
                Expanded(child: _dateController(dataState: dataState)),
                SizedBox(
                  width: MediaQuery.of(context).size.width * 0.02,
                ),
                Expanded(child: _timeController(dataState: dataState)),
              ],
            ),

            _complaintStatusRadioButton(dataState: dataState),
            _verticalSpace(),
            if (dataState.complaintStatus == "1" && dataState.acknowledgeData.ackStatus.toString() == "0" &&  widget.equipmentComplaintType == EquipmentComplaintType.marketing) ...[
              widget.equipmentComplaintType == EquipmentComplaintType.marketing
                  ? _vendorTypeDropDown(dataState: dataState)
                  : const SizedBox.shrink(),
              widget.equipmentComplaintType == EquipmentComplaintType.marketing
                  ? _verticalSpace()
                  : const SizedBox.shrink(),
            ],
            // _remark(dataState: dataState),
            _descriptionRemark(dataState: dataState),
            _verticalSpace(),
            _verticalSpace(),

            dataState.acknowledgeData.ackStatus == "0"
                || widget.equipmentComplaintType == EquipmentComplaintType.marketing
                ? widget.selectTabIndex == 1 ? const SizedBox.shrink(): _button(dataState: dataState)
                : const SizedBox.shrink(),
          ],
        ),
      ),
    );
  }

  Widget _complaintTypeDropDown(
      {required FetchAddAcknowledgeMarketComplaintState dataState}) {
    return DropdownWidget(
      hint: AppString.editComplaintType,
      dropdownValue: dataState.complaintTypeData.id != null
          ? dataState.complaintTypeData
          : null,
      onChanged: dataState.acknowledgeData.ackStatus.toString() == "0"
          ? (value) {
              if (dataState.acknowledgeData.ackStatus.toString() == "0") {
                BlocProvider.of<AddAcknowledgeMarketComplaintBloc>(context).add(
                    AddAcknowledgeMarketComplaintSelectComplaintDataEvent(
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
      {required FetchAddAcknowledgeMarketComplaintState dataState}) {
    return DropdownWidget(
      hint: AppString.editEquipment,
      dropdownValue: dataState.equipmentTypeData.description != null
          ? dataState.equipmentTypeData
          : null,
      onChanged: dataState.acknowledgeData.ackStatus.toString() == "0"
          ? (value) {
              if (dataState.acknowledgeData.ackStatus.toString() == "0") {
                BlocProvider.of<AddAcknowledgeMarketComplaintBloc>(context).add(
                    AddAcknowledgeMarketComplaintSelectEquipmentDataEvent(
                        equipmentTypeData: value));
              }
            }
          : null,
      items: dataState.equipmentTypeList
          .map<DropdownMenuItem<EquipmentTypeModel>>(
              (EquipmentTypeModel equipmentTypeData) {
        return DropdownMenuItem<EquipmentTypeModel>(
          value: equipmentTypeData,
          child: Text(
            "${equipmentTypeData.descriptionKva.toString()} (${equipmentTypeData.equipmentCode.toString()})",
          ),
        );
      }).toList(),
    );
  }

  Widget _generalDropDown(
      {required FetchAddAcknowledgeMarketComplaintState dataState}) {
    return DropdownWidget(
      hint: AppString.selectGeneral,
      dropdownValue: dataState.generalComplaintData.name != null
          ? dataState.generalComplaintData
          : null,
      onChanged: dataState.acknowledgeData.ackStatus.toString() == "0"
          ? (value) {
              if (dataState.acknowledgeData.ackStatus.toString() == "0") {
                BlocProvider.of<AddAcknowledgeMarketComplaintBloc>(context).add(
                    AddAcknowledgeMarketComplaintSelectGeneralDataEvent(
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


  Widget _complaintStatusRadioButton(
      {required FetchAddAcknowledgeMarketComplaintState dataState}) {
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
                  BlocProvider.of<AddAcknowledgeMarketComplaintBloc>(context)
                      .add(AddAcknowledgeMarketComplaintSelectStatusData(
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
                  BlocProvider.of<AddAcknowledgeMarketComplaintBloc>(context)
                      .add(AddAcknowledgeMarketComplaintSelectStatusData(
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
      {required FetchAddAcknowledgeMarketComplaintState dataState}) {
    return TextFieldWidget(
      enabled: false,
      isRequired: true,
      labelText: "Edit Date",
      controller: dataState.dateController,
      onTap: () {
        if (dataState.acknowledgeData.ackStatus.toString() == "0") {
          BlocProvider.of<AddAcknowledgeMarketComplaintBloc>(context).add(
              AddAcknowledgeMarketComplaintSelectDateData(context: context));
        }
      },
    );
  }

  Widget _timeController({required FetchAddAcknowledgeMarketComplaintState dataState}) {
    return TextFieldWidget(
      enabled: false,
      isRequired: true,
      labelText: "Edit Time",
      controller: dataState.timeController,
      onTap: () {
        if (dataState.acknowledgeData.ackStatus.toString() == "0") {
          BlocProvider.of<AddAcknowledgeMarketComplaintBloc>(context).add(
              AddAcknowledgeMarketComplaintSelectTimeData(context: context));
        }
      },
    );
  }

  Widget _descriptionRemark({required FetchAddAcknowledgeMarketComplaintState dataState}) {
    return widget.equipmentComplaintType == EquipmentComplaintType.marketing
        ? TextFieldWidget(
            enabled: dataState.acknowledgeData.ackStatus.toString() == "0"
                ? true
                : false,
            labelText: AppString.editDescription,
            controller: dataState.descriptionController,
          )
        : _descriptionDropDown(dataState: dataState);
  }

  Widget _descriptionDropDown(
      {required FetchAddAcknowledgeMarketComplaintState dataState}) {
    return DropDownSearchWidget(
      isRequired: true,
      enabled:
          dataState.acknowledgeData.ackStatus.toString() == "0" ? true : false,
      selectedItem: dataState.complaintDescriptionData.description != null
          ? dataState.complaintDescriptionData
          : null,
      hint: AppString.selectDescription,
      items: dataState.complaintDescriptionList,
      itemAsString: (complaintDescriptionData) =>
          complaintDescriptionData.description.toString(),
      onChanged: dataState.acknowledgeData.ackStatus.toString() == "0"
          ? (value) {
              if (dataState.acknowledgeData.ackStatus.toString() == "0") {
                BlocProvider.of<AddAcknowledgeMarketComplaintBloc>(context).add(
                    AddAcknowledgeMarketComplaintSelectDescriptionDataEvent(
                        complaintDescriptionData: value));
              }
            }
          : null,
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
                    BlocProvider.of<AddAcknowledgeMarketComplaintBloc>(context)
                        .add(AddAcknowledgeMarketComplaintAddImageEvent(
                            context: context, mediaType: 1));
                    Navigator.pop(context);
                  },
                  child: TextWidget(
                    "Camera",
                    fontSize: AppFont.font_16,
                  )),
              const Divider(),
              TextButton(
                  onPressed: () {
                    BlocProvider.of<AddAcknowledgeMarketComplaintBloc>(context)
                        .add(AddAcknowledgeMarketComplaintAddImageEvent(
                            context: context, mediaType: 2));
                    Navigator.pop(context);
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

  Widget _button({required FetchAddAcknowledgeMarketComplaintState dataState}) {
    return dataState.isLoader == false
        ? ButtonWidget(
            text: AppString.submit,
            height:
                AppConfig.getDeviceType(context: context) == DeviceType.tablet
                    ? MediaQuery.of(context).size.height * 0.13
                    : null,
            onPressed: () {
              BlocProvider.of<AddAcknowledgeMarketComplaintBloc>(context).add(
                  AddAcknowledgeMarketComplaintSubmitEvent(context: context));
            })
        : const DottedLoaderWidget();
  }


  Widget _vendorTypeDropDown(
      {required FetchAddAcknowledgeMarketComplaintState dataState}) {
    return DropdownWidget(
      hint: AppString.vendor,
      dropdownValue: dataState.vendorMarketData.id != null
          ? dataState.vendorMarketData
          : null,
      onChanged: (value) {
        BlocProvider.of<AddAcknowledgeMarketComplaintBloc>(context).add(
            AddAcknowledgeMarketComplaintSelectVendorDataEvent(
                vendorMarketData: value));
      },
      items: dataState.listOfVendorMarketData
          .map<DropdownMenuItem<VendorMarketModel>>(
              (VendorMarketModel vendorType) {
        return DropdownMenuItem<VendorMarketModel>(
          value: vendorType,
          child: TextWidget(vendorType.vendorName.toString()),
        );
      }).toList(),
    );
  }

  Widget _verticalSpace() {
    return SizedBox(
      height: MediaQuery.of(context).size.height * 0.02,
    );
  }
}
