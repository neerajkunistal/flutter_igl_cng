import 'package:flutter/material.dart';
import 'package:flutter_igl_cng/ExportFile/app_export_file.dart';

amoModalBottomSheetMenu({required BuildContext context}) {
  showModalBottomSheet(
      isScrollControlled: true,
      context: context,
      builder: (builder) {
        return Container(
          height: WidgetsBinding.instance.window.viewInsets.bottom > 0.0
              ? MediaQuery.of(context).size.height / 1.2
              : MediaQuery.of(context).size.height / 1.6,
          color: Colors.transparent, //could change this to Color(0xFF737373),
          child: Container(
              decoration: const BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(10.0),
                      topRight: Radius.circular(10.0))),
              child:BlocBuilder<ViewAmoComplaintBloc, ViewAmoComplaintState>(
                builder: (context, dataState) {
                  if(dataState is FetchViewAmoComplaintDataState){
                    return dataState.isStationLoader == false ?
                    Column(
                      children: [
                        Row(
                          children: [
                            Expanded(
                                child: TextWidget(
                                  "Station List",
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
                            )
                          ],
                        ),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: TextFieldWidget(
                            labelText: "Search..",
                            controller: dataState.stationController,
                            onChanged: (value) {
                              BlocProvider.of<ViewAmoComplaintBloc>(context).add(
                                  ViewAmoComplaintSearchStationEvent(keyword: value));
                            },
                          ),
                        ),
                        Expanded(
                          child: ListView.builder(
                              shrinkWrap: true,
                              itemCount: dataState.stationList.length,
                              itemBuilder: (context, index) {
                                return Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: GestureDetector(
                                    onTap: () {
                                      BlocProvider.of<ViewAmoComplaintBloc>(context)
                                          .add(ViewAmoComplaintSelectStationDataEvent(stationData: dataState.stationList[index]));
                                      Navigator.pop(context);
                                    },
                                    child: Card(
                                      shadowColor: EnvironmentConfig.of(context)!.primaryTheme,
                                      elevation: 2,
                                      child: Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: Column(
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          mainAxisAlignment: MainAxisAlignment.start,
                                          children: [
                                            TextWidget(
                                              dataState.stationList[index].name
                                                  .toString(),
                                              fontWeight: FontWeight.w700,
                                              fontSize: AppFont.font_12,
                                              color: dataState.stationData.name.toString() == dataState.stationList[index].name
                                                  .toString() ? EnvironmentConfig.of(context)!.primaryTheme : AppColor.black,
                                            ),
                                            TextWidget(
                                              dataState.stationList[index].code
                                                  .toString(),
                                              fontWeight: FontWeight.w500,
                                              fontSize: AppFont.font_12,
                                              color: dataState.stationData.name.toString() == dataState.stationList[index].name
                                                  .toString() ? EnvironmentConfig.of(context)!.primaryTheme : AppColor.black,
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ),
                                );
                              }),
                        ),
                      ],
                    ) : const Center(child: CenterLoaderWidget());
                  } else {
                    return const Center(child: CenterLoaderWidget());
                  }
                },
              )
          ),
        );
      });
}