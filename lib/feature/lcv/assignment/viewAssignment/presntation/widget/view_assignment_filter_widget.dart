import 'package:flutter/material.dart';
import 'package:flutter_igl_cng/ExportFile/app_export_file.dart';

class ViewAssignmentFilterWidget {
  BuildContext context;

  ViewAssignmentFilterWidget({required this.context});

  filterSearch() {
    showModalBottomSheet<void>(
      context: context,
      builder: (BuildContext context) {
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
      },
    );
  }

  Widget _itemBuilder({required FetchViewAssignmentDataState dataState}) {
    return dataState.isDriverList == false
        ? Container(
            margin: const EdgeInsets.all(15.0),
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.only(bottom: 20.0, top: 10.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                       TextWidget(
                        "View Assignment Filter",
                         color: EnvironmentConfig.of(context)!.primaryTheme,
                         fontSize: AppFont.font_15,
                         fontWeight: FontWeight.w700,
                      ),
                      InkWell(
                        onTap: () {
                          Navigator.pop(context);
                        },
                        child: const Icon(
                          Icons.close,
                          color: Colors.grey,
                        ),
                      )
                    ],
                  ),
                ),
                dataState.lcvDriverList.isNotEmpty
                    ? _lcvDriverDropDown(dataState: dataState)
                    : const SizedBox.shrink(),
                dataState.lcvList.isNotEmpty
                    ? _lcvTruckDropDown(dataState: dataState)
                    : const SizedBox.shrink(),
                dataState.cngStationList.isNotEmpty
                    ? _cngStationDropDown(dataState: dataState)
                    : const SizedBox.shrink(),
                _textFiledWidget(dataState: dataState),
                const SizedBox(
                  height: 15.0,
                ),
                _submitButtonWidget(dataState: dataState),
              ],
            ),
          )
        : const Center(child: CenterLoaderWidget());
  }

  Widget _textFiledWidget({required FetchViewAssignmentDataState dataState}) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Expanded(child: _fromDateTextField(dataState: dataState)),
        const SizedBox(
          width: 10.0,
        ),
        Expanded(child: _toDateTextField(dataState: dataState))
      ],
    );
  }

  Widget _fromDateTextField({required FetchViewAssignmentDataState dataState}) {
    return Padding(
        padding: const EdgeInsets.only(top: 20.0),
        child: GestureDetector(
          onTap: () {
            BlocProvider.of<ViewAssignmentBloc>(context)
                .add(ViewAssignmentSelectFromDateEvent(context: context));
          },
          child: TextFormField(
            enabled: false,
            controller: dataState.fromDateTextFieldController,
            decoration: InputDecoration(
              labelText: "From Date",
              labelStyle: const TextStyle(fontSize: 14.0),
              fillColor: Colors.white,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
                borderSide: const BorderSide(
                  width: 1,
                  style: BorderStyle.none,
                ),
              ),
            ),
          ),
        ));
  }

  Widget _toDateTextField({required FetchViewAssignmentDataState dataState}) {
    return Padding(
        padding: const EdgeInsets.only(top: 20.0),
        child: GestureDetector(
          onTap: () {
            BlocProvider.of<ViewAssignmentBloc>(context)
                .add(ViewAssignmentSelectToDateEvent(context: context));
          },
          child: TextFormField(
            enabled: false,
            controller: dataState.toDateTextFieldController,
            decoration: InputDecoration(
              labelText: "To Date",
              labelStyle: const TextStyle(fontSize: 14.0),
              fillColor: Colors.white,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
                borderSide: const BorderSide(
                  width: 1,
                  style: BorderStyle.none,
                ),
              ),
            ),
          ),
        ));
  }

  Widget _lcvDriverDropDown(
      {required FetchViewAssignmentDataState dataState}) {
    return DropDownSearchWidget(
      isRequired: true,
      selectedItem:
      dataState.lcvDriverData.driverName != null ? dataState.lcvDriverData : null,
      hint: AppString.driverName,
      items: dataState.lcvDriverList,
      itemAsString: (lcvDriverData) => "${lcvDriverData.driverName} (${lcvDriverData.driverLicenseId} )",
      onChanged: (value) {
        BlocProvider.of<ViewAssignmentBloc>(context).add(
            ViewAssignmentSelectLcvDriverEvent(
                context: context, lcvDriverData: value));
      },
    );
  }

  Widget _lcvTruckDropDown(
      {required FetchViewAssignmentDataState dataState}) {
    return DropDownSearchWidget(
      isRequired: true,
      selectedItem:
      dataState.lcvData.vehicleNo != null ? dataState.lcvData : null,
      hint: AppString.lcvTruck,
      items: dataState.lcvList,
      itemAsString: (lcvData) => "${lcvData.vehicleNo}",
      onChanged: (value) {
        BlocProvider.of<ViewAssignmentBloc>(context)
            .add(ViewAssignmentSetLcvTrackDataEvent(lcvData: value));
      },
    );
  }

  Widget _cngStationDropDown(
      {required FetchViewAssignmentDataState dataState}) {
    return DropDownSearchWidget(
      isRequired: true,
      selectedItem:
      dataState.cngStationData.controlRoomName != null ? dataState.cngStationData : null,
      hint: AppString.cngStation,
      items: dataState.cngStationList,
      itemAsString: (cngStationData) => "${cngStationData.stationName}",
      onChanged: (value) {
        BlocProvider.of<ViewAssignmentBloc>(context)
            .add(ViewAssignmentSetCngStationDataEvent(cngStationData: value));
      },
    );
  }

  Widget _submitButtonWidget(
      {required FetchViewAssignmentDataState dataState}) {
    return dataState.isLoader == false
        ? Container(
            width: double.infinity,
            decoration: gradientDecoration(context: context),
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.all(15),
                backgroundColor: Colors.transparent,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(24),
                ),
              ),
              onPressed: () {
                BlocProvider.of<ViewAssignmentBloc>(context)
                    .add(ViewAssignmentFilterSubmitEvent(context: context));
                Navigator.pop(context);
              },
              child: Text("Submit", style: CustomStyleText.haajriButtonStyle),
            ),
          )
        : const DottedLoaderWidget();
  }

}
