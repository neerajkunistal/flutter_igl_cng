import 'package:flutter/material.dart';
import 'package:flutter_igl_cng/ExportFile/app_export_file.dart';
import 'package:flutter_igl_cng/feature/cng/viewCng/domain/domain/bloc/view_cng_bloc.dart';

class ViewCngTabBarWidget extends StatelessWidget {
  final FetchViewCngDataState dataState;
  const ViewCngTabBarWidget({super.key, required this.dataState});

  @override
  Widget build(BuildContext context) {
    return _tabWidget(dataState: dataState, context: context);
  }

  Widget _tabWidget({required FetchViewCngDataState dataState,
    required BuildContext context}) {
    return Container(
      height: MediaQuery.of(context).size.width * 0.10,
      margin: const EdgeInsets.only(left: 10.0, right: 10.0, top: 5.0),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        color: AppColor.themeNormalLightColor,
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Expanded(
            child: TextButton(
                style: dataState.tabIndex == 0
                    ? ButtonStyle(
                    backgroundColor: WidgetStateProperty.all<Color>(
                        AppColor.themeColor),
                    shape: WidgetStateProperty
                        .all<RoundedRectangleBorder>(RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10.0),
                        side: BorderSide(color: AppColor.themeColor))))
                    : null,
                onPressed: () {
                  BlocProvider.of<ViewCngBloc>(context).add(
                      const ViewCngSelectTabEvent(
                          tabIndex: 0));
                },
                child: TextWidget(
                  "Open-${dataState.cngAllItemsList.where((element) => element.complaintStatus.toString() =="0").toList().length}",
                  color: dataState.tabIndex == 0
                      ? AppColor.white
                      : AppColor.black,
                  fontWeight: dataState.tabIndex == 0
                      ? FontWeight.w700
                      : FontWeight.w400,
                  fontSize: AppFont.font_11,
                )),
          ),
          Expanded(
            child: TextButton(
                style: dataState.tabIndex == 1
                    ? ButtonStyle(
                    backgroundColor: WidgetStateProperty.all<Color>(
                        AppColor.themeColor),
                    shape: WidgetStateProperty
                        .all<RoundedRectangleBorder>(RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10.0),
                        side: BorderSide(color: AppColor.themeColor))))
                    : null,
                onPressed: () {
                  BlocProvider.of<ViewCngBloc>(context).add(
                      const ViewCngSelectTabEvent(
                          tabIndex: 1));
                },
                child: TextWidget(
                  "Closed-${dataState.cngAllItemsList.where((element) => element.complaintStatus.toString() =="1").toList().length}",
                  color: dataState.tabIndex == 1
                      ? AppColor.white
                      : AppColor.black,
                  fontWeight: dataState.tabIndex == 1
                      ? FontWeight.w700
                      : FontWeight.w400,
                  fontSize: AppFont.font_11,
                )),
          ),
        ],
      ),
    );
  }
}
