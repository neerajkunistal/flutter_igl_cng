import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_igl_cng/ExportFile/app_export_file.dart';
import 'package:flutter_igl_cng/feature/lcv/assignment/addAssignment/domain/bloc/add_assignment_bloc.dart';
import 'package:flutter_igl_cng/feature/lcv/assignment/addAssignment/domain/model/station_model.dart';
import 'package:flutter_igl_cng/feature/lcv/request/domain/model/cng_station_route_model.dart';

class AddAssignmentPage extends StatefulWidget {
  const AddAssignmentPage({super.key});

  @override
  State<AddAssignmentPage> createState() => _AddAssignmentPageState();
}

class _AddAssignmentPageState extends State<AddAssignmentPage> {
  @override
  void initState() {
    BlocProvider.of<AddAssignmentBloc>(context)
        .add(AddAssignmentPageLoadEvent(context: context));
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AddAssignmentBloc, AddAssignmentState>(
      builder: (context, state) {
        if (state is FetchAddAssignmentDataState) {
          return _itemBuilder(dataState: state);
        } else {
          return const Center(
            child: CenterLoaderWidget(),
          );
        }
      },
    );
  }

  Widget _itemBuilder({required FetchAddAssignmentDataState dataState}) {
    return Container(
      color: AppColor.white,
      padding: EdgeInsets.all(MediaQuery.of(context).size.width * 0.03),
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(
              height: MediaQuery.of(context).size.height * 0.02,
            ),
            _motherStationDropDown(dataState: dataState),
            SizedBox(
              height: MediaQuery.of(context).size.height * 0.02,
            ),
            _driverDropDown(dataState: dataState),
            SizedBox(
              height: MediaQuery.of(context).size.height * 0.02,
            ),
            _lcvTrack(dataState: dataState),
            SizedBox(
              height: MediaQuery.of(context).size.height * 0.02,
            ),
            _cngStationDropdown(dataState: dataState),
            SizedBox(
              height: MediaQuery.of(context).size.height * 0.02,
            ),
            _lcvEntryTimeController(dataState: dataState),
            SizedBox(
              height: MediaQuery.of(context).size.height * 0.02,
            ),
            _fillStartTimeController(dataState: dataState),
            SizedBox(
              height: MediaQuery.of(context).size.height * 0.02,
            ),
            _flowMeterReadingOpenController(dataState: dataState),
            SizedBox(
              height: MediaQuery.of(context).size.height * 0.02,
            ),
            _flowMeterReadingClosedController(dataState: dataState),
            SizedBox(
              height: MediaQuery.of(context).size.height * 0.02,
            ),
            _fillEndTimeController(dataState: dataState),
            SizedBox(
              height: MediaQuery.of(context).size.height * 0.02,
            ),
            _outPressureController(dataState: dataState),
            SizedBox(
              height: MediaQuery.of(context).size.height * 0.02,
            ),

/*            _cngStationRoueDropdown(dataState: dataState),
            _cngQuantityTextField(dataState: dataState),
            dataState.stationList.isNotEmpty
                ? _cngStationList(dataState: dataState)
                : const SizedBox.shrink(),*/
        /*          SizedBox(
              height: MediaQuery.of(context).size.height * 0.03,
            ),
            _scheduleDateTimeTextField(dataState: dataState),
            SizedBox(
              height: MediaQuery.of(context).size.height * 0.03,
            ),
            _totalCngQuantityField(dataState: dataState),*/
            SizedBox(
              height: MediaQuery.of(context).size.height * 0.02,
            ),
            TextWidget(AppString.checklist, fontWeight: FontWeight.w700,),
            SizedBox(
              height: MediaQuery.of(context).size.height * 0.02,
            ),
            _lcvCondition(dataState: dataState),
            _driverFitToDrive(dataState: dataState),
            _improperLCVLogBooKCorrections(dataState: dataState),
            _availabilityOfMobilWithDriver(dataState: dataState),
            SizedBox(
              height: MediaQuery.of(context).size.height * 0.04,
            ),
            _unscheduledMaintenancePenaltyHoursController(dataState: dataState),
            SizedBox(
              height: MediaQuery.of(context).size.height * 0.04,
            ),
            _scheduledMaintenancePenaltyHoursController(dataState: dataState),
            SizedBox(
              height: MediaQuery.of(context).size.height * 0.04,
            ),
            Align(
                alignment: Alignment.centerLeft,
                child: _photo(dataState: dataState, index: 0, file: File(""), context: context)),
            _verticalSpace(),
            _imageList(dataState: dataState),
            _verticalSpace(),
            _submitButton(dataState: dataState),
            SizedBox(
              height: MediaQuery.of(context).size.height * 0.04,
            ),
          ],
        ),
      ),
    );
  }

  Widget _motherStationDropDown({required FetchAddAssignmentDataState dataState}) {
    return DropDownSearchWidget(
      selectedItem:
      dataState.motherStationData.id != null ? dataState.motherStationData : null,
      hint: AppString.selectMotherStation,
      items: dataState.motherStationList,
      itemAsString: (motherStationData) => motherStationData.stationName.toString(),
      onChanged: (value) {
        BlocProvider.of<AddAssignmentBloc>(context)
            .add(AddAssignmentSetMotherStationDataEvent(
          motherStationData: value,
        ));
      },
    );
  }

  Widget _driverDropDown({required FetchAddAssignmentDataState dataState}) {
    return DropDownSearchWidget(
      selectedItem:
          dataState.driverData.id != null ? dataState.driverData : null,
      hint: AppString.selectDriver,
      items: dataState.driverList,
      itemAsString: (driverData) => driverData.driverName.toString(),
      onChanged: (value) {
        BlocProvider.of<AddAssignmentBloc>(context)
            .add(AddAssignmentSetDriverDataEvent(
          driverData: value,
        ));
      },
    );
  }

  Widget _lcvTrack({required FetchAddAssignmentDataState dataState}) {
    return DropDownSearchWidget(
      selectedItem:
          dataState.lcvData.id != null ? dataState.lcvData : null,
      hint: AppString.selectLCVTruck,
      items: dataState.lcvList,
      itemAsString: (lcvData) => lcvData.vehicleNo.toString(),
      onChanged: (value) {
        BlocProvider.of<AddAssignmentBloc>(context)
            .add(AddAssignmentSetLcvTrackDataEvent(
          lcvData: value,
        ));
      },
    );
  }

  Widget _lcvEntryTimeController(
      {required FetchAddAssignmentDataState dataState}) {
    return TextFieldWidget(
      onTap: () {
        BlocProvider.of<AddAssignmentBloc>(context).add(
            AddAssignmentSelectLcvEntryTimeEvent(context: context));
      },
      enabled: false,
      controller: dataState.lcvEntryTimeController,
      isRequired: true,
      textInputType: TextInputType.text,
      labelText: AppString.lcvEntryTime,
    );
  }

  Widget _fillStartTimeController(
      {required FetchAddAssignmentDataState dataState}) {
    return TextFieldWidget(
      onTap: () {
        BlocProvider.of<AddAssignmentBloc>(context).add(
            AddAssignmentSelectFillStartTimeEvent(context: context));
      },
      enabled: false,
      controller: dataState.fillStartTimeController,
      isRequired: true,
      textInputType: TextInputType.text,
      labelText: AppString.fillStartTime,
    );
  }

  Widget _fillEndTimeController(
      {required FetchAddAssignmentDataState dataState}) {
    return TextFieldWidget(
      onTap: () {
        BlocProvider.of<AddAssignmentBloc>(context).add(
            AddAssignmentSelectFillEndTimeEvent(context: context));
      },
      enabled: false,
      controller: dataState.fillEndTimeController,
      isRequired: true,
      textInputType: TextInputType.number,
      labelText: AppString.fillEndTime,
    );
  }

  Widget _flowMeterReadingOpenController(
      {required FetchAddAssignmentDataState dataState}) {
    return TextFieldWidget(
      isRequired: true,
      controller: dataState.flowMeterReadingOpenController,
      textInputType: TextInputType.number,
      labelText: AppString.flowMeterReadingOpen,
    );
  }

  Widget _flowMeterReadingClosedController(
      {required FetchAddAssignmentDataState dataState}) {
    return TextFieldWidget(
      isRequired: true,
      controller: dataState.flowMeterReadingClosedController,
      textInputType: TextInputType.number,
      labelText: AppString.flowMeterReadingClosed,
    );
  }

  Widget _outPressureController(
      {required FetchAddAssignmentDataState dataState}) {
    return TextFieldWidget(
      isRequired: true,
      controller: dataState.outPressureController,
      textInputType: TextInputType.number,
      labelText: AppString.outPressure,
    );
  }

  Widget _lcvCondition( {required FetchAddAssignmentDataState dataState}) {
    return Column(
      children: [
        _radioButton(
            selectedValue: dataState.isLcvCondition,
            title: AppString.lcvCondition,
            label1: "Ok",
            label2: "Not Ok",
            onChanged: (value) {
              print(value);
              BlocProvider.of<AddAssignmentBloc>(context).add(AddAssignmentSetCheckListEventEvent(
                checkList: 1, isSelected: value == "0" ? false : true
              ));
            }
        ),
      dataState.isLcvCondition == false ?
      TextFieldWidget(
        labelText: AppString.remark,
        controller: dataState.remarkController,
       ) : const SizedBox.shrink(),
      ],
    );
  }

  Widget _driverFitToDrive( {required FetchAddAssignmentDataState dataState}) {
    return _radioButton(
        selectedValue: dataState.isDriverFitDrive,
        title: AppString.driverFitToDrive,
        label1: "Ok",
        label2: "Not Ok",
        onChanged: (value) {
          BlocProvider.of<AddAssignmentBloc>(context).add(AddAssignmentSetCheckListEventEvent(
              checkList: 2, isSelected: value == "0" ? false : true
          ));
        }
    );
  }

  Widget _improperLCVLogBooKCorrections( {required FetchAddAssignmentDataState dataState}) {
    return _radioButton(
        selectedValue: dataState.isLcvLogBookCorrection,
        title: AppString.improperLCVLogBooKCorrections,
        label1: "Ok",
        label2: "Not Ok",
        onChanged: (value) {
          BlocProvider.of<AddAssignmentBloc>(context).add(AddAssignmentSetCheckListEventEvent(
              checkList: 3, isSelected: value == "0" ? false : true
          ));
        }
    );
  }

  Widget _availabilityOfMobilWithDriver( {required FetchAddAssignmentDataState dataState}) {
    return _radioButton(
        selectedValue: dataState.isAvailabilityMobileWithDriver,
        title: AppString.availabilityOfMobilWithDriver,
        onChanged: (value) {
          BlocProvider.of<AddAssignmentBloc>(context).add(AddAssignmentSetCheckListEventEvent(
              checkList: 4, isSelected: value == "0" ? false : true
          ));
        }
    );
  }

  Widget _unscheduledMaintenancePenaltyHoursController(
      {required FetchAddAssignmentDataState dataState}) {
    return TextFieldWidget(
      isRequired: true,
      controller: dataState.unscheduledMaintenancePenaltyHoursController,
      textInputType: TextInputType.number,
      labelText: AppString.unscheduledMaintenancePenaltyHours,
    );
  }

  Widget _scheduledMaintenancePenaltyHoursController(
      {required FetchAddAssignmentDataState dataState}) {
    return TextFieldWidget(
      isRequired: true,
      controller: dataState.scheduledMaintenancePenaltyHoursController,
      textInputType: TextInputType.number,
      labelText: AppString.scheduledMaintenancePenaltyHours,
    );
  }

  Widget _radioButton({required bool selectedValue,
   required String title,
    String? label1,
     String? label2,
    required ValueChanged<dynamic> onChanged
  }) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              TextWidget(title, fontWeight: FontWeight.w700, fontSize: AppFont.font_11,),
              TextWidget("*", fontWeight: FontWeight.w700, fontSize: AppFont.font_11, color: AppColor.red,),
            ],
          ),
              Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              children: [
                RadioListTile<String>(
                  title: TextWidget(label1 ?? AppString.yes),
                  value: '1',
                  groupValue: selectedValue == true ? "1" : "0",
                  onChanged: onChanged,
                ),
                RadioListTile<String>(
                  title: TextWidget(label2 ?? AppString.no),
                  value: '0',
                  groupValue: selectedValue == true ? "1" : "0",
                  onChanged: onChanged,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _cngStationDropdown({required FetchAddAssignmentDataState dataState}) {
    return dataState.isAddCngStation == false ?
    DropDownSearchWidget(
      selectedItem:
      dataState.cngStationData.id != null ? dataState.cngStationData : null,
      hint: AppString.selectCNGStation,
      items: dataState.cngStationList,
      itemAsString: (cngStationData) => cngStationData.stationName.toString(),
      onChanged: (value) {
        BlocProvider.of<AddAssignmentBloc>(context).add(
            AddAssignmentSetCngStationDataEvent(
                cngStationData: value, context: context));
      },
    ) : const SizedBox.shrink();
  }

  Widget _cngStationRoueDropdown(
      {required FetchAddAssignmentDataState dataState}) {
    return dataState.isRouteLoader == false
        ? dataState.isAddCngStation == false
            ? DropdownWidget(
                hint: AppString.selectRoute,
                dropdownValue: dataState.cngStationRouteData.id != null
                    ? dataState.cngStationRouteData
                    : null,
                onChanged: (value) {
                  BlocProvider.of<AddAssignmentBloc>(context)
                      .add(AddAssignmentSetStationRouteDataEvent(
                    cngStationRouteData: value,
                  ));
                },
                items: dataState.cngStationRouteList
                    .map<DropdownMenuItem<CngStationRouteModel>>(
                        (CngStationRouteModel cngStationRouteData) {
                  return DropdownMenuItem<CngStationRouteModel>(
                    value: cngStationRouteData,
                    child: Text(cngStationRouteData.routeName.toString()),
                  );
                }).toList(),
              )
            : const SizedBox.shrink()
        : const DottedLoaderWidget();
  }


  Widget _cngQuantityTextField(
      {required FetchAddAssignmentDataState dataState}) {
    return dataState.cngStationData.stationName != null
        ? Padding(
            padding: EdgeInsets.only(
              top: MediaQuery.of(context).size.height * 0.02,
            ),
            child: Column(
              children: [
                TextFieldWidget(
                  controller: dataState.cngQuantityController,
                  isRequired: true,
                  textInputType: TextInputType.number,
                  labelText: AppString.enterCngQuantity,
                ),
                _addCngStationButton(dataState: dataState),
              ],
            ),
          )
        : const SizedBox.shrink();
  }

  Widget _addCngStationButton(
      {required FetchAddAssignmentDataState dataState}) {
    return Align(
      alignment: Alignment.centerRight,
      child: SizedBox(
        width: MediaQuery.of(context).size.width / 3,
        child: ButtonWidget(
            text: AppString.add,
            onPressed: () {
              BlocProvider.of<AddAssignmentBloc>(context)
                  .add(AddAssignmentAddStationEvent(context: context));
            }),
      ),
    );
  }

  Widget _addMoreButton({required FetchAddAssignmentDataState dataState}) {
    return dataState.isAddCngStation == true
        ? Align(
            alignment: Alignment.centerRight,
            child: SizedBox(
              width: MediaQuery.of(context).size.width / 3,
              child: ButtonWidget(
                  text: AppString.addMore,
                  onPressed: () {
                    BlocProvider.of<AddAssignmentBloc>(context).add(
                        const AddAssignmentAddMoreCngStationDataEvent(
                            isAddCNGStationButton: false));
                  }),
            ),
          )
        : const SizedBox.shrink();
  }

  Widget _cngStationList({required FetchAddAssignmentDataState dataState}) {
    return dataState.stationList.isNotEmpty
        ? Card(
            elevation: 2,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding:
                      EdgeInsets.all(MediaQuery.of(context).size.width * 0.02),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      TextWidget(
                        AppString.cngStations,
                        fontSize: AppFont.font_16,
                        color: AppColor.themeColor,
                      ),
                      _addMoreButton(dataState: dataState),
                    ],
                  ),
                ),
                ListView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: dataState.stationList.length,
                    itemBuilder: (context, index) {
                      return buildRow(
                          index: index,
                          stationList: dataState.stationList,
                          dataState: dataState);
                    })
              ],
            ),
          )
        : const SizedBox.shrink();
  }

  Widget _submitButton({required FetchAddAssignmentDataState dataState}) {
    return dataState.isLoader == false
        ? ButtonWidget(
            text: AppString.submit,
            onPressed: () {
              BlocProvider.of<AddAssignmentBloc>(context)
                  .add(AddAssignmentSubmitEvent(context: context));
            })
        : const DottedLoaderWidget();
  }

  Widget buildRow(
      {required int index,
      required List<StationModel> stationList,
      required FetchAddAssignmentDataState dataState}) {
    final track = stationList[index];
    Widget tile = _listItemBuilder(
      index: index,
      dataState: dataState,
    );
    Draggable draggable = LongPressDraggable<StationModel>(
      data: track,
      axis: Axis.vertical,
      maxSimultaneousDrags: 1,
      childWhenDragging: Opacity(
        opacity: 0.5,
        child: tile,
      ),
      feedback: Material(
        elevation: 4.0,
        child: ConstrainedBox(
          constraints:
              BoxConstraints(maxWidth: MediaQuery.of(context).size.width),
          child: tile,
        ),
      ),
      child: tile,
    );

    return DragTarget<StationModel>(
      onWillAcceptWithDetails: (track) {
        return stationList.indexOf(track.data) != index;
      },
      onAcceptWithDetails: (track) {
        int currentIndex = stationList.indexOf(track.data);
        stationList.remove(track.data);
        stationList.insert(currentIndex > index ? index : index - 1, track.data);
        BlocProvider.of<AddAssignmentBloc>(context).add(
            AddAssignmentStationSequenceChangeEvent(stationList: stationList));
      },
      builder: (BuildContext context, List<StationModel?> candidateData,
          List<dynamic> rejectedData) {
        return Column(
          children: <Widget>[
            AnimatedSize(
              duration: const Duration(milliseconds: 100),
              child: candidateData.isEmpty
                  ? Container()
                  : Opacity(
                      opacity: 0.0,
                      child: tile,
                    ),
            ),
            Card(
              child: candidateData.isEmpty ? draggable : tile,
            )
          ],
        );
      },
    );
  }

  Widget _listItemBuilder(
      {required int index, required FetchAddAssignmentDataState dataState}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          width: MediaQuery.of(context).size.width,
          color: Colors.grey[200],
          child: Padding(
            padding: EdgeInsets.all(MediaQuery.of(context).size.width * 0.02),
            child: Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      TextWidget(dataState
                          .stationList[index].cngStation.stationName
                          .toString()),
                      TextWidget(
                        "Quantity : ${dataState.stationList[index].quantity.toString()}",
                        fontSize: AppFont.font_12,
                      ),
                    ],
                  ),
                ),
                IconButton(
                    onPressed: () {
                      BlocProvider.of<AddAssignmentBloc>(context)
                          .add(AddAssignmentRemoveStationEvent(
                        index: index,
                      ));
                    },
                    icon: Icon(Icons.clear,
                        size: MediaQuery.of(context).size.width * 0.05))
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _imageList({required FetchAddAssignmentDataState dataState}) {
    return dataState.fileList.isNotEmpty
        ? SizedBox(
      // height: MediaQuery.of(context).size.height / 6,
      child: GridView.builder(
        itemCount: dataState.fileList.length,
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        itemBuilder: (context, index) => _photo(
            context: context,
            dataState: dataState,
            index: index,
            file: dataState.fileList[index]),
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 3,
          mainAxisSpacing: 8,
          crossAxisSpacing: 8,
        ),
      ),
    )
        : const SizedBox.shrink();
  }

  Widget _photo({required FetchAddAssignmentDataState dataState,
    required int index,
    required File file, required BuildContext context}) {
    return SizedBox(
      width: MediaQuery.of(context).size.width / 4,
      height: MediaQuery.of(context).size.width / 4,
      child: InkWell(
        onTap: () async {
          mediaType(context: context, index: index);
        },
        child: DottedBorder(
          color: AppColor.grey,
          strokeWidth: 1,
          child: file.path.isEmpty
              ? Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Center(
                child: Icon(Icons.photo_camera_back_outlined),
              ),
              Padding (
                padding: EdgeInsets.all(
                    MediaQuery.of(context).size.width * 0.02),
                child: TextWidget(
                  "Add Photo",
                  fontSize: AppFont.font_12,
                  color: AppColor.grey,
                ),
              ),
            ],
          ) : Stack(
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  file.path.toString().toLowerCase().contains(".jpg") ||
                      file.path
                          .toString()
                          .toLowerCase()
                          .contains(".png") ||
                      file.path
                          .toString()
                          .toLowerCase()
                          .contains(".jpeg")
                      ? Image.file(
                    file,
                    fit: BoxFit.fill,
                    width: MediaQuery.of(context).size.width / 3,
                    height: MediaQuery.of(context).size.width / 4.5,
                  )
                      : file.path
                      .toString()
                      .toLowerCase()
                      .contains(".pdf")
                      ? const Icon(Icons.picture_as_pdf_outlined)
                      : const Icon(Icons.document_scanner_outlined),
                  file.path.toString().toLowerCase().contains(".pdf")
                      ? TextWidget(
                    file.path.split('.').last.toString(),
                    maxLines: 1,
                    color: AppColor.themeColor,
                    fontSize: AppFont.font_12,
                  ) : const SizedBox.shrink(),
                ],
              ),
              Align(
                alignment: Alignment.topRight,
                child: InkWell(
                  onTap: () {
                    BlocProvider.of<AddAssignmentBloc>(context).add(
                        AddAssignmentDeleteImageEvent(index: index));
                  },
                  child: Icon(
                    Icons.close,
                    color: AppColor.red,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void mediaType({required BuildContext context, required int index}) {
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
                    BlocProvider.of<AddAssignmentBloc>(context)
                        .add(AddAssignmentSelectImageEvent(
                        context: context,
                        mediaType: 1,
                    ));
                    Navigator.pop(context);
                  },
                  child: TextWidget(
                    "Camera",
                    fontSize: AppFont.font_16,
                  )),
              const Divider(),
              TextButton(
                  onPressed: () {
                    BlocProvider.of<AddAssignmentBloc>(context)
                        .add(AddAssignmentSelectImageEvent(
                      context: context,
                      mediaType: 2,
                    ));
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

  Widget _verticalSpace() {
    return SizedBox(
      height: MediaQuery.of(context).size.height * 0.02,
    );
  }
}
