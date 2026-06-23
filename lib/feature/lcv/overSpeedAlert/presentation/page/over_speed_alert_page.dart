import 'package:flutter/material.dart';
import 'package:flutter_igl_cng/ExportFile/app_export_file.dart';
import 'package:flutter_igl_cng/feature/lcv/overSpeedAlert/domain/bloc/over_speed_alert_bloc.dart';
import 'package:flutter_igl_cng/utils/commonWidgets/background_widget.dart';

class OverSpeedAlertPage extends StatefulWidget {
  const OverSpeedAlertPage({super.key});

  @override
  State<OverSpeedAlertPage> createState() => _OverSpeedAlertPageState();
}

class _OverSpeedAlertPageState extends State<OverSpeedAlertPage> {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        extendBodyBehindAppBar: true,
        body: AppBackgroundWidget(
          child: Column(
            children: [
              _appBar(),
              const DottedDividerLine(color: Colors.white),
              SizedBox(
                height: MediaQuery.of(context).size.height * 0.02,
              ),
              Expanded(
                child: BlocBuilder<OverSpeedAlertBloc, OverSpeedAlertState>(
                    builder: (context, state) {
                      if (state is FetchOverSpeedAlertDataState) {
                        return _itemWidget(dataState: state);
                      } else {
                        return const Center(
                          child: CenterLoaderWidget(),
                        );
                      }
                    }),
              ),
            ],
          ),
        ));
  }

  Widget _itemWidget({required FetchOverSpeedAlertDataState dataState}) {
    return dataState.overSpeedAlertList.isNotEmpty ?
    ListView.builder(
        itemCount: dataState.overSpeedAlertList.length,
        shrinkWrap: true,
        itemBuilder: (context, index) {
        return Padding(
            padding: const EdgeInsets.all(10.0),
         child: dataState.overSpeedAlertList[index].isSelected == false ?
         InkWell(
           onTap: () {
             BlocProvider.of<OverSpeedAlertBloc>(context)
                 .add(OverSpeedAlertMarkReadEvent(index: index, context: context));
           },
           child: Card(
             elevation: 2,
             child: Padding(
               padding: const EdgeInsets.all(8.0),
               child: TextWidget(
                 "Vehicle No - ${dataState.overSpeedAlertList[index].vehicleNo}\nSpeed - ${dataState.overSpeedAlertList[index].speed}",
                 fontWeight: dataState.overSpeedAlertList[index].status.toString() == "0" ? FontWeight.w700 : FontWeight.w400,
                 fontSize: AppFont.font_12,
               ),
             ),
           ),
         ) : const DottedLoaderWidget(),
        );
    }) : Center(child: TextWidget("No Alert Messages", color: AppColor.white,),);
  }

  Widget _appBar() {
    return AppBar(
      elevation: 0,
      title:  TextWidget(
      "Over Speed Alerts",
      color: AppColor.white,
      fontSize: AppFont.font_14,
      fontWeight: FontWeight.w700,
    ),
      backgroundColor: Colors.transparent,
    );
  }
}
