import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_igl_cng/ExportFile/app_export_file.dart';
import 'package:flutter_igl_cng/feature/marketing/reportEquipmentComplaintMarket/viewEquipmentComplaint/domain/bloc/view_equipment_complaint_market_bloc.dart';

class CloserWidgetMarket extends StatelessWidget {
  final FetchViewEquipmentComplaintMarketDataState dataState;
  const CloserWidgetMarket({super.key, required this.dataState});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(20.0),
      child: Column(
        children: [
          _verticalSpace(context: context),
          _verticalSpace(context: context),
          Row(
            children: [
              Expanded(child: _dateController(dataState: dataState, context: context)),
              SizedBox(
                width: MediaQuery.of(context).size.width * 0.02,
              ),
              Expanded(child: _timeController(dataState: dataState, context: context)),
            ],
          ),
          _verticalSpace(context: context),
          _rectifiedByController(dataState: dataState),
          _verticalSpace(context: context),
          _remarkController(dataState: dataState),
          _verticalSpace(context: context),
          _verticalSpace(context: context),
          _button(context: context),
        ],
      ),
    );
  }
  Widget _dateController(
      {required FetchViewEquipmentComplaintMarketDataState dataState, required BuildContext context}) {
    return TextFieldWidget(
      enabled: false,
      isRequired: true,
      labelText: AppString.date,
      controller: dataState.dateController,
      onTap: () {
        BlocProvider.of<ViewEquipmentComplaintMarketBloc>(context)
            .add(ViewEquipmentComplaintMarketSelectDateData(context: context));
      },
    );
  }

  Widget _timeController(
      {required FetchViewEquipmentComplaintMarketDataState dataState, required BuildContext context}) {
    return TextFieldWidget(
      enabled: false,
      isRequired: true,
      labelText: AppString.time,
      controller: dataState.timeController,
      onTap: () {
        BlocProvider.of<ViewEquipmentComplaintMarketBloc>(context)
            .add(ViewEquipmentComplaintMarketSelectTimeData(context: context));
      },
    );
  }

  Widget _rectifiedByController(
      {required FetchViewEquipmentComplaintMarketDataState dataState}) {
    return TextFieldWidget(
      isRequired: true,
      labelText: AppString.rectifiedBy,
      controller: dataState.rectifyByController,
    );
  }

  Widget _remarkController(
      {required FetchViewEquipmentComplaintMarketDataState dataState}) {
    return TextFieldWidget(
      isRequired: true,
      labelText: AppString.remark,
      controller: dataState.remarkController,
    );
  }

  Widget _button({required BuildContext context}) {
    return dataState.isLoader == false ?
    ButtonWidget(
        text: AppString.closure,
        onPressed: () {
          BlocProvider.of<ViewEquipmentComplaintMarketBloc>(context).add(ViewEquipmentComplaintMarketClosureEvent(
              reviewComplaintData: dataState.reviewComplaintData, index: dataState.index, context: context));
        }
    ) : const DottedLoaderWidget();
  }

  Widget _verticalSpace({required BuildContext context}) {
    return SizedBox(
      height: MediaQuery.of(context).size.height * 0.02,
    );
  }

}
