import 'package:flutter/material.dart';
import 'package:flutter_igl_cng/ExportFile/app_export_file.dart';
import 'package:flutter_igl_cng/feature/lcv/assignment/addAssignment/domain/bloc/add_assignment_bloc.dart';
import 'package:flutter_igl_cng/feature/lcv/assignment/addAssignment/domain/model/mother_station_model.dart';
import 'package:flutter_igl_cng/feature/lcv/assignment/addAssignment/domain/model/station_model.dart';
import 'package:flutter_igl_cng/feature/lcv/cngStation/viewCNGStation/domain/model/cng_stattion_model.dart';
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
      child: ListView(
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
          _cngStationRoueDropdown(dataState: dataState),
          _cngQuantityTextField(dataState: dataState),
          dataState.stationList.isNotEmpty
              ? _cngStationList(dataState: dataState)
              : const SizedBox.shrink(),
          SizedBox(
            height: MediaQuery.of(context).size.height * 0.03,
          ),
          _scheduleDateTimeTextField(dataState: dataState),
          SizedBox(
            height: MediaQuery.of(context).size.height * 0.03,
          ),
          _totalCngQuantityField(dataState: dataState),
          SizedBox(
            height: MediaQuery.of(context).size.height * 0.04,
          ),
          _submitButton(dataState: dataState),
        ],
      ),
    );
  }

  Widget _motherStationDropDown(
      {required FetchAddAssignmentDataState dataState}) {
    return DropdownWidget(
      hint: AppString.selectMotherStation,
      dropdownValue: dataState.motherStationData.id != null
          ? dataState.motherStationData
          : null,
      onChanged: (value) {
        BlocProvider.of<AddAssignmentBloc>(context)
            .add(AddAssignmentSetMotherStationDataEvent(
          motherStationData: value,
        ));
      },
      items: dataState.motherStationList
          .map<DropdownMenuItem<MotherStationModel>>(
              (MotherStationModel motherStationData) {
        return DropdownMenuItem<MotherStationModel>(
          value: motherStationData,
          child: Text(motherStationData.stationName.toString()),
        );
      }).toList(),
    );
  }

  Widget _driverDropDown({required FetchAddAssignmentDataState dataState}) {
    return Row(
      children: [
        Expanded(
          child: DropDownSearchWidget(
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
          ),
        ),
        IconButton(
            onPressed: () {
/*              Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => QrCodeScanPage(
                          onScan: (value) {
                            BlocProvider.of<AddAssignmentBloc>(context).add(
                                AddAssignmentSetDriverNoDataEvent(
                                    drivingLicence: value.toString(),
                                    context: context));
                          },
                        )),
              );*/
            },
            icon: Icon(
              Icons.qr_code_scanner,
              color: AppColor.themeColor,
            ))
      ],
    );
  }

  Widget _lcvTrack({required FetchAddAssignmentDataState dataState}) {
    return Row(
      children: [
        Expanded(
          child: DropDownSearchWidget(
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
          ),
        ),
        IconButton(
            onPressed: () {
  /*            Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => QrCodeScanPage(
                          onScan: (value) {
                            BlocProvider.of<AddAssignmentBloc>(context).add(
                                AddAssignmentSetTruckNoDataEvent(
                                    truckNumber: value.toString(),
                                    context: context));
                          },
                        )),
              );*/
            },
            icon: Icon(
              Icons.qr_code_scanner,
              color: AppColor.themeColor,
            ))
      ],
    );
  }

  Widget _cngStationDropdown({required FetchAddAssignmentDataState dataState}) {
    return dataState.isAddCngStation == false
        ? DropdownWidget(
            hint: AppString.selectCNGStation,
            dropdownValue: dataState.cngStationData.stationName != null
                ? dataState.cngStationData
                : null,
            onChanged: (value) {
              BlocProvider.of<AddAssignmentBloc>(context).add(
                  AddAssignmentSetCngStationDataEvent(
                      cngStationData: value, context: context));
            },
            items: dataState.cngStationList
                .map<DropdownMenuItem<CngStationModel>>(
                    (CngStationModel cngStationData) {
              return DropdownMenuItem<CngStationModel>(
                value: cngStationData,
                child: Text(cngStationData.stationName.toString()),
              );
            }).toList(),
          )
        : const SizedBox.shrink();
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

  Widget _scheduleDateTimeTextField(
      {required FetchAddAssignmentDataState dataState}) {
    return TextFieldWidget(
      onTap: () {
        BlocProvider.of<AddAssignmentBloc>(context)
            .add(AddAssignmentSelectDateTimeEvent(context: context));
      },
      enabled: false,
      controller: dataState.scheduleDateTimeController,
      isRequired: true,
      textInputType: TextInputType.text,
      labelText: AppString.selectDateTime,
    );
  }

  Widget _totalCngQuantityField(
      {required FetchAddAssignmentDataState dataState}) {
    return TextFieldWidget(
      controller: dataState.totalCngQuantityController,
      isRequired: true,
      textInputType: TextInputType.number,
      labelText: AppString.totalCngQuantity,
    );
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
      onWillAccept: (track) {
        return stationList.indexOf(track!) != index;
      },
      onAccept: (track) {
        int currentIndex = stationList.indexOf(track);
        stationList.remove(track);
        stationList.insert(currentIndex > index ? index : index - 1, track);
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
}
