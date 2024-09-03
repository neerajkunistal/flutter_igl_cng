import 'package:flutter/material.dart';
import 'package:flutter_igl_cng/ExportFile/app_export_file.dart';
import 'package:flutter_igl_cng/feature/lcv/assignment/viewAssignment/domain/bloc/view_assignment_bloc.dart';
import 'package:flutter_igl_cng/feature/lcv/driver/viewDriver/domain/model/driver_model.dart';

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
            margin: EdgeInsets.all(15.0),
            child: Column(
              children: [
                Padding(
                  padding: EdgeInsets.only(bottom: 20.0, top: 10.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        "View Assignment Filter",
                        style: TextStyle(
                            color: Color(0xFF0077bd),
                            fontSize: 16.0,
                            fontWeight: FontWeight.w700),
                      ),
                      InkWell(
                        onTap: () {
                          Navigator.pop(context);
                        },
                        child: Icon(
                          Icons.close,
                          color: Colors.grey,
                        ),
                      )
                    ],
                  ),
                ),
                dataState.lcvDriverList.isNotEmpty
                    ? _lcvDriverDropDown(
                        lcvDriverList: dataState.lcvDriverList,
                        dataState: dataState)
                    : SizedBox.shrink(),
                _textFiledWidget(dataState: dataState),
                SizedBox(
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
        SizedBox(
          width: 10.0,
        ),
        Expanded(child: _toDateTextField(dataState: dataState))
      ],
    );
  }

  Widget _fromDateTextField({required FetchViewAssignmentDataState dataState}) {
    return Padding(
        padding: EdgeInsets.only(top: 20.0),
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
              labelStyle: TextStyle(fontSize: 14.0),
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
        padding: EdgeInsets.only(top: 20.0),
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
              labelStyle: TextStyle(fontSize: 14.0),
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
      {required List<DriverModel> lcvDriverList,
      required FetchViewAssignmentDataState dataState}) {
    return GestureDetector(
      onTap: () {
        showAlertDialog(context: context, lcvDriverList: lcvDriverList);
      },
      child: Container(
        decoration: BoxDecoration(
          border: Border.all(color: Colors.grey, width: 1.0),
          borderRadius: BorderRadius.all(
              Radius.circular(5.0) //                 <--- border radius here
              ),
        ),
        child: Padding(
          padding: EdgeInsets.all(10.0),
          child: Padding(
            padding: EdgeInsets.all(5.0),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  dataState.lcvDriverData.driverName != null
                      ? "${dataState.lcvDriverData.driverName.toString()}"
                      : "Select Lcv Driver",
                  style: TextStyle(
                      fontSize: 14.0,
                      fontWeight: FontWeight.w400,
                      color: Colors.black),
                ),
                Icon(
                  Icons.arrow_drop_down,
                  color: Colors.black,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _submitButtonWidget(
      {required FetchViewAssignmentDataState dataState}) {
    return dataState.isLoader == false
        ? Container(
            width: double.infinity,
            decoration: gradientDecoration,
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
              },
              child: Text("Submit", style: CustomStyleText.haajriButtonStyle),
            ),
          )
        : const DottedLoaderWidget();
  }

  showAlertDialog(
      {required BuildContext context,
      required List<DriverModel> lcvDriverList}) {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "Lcv Driver List",
                  style: TextStyle(
                      color: Color(0xFF0077bd),
                      fontSize: 16.0,
                      fontWeight: FontWeight.w700),
                ),
                InkWell(
                  onTap: () {
                    Navigator.pop(context);
                  },
                  child: Icon(
                    Icons.close,
                    color: Colors.grey,
                  ),
                )
              ],
            ),
            content:
                setDriverList(context: context, lcvDriverList: lcvDriverList),
          );
        });
  }

  Widget setDriverList(
      {required BuildContext context,
      required List<DriverModel> lcvDriverList}) {
    return Container(
      height: MediaQuery.of(context).size.height /
          2.5, // Change as per your requirement
      width: MediaQuery.of(context).size.width /
          1.3, // Change as per your requirement
      child: ListView.builder(
          itemCount: lcvDriverList.length,
          shrinkWrap: true,
          itemBuilder: (context, index) {
            return GestureDetector(
              onTap: () {
                BlocProvider.of<ViewAssignmentBloc>(context).add(
                    ViewAssignmentSelectLcvDriverEvent(
                        context: context, lcvDriverData: lcvDriverList[index]));
                Navigator.pop(context);
              },
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(
                      "${lcvDriverList[index].driverName} (${lcvDriverList[index].driverLicenseId} )",
                      style: TextStyle(color: Colors.black, fontSize: 14.0),
                    ),
                  ),
                  Divider(),
                ],
              ),
            );
          }),
    );
  }
}
