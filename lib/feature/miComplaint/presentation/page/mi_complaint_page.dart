import 'package:flutter/material.dart';
import 'package:flutter_igl_cng/ExportFile/app_export_file.dart';
import 'package:flutter_igl_cng/feature/miComplaint/domain/model/action_model.dart';
import 'package:flutter_igl_cng/feature/miComplaint/domain/model/spares_model.dart';
import 'package:flutter_igl_cng/feature/miComplaint/domain/model/uom_type_model.dart';
import 'package:flutter_igl_cng/feature/reviewComplaint/presentation/widget/review_complaint_item_box.dart';

class MiComplaintPage extends StatefulWidget {
  const MiComplaintPage({super.key});

  @override
  State<MiComplaintPage> createState() => _MiComplaintPageState();
}

class _MiComplaintPageState extends State<MiComplaintPage> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: TextWidget(
          "MI Complaint",
          color: AppColor.white,
        ),
      ),
      body: BlocBuilder<MiComplaintBloc, MiComplaintState>(
        builder: (context, state) {
          if (state is FetchMiComplaintDataState) {
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

  Widget _itemBuilder({required FetchMiComplaintDataState dataState}) {
    return Container(
      margin: const EdgeInsets.all(10),
      child: SingleChildScrollView(
        child: Column(
          children: [
            ReviewComplaintItemBox(
                reviewComplaintData: dataState.reviewComplaintData),
            _verticalSpace(),
            _amcStatusDate(dataState: dataState),
            _verticalSpace(),
            _actionDropDown(dataState: dataState),
            _verticalSpace(),
            dataState.actionData.id.toString() == "3"
                ? _sparesPartList(dataState: dataState)
                : const SizedBox.shrink(),
            dataState.actionData.id.toString() == "3"
                ? _verticalSpace()
                : const SizedBox.shrink(),
            dataState.actionData.id.toString() == "3"
                ? _addSparesPartButton(dataState: dataState)
                : const SizedBox.shrink(),
            dataState.actionData.id.toString() == "3"
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
            _verticalSpace(),
            _descriptionController(dataState: dataState),
            _verticalSpace(),
            _observationController(dataState: dataState),
            _verticalSpace(),
            _photo(dataState: dataState),
            _verticalSpace(),
            _verticalSpace(),
            _button(dataState: dataState),
          ],
        ),
      ),
    );
  }

  Widget _amcStatusDate({required FetchMiComplaintDataState dataState}) {
    return Card(
      shadowColor: AppColor.themeColor,
      elevation: 2,
      child: Padding(
        padding: const EdgeInsets.all(10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Row(
              children: [
                const TextWidget("AMC Status : "),
                TextWidget(dataState.reviewComplaintData.id != null
                    ? dataState.reviewComplaintData.amcStatus.toString()
                    : ""),
              ],
            ),
            SizedBox(
              height: MediaQuery.of(context).size.width * 0.02,
            ),
            Row(
              children: [
                const TextWidget("AMC Date : "),
                TextWidget(dataState.reviewComplaintData.id != null
                    ? dataState.reviewComplaintData.amcDate.toString()
                    : ""),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _complaintTypeDropDown(
      {required FetchMiComplaintDataState dataState}) {
    return DropdownWidget(
      hint: AppString.selectComplaint,
      dropdownValue: dataState.reviewComplaintData.id != null
          ? dataState.reviewComplaintData
          : null,
      onChanged: (value) {
        BlocProvider.of<MiComplaintBloc>(context)
            .add(MiComplaintSelectComplaintData(reviewComplaintData: value));
      },
      items: dataState.reviewComplaintList
          .map<DropdownMenuItem<ReviewComplaintModel>>(
              (ReviewComplaintModel reviewComplaintData) {
        return DropdownMenuItem<ReviewComplaintModel>(
          value: reviewComplaintData,
          child: Text(reviewComplaintData.complaintDescription.toString()),
        );
      }).toList(),
    );
  }

  Widget _sparesPartList({required FetchMiComplaintDataState dataState}) {
    return ListView.builder(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        itemCount: dataState.sparesPartList.length,
        itemBuilder: (context, index) {
          return Card(
            shadowColor: AppColor.themeColor,
            elevation: 2,
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                children: [
                  _sparesDropDown(
                      dataState: dataState,
                      sparesData: dataState.sparesPartList[index].sparesData!,
                      index: index),
                  _verticalSpace(),
                  // _uomDropDown(dataState: dataState,
                  //     uomTypeData: dataState.sparesPartList[index].uomTypeData!, index: index),
                  // _verticalSpace(),
                  _qtyController(
                    dataState: dataState,
                    index: index,
                    qtyController:
                        dataState.sparesPartList[index].qtyController!,
                    sparesData: dataState.sparesPartList[index].sparesData!,
                  ),
                  Align(
                    alignment: Alignment.topRight,
                    child: IconButton(
                        onPressed: () {
                          BlocProvider.of<MiComplaintBloc>(context).add(
                              MiComplaintDeleteSparesPartData(index: index));
                        },
                        icon: const Icon(Icons.delete_forever_outlined)),
                  ),
                ],
              ),
            ),
          );
        });
  }

  Widget _sparesDropDown(
      {required FetchMiComplaintDataState dataState,
      required SparesModel sparesData,
      required int index}) {
    return DropdownWidget(
      isRequired: false,
      hint: AppString.selectSpares,
      dropdownValue: sparesData.id != null ? sparesData : null,
      onChanged: (value) {
        BlocProvider.of<MiComplaintBloc>(context)
            .add(MiComplaintSelectSpareData(sparesData: value, index: index));
      },
      items: dataState.sparesList
          .map<DropdownMenuItem<SparesModel>>((SparesModel sparesData) {
        return DropdownMenuItem<SparesModel>(
          value: sparesData,
          child: Text(sparesData.spareName.toString()),
        );
      }).toList(),
    );
  }

  Widget _uomDropDown(
      {required FetchMiComplaintDataState dataState,
      required UomTypeModel uomTypeData,
      required int index}) {
    return DropdownWidget(
      hint: AppString.selectUOM,
      isRequired: false,
      dropdownValue: uomTypeData.id != null ? uomTypeData : null,
      onChanged: (value) {
        BlocProvider.of<MiComplaintBloc>(context)
            .add(MiComplaintSelectUomData(uomTypeData: value, index: index));
      },
      items: dataState.uomTypeList
          .map<DropdownMenuItem<UomTypeModel>>((UomTypeModel uomTypeData) {
        return DropdownMenuItem<UomTypeModel>(
          value: uomTypeData,
          child: Text(uomTypeData.uom.toString()),
        );
      }).toList(),
    );
  }

  Widget _qtyController(
      {required FetchMiComplaintDataState dataState,
      required int index,
      required TextEditingController qtyController,
      required SparesModel sparesData}) {
    return TextFieldWidget(
      textInputType: TextInputType.number,
      isRequired: false,
      labelText: sparesData.id != null
          ? sparesData.spareUom.toString()
          : AppString.qty,
      controller: qtyController,
    );
  }

  Widget _descriptionController(
      {required FetchMiComplaintDataState dataState}) {
    return TextFieldWidget(
      labelText: AppString.description,
      controller: dataState.descriptionController,
    );
  }

  Widget _actionDropDown({required FetchMiComplaintDataState dataState}) {
    return DropdownWidget(
      hint: AppString.selectAction,
      dropdownValue:
          dataState.actionData.id != null ? dataState.actionData : null,
      onChanged: (value) {
        BlocProvider.of<MiComplaintBloc>(context)
            .add(MiComplaintSelectActionData(actionData: value));
      },
      items: dataState.actionList
          .map<DropdownMenuItem<ActionModel>>((ActionModel actionData) {
        return DropdownMenuItem<ActionModel>(
          value: actionData,
          child: Text(actionData.value.toString()),
        );
      }).toList(),
    );
  }

  Widget _observationController(
      {required FetchMiComplaintDataState dataState}) {
    return TextFieldWidget(
      labelText: AppString.observation,
      controller: dataState.observationController,
    );
  }

  Widget _dateController({required FetchMiComplaintDataState dataState}) {
    return TextFieldWidget(
      enabled: false,
      isRequired: true,
      labelText: dataState.actionData.id.toString() == "1"
          ? AppString.startDate
          : dataState.actionData.id.toString() == "2"
              ? AppString.holdDate
              : dataState.actionData.id.toString() == "3"
                  ? AppString.closedDate
                  : AppString.date,
      controller: dataState.dateController,
      onTap: () {
        BlocProvider.of<MiComplaintBloc>(context)
            .add(MiComplaintSelectDateData(context: context));
      },
    );
  }

  Widget _timeController({required FetchMiComplaintDataState dataState}) {
    return TextFieldWidget(
      enabled: false,
      isRequired: true,
      labelText: dataState.actionData.id.toString() == "1"
          ? AppString.startTime
          : dataState.actionData.id.toString() == "2"
              ? AppString.holdTime
              : dataState.actionData.id.toString() == "3"
                  ? AppString.closedTime
                  : AppString.time,
      controller: dataState.timeController,
      onTap: () {
        BlocProvider.of<MiComplaintBloc>(context)
            .add(MiComplaintSelectTimeData(context: context));
      },
    );
  }

  Widget _photo({required FetchMiComplaintDataState dataState}) {
    return SizedBox(
      width: MediaQuery.of(context).size.width / 3,
      height: MediaQuery.of(context).size.width / 3,
      child: InkWell(
        onTap: () {
          mediaType(context: context);
        },
        child: DottedBorder(
          color: AppColor.grey,
          strokeWidth: 1,
          child: dataState.file.path.isEmpty
              ? Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Center(
                      child: Icon(Icons.photo_camera_back_outlined),
                    ),
                    Padding(
                      padding: EdgeInsets.all(
                          MediaQuery.of(context).size.width * 0.02),
                      child: TextWidget(
                        "Photo",
                        fontSize: AppFont.font_12,
                        color: AppColor.grey,
                      ),
                    ),
                  ],
                )
              : Stack(
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        dataState.file.path
                                    .toString()
                                    .toLowerCase()
                                    .contains(".jpg") ||
                                dataState.file.path
                                    .toString()
                                    .toLowerCase()
                                    .contains(".png") ||
                                dataState.file.path
                                    .toString()
                                    .toLowerCase()
                                    .contains(".jpeg")
                            ? Image.file(
                                dataState.file,
                                fit: BoxFit.fill,
                                width: MediaQuery.of(context).size.width / 3,
                                height: MediaQuery.of(context).size.width / 4.5,
                              )
                            : dataState.file.path
                                    .toString()
                                    .toLowerCase()
                                    .contains(".pdf")
                                ? const Icon(Icons.picture_as_pdf_outlined)
                                : const Icon(Icons.document_scanner_outlined),
                        dataState.file.path
                                .toString()
                                .toLowerCase()
                                .contains(".pdf")
                            ? TextWidget(
                                dataState.file.path.split('/').last.toString(),
                                color: AppColor.themeColor,
                                fontSize: AppFont.font_12,
                              )
                            : const SizedBox.shrink(),
                      ],
                    ),
                    Container(
                        width: MediaQuery.of(context).size.width / 3,
                        height: MediaQuery.of(context).size.width / 3,
                        color: Colors.white.withOpacity(0.6),
                        child: Center(
                            child: Icon(
                          Icons.refresh,
                          color: AppColor.themeColor,
                        ))),
                  ],
                ),
        ),
      ),
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
                    BlocProvider.of<MiComplaintBloc>(context).add(
                        MiComplaintAddImageEvent(
                            context: context, mediaType: 1));
                  },
                  child: TextWidget(
                    "Camera",
                    fontSize: AppFont.font_16,
                  )),
              const Divider(),
              TextButton(
                  onPressed: () {
                    BlocProvider.of<MiComplaintBloc>(context).add(
                        MiComplaintAddImageEvent(
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

  Widget _addSparesPartButton({required FetchMiComplaintDataState dataState}) {
    return Align(
      alignment: Alignment.topRight,
      child: SizedBox(
        width: MediaQuery.of(context).size.width / 2.5,
        child: ButtonWidget(
            text: AppString.addItem,
            height:
                AppConfig.getDeviceType(context: context) == DeviceType.tablet
                    ? MediaQuery.of(context).size.height * 0.13
                    : null,
            onPressed: () {
              BlocProvider.of<MiComplaintBloc>(context)
                  .add(MiComplaintAddSparesPartData(context: context));
            }),
      ),
    );
  }

  Widget _button({required FetchMiComplaintDataState dataState}) {
    return dataState.isLoader == false
        ? ButtonWidget(
            text: AppString.submit,
            height:
                AppConfig.getDeviceType(context: context) == DeviceType.tablet
                    ? MediaQuery.of(context).size.height * 0.13
                    : null,
            onPressed: () {
              BlocProvider.of<MiComplaintBloc>(context)
                  .add(MiComplaintSubmitData(context: context));
            })
        : const DottedLoaderWidget();
  }

  Widget _verticalSpace() {
    return SizedBox(
      height: MediaQuery.of(context).size.height * 0.02,
    );
  }
}
