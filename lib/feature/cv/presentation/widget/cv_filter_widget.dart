import 'package:flutter/material.dart';
import 'package:flutter_igl_cng/ExportFile/app_export_file.dart';

cvFilter({required BuildContext context}) {
  showModalBottomSheet(
      isScrollControlled: true,
      context: context,
      builder: (builder) {
        return const CvFilterWidget();
      });

}

class CvFilterWidget extends StatelessWidget {
  const CvFilterWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return  Container(
      height: WidgetsBinding.instance.window.viewInsets.bottom > 0.0
          ? MediaQuery.of(context).size.height / 1.2
          : MediaQuery.of(context).size.height / 1.8,
      color: Colors.transparent, //could change this to Color(0xFF737373),
      child: Container(
          decoration: const BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(10.0),
                  topRight: Radius.circular(10.0))),
          child:BlocBuilder<ViewCvComplaintBloc, ViewCvComplaintState>(
            builder: (context, dataState) {
              if(dataState is FetchViewCvComplaintDataState){
                return dataState.isStationLoader == false ?
                SingleChildScrollView(
                  child: Column(
                    children: [
                      Row(
                        children: [
                          Expanded(
                              child: TextWidget(
                                "Filter",
                                fontSize: AppFont.font_16,
                                fontWeight: FontWeight.w700,
                                textAlign: TextAlign.center,
                                color: AppColor.black,)),

                          Align(
                            alignment: Alignment.topRight,
                            child: Padding(
                              padding:  const EdgeInsets.only(right: 20, top: 10),
                              child: InkWell(
                                onTap: () {
                                  Navigator.pop(context);
                                },
                                child: Icon(Icons.close, color: AppColor.grey,),
                              ),
                            ),
                          ),
                        ],
                      ),

                      SizedBox(
                        height: MediaQuery.of(context).size.width * 0.03,
                      ),
                      _dateController(dataState: dataState, context: context),
                      SizedBox(
                        height: MediaQuery.of(context).size.width * 0.03,
                      ),
                      _stationDropDown(dataState: dataState, context: context),
                      SizedBox(
                        height: MediaQuery.of(context).size.width * 0.03,
                      ),
                      _controlRoomDropDown(dataState: dataState, context: context),
                      _applyButtonWidget(dataState: dataState, context: context),
                      _filterClear(context: context),
                    ],
                  ),
                ) : const Center(child: CenterLoaderWidget());
              } else {
                return const Center(child: CenterLoaderWidget());
              }
            },
          )
      ),
    );
  }

  Widget _dateController({required FetchViewCvComplaintDataState dataState ,
    required BuildContext context}) {
    return Padding(
      padding: EdgeInsets.all( MediaQuery.of(context).size.width * 0.03),
      child: TextFieldWidget(
          controller: dataState.filterDateController,
          isRequired: true,
          enabled: false,
          onTap: () async {
            DateTime startDate = BlocProvider.of<ViewCvComplaintBloc>(
                !context.mounted ? context : context)
                .startDate;
            DateTime endDate = BlocProvider.of<ViewCvComplaintBloc>(
                !context.mounted ? context : context)
                .endDate;
            var selectedDate = await DateRangeWidget.showDateRange(
                startDate: startDate, endDate: endDate, context: context);
            if (selectedDate != null) {
              BlocProvider.of<ViewCvComplaintBloc>(
                  !context.mounted ? context : context)
                  .add(ViewCvComplaintSelectedDateRangeEvent(
                  fromDate: selectedDate.start,
                  toDate: selectedDate.end,
                  context: !context.mounted ? context : context));
            }
          },
          labelText: AppString.date
      ),
    );
  }
  Widget _stationDropDown({required FetchViewCvComplaintDataState dataState ,
    required BuildContext context}) {
    return Padding(
      padding: EdgeInsets.all( MediaQuery.of(context).size.width * 0.03),
      child: DropDownSearchWidget(
        isRequired: true,
        selectedItem:
        dataState.stationData.name != null ? dataState.stationData : null,
        hint: AppString.cngStation,
        items: dataState.stationList,
        itemAsString: (stationData) => stationData.name.toString(),
        onChanged: (value) {
          BlocProvider.of<ViewCvComplaintBloc>(context)
              .add(ViewCvComplaintSelectStationEvent(stationData: value));
        },
      ),
    );
  }

  Widget _controlRoomDropDown({required FetchViewCvComplaintDataState dataState ,
    required BuildContext context}) {
    return Padding(
      padding: EdgeInsets.all( MediaQuery.of(context).size.width * 0.03),
      child: DropDownSearchWidget(
        isRequired: true,
        selectedItem:
        dataState.controlRoomData.controlRoomName != null ? dataState.controlRoomData : null,
        hint: AppString.controlRoom,
        items: dataState.controlRoomList,
        itemAsString: (controlRoomData) => controlRoomData.controlRoomName.toString(),
        onChanged: (value) {
          BlocProvider.of<ViewCvComplaintBloc>(context)
              .add(ViewCvComplaintSelectControlRoomDataEvent(controlRoomData: value));
        },
      ),
    );
  }

  Widget _applyButtonWidget({required FetchViewCvComplaintDataState dataState ,
    required BuildContext context})  {
    return Padding(
        padding: EdgeInsets.only(left:  MediaQuery.of(context).size.width * 0.10, right: MediaQuery.of(context).size.width * 0.10,
         top: MediaQuery.of(context).size.width * 0.03, bottom: MediaQuery.of(context).size.width * 0.03),
        child: dataState.isFilterLoader == false ?
        ButtonWidget(
          text: "Filter apply",
          onPressed: () {
            BlocProvider.of<ViewCvComplaintBloc>(context).add(
                const ViewCvComplaintFilterSubmitEvent(isFilterSubmit: true));
            Navigator.pop(context);
          },
        ) : const DottedLoaderWidget(),
    );
  }

  Widget _filterClear({required BuildContext context}) {
    return TextButton(onPressed: () {
      BlocProvider.of<ViewCvComplaintBloc>(context).add(
          const ViewCvComplaintFilterSubmitEvent(isFilterSubmit: false));
      Navigator.pop(context);
    }, child: TextWidget("Clear",
      fontWeight: FontWeight.w700,
      color: EnvironmentConfig.of(context)!.primaryTheme,
    )
    );
  }
}
