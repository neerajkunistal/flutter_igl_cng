import 'package:flutter/material.dart';
import 'package:flutter_igl_cng/ExportFile/app_export_file.dart';
import 'package:flutter_igl_cng/feature/lcv/cngScmInfo/viewCngScm/domain/model/cng_scm_model.dart';

class ViewCngScmItemBoxWidget extends StatelessWidget {
  final int index;
  final CngScmModel cngScmData;

  const ViewCngScmItemBoxWidget(
      {super.key, required this.index, required this.cngScmData});

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 2,
      shadowColor: AppColor.themeLightColor,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
      ),
      child: Padding(
        padding: EdgeInsets.all(MediaQuery.of(context).size.width * 0.02),
        child: Column(
          children: [
            Row(
              children: [
                TextWidget(
                  AppString.currentScmQuantity + " : ",
                  color: AppColor.themeColor,
                ),
                Expanded(
                    child: TextWidget(
                  cngScmData.currentScm.toString(),
                  color: AppColor.black,
                )),
              ],
            ),
            SizedBox(
              height: MediaQuery.of(context).size.width * 0.02,
            ),
            Row(
              children: [
                TextWidget(
                  AppString.sellScmQuantity + " : ",
                  color: AppColor.themeColor,
                ),
                Expanded(
                    child: TextWidget(
                  cngScmData.sellScm.toString(),
                  color: AppColor.black,
                )),
              ],
            ),
            SizedBox(
              height: MediaQuery.of(context).size.width * 0.02,
            ),
            Row(
              children: [
                TextWidget(
                  AppString.remainScmQuantity + " : ",
                  color: AppColor.themeColor,
                ),
                Expanded(
                    child: TextWidget(
                  cngScmData.remainScm.toString(),
                  color: AppColor.black,
                )),
              ],
            ),
            SizedBox(
              height: MediaQuery.of(context).size.width * 0.02,
            ),
            Row(
              children: [
                TextWidget(
                  AppString.requiredScmQuantity + " : ",
                  color: AppColor.themeColor,
                ),
                Expanded(
                    child: TextWidget(
                  cngScmData.requiredScm.toString(),
                  color: AppColor.black,
                )),
              ],
            ),
            SizedBox(
              height: MediaQuery.of(context).size.width * 0.02,
            ),
            const Divider(),
            Row(
              children: [
                TextWidget(
                  AppString.createDate + " : ",
                  color: AppColor.themeColor,
                ),
                Expanded(
                    child: TextWidget(
                  cngScmData.date.toString(),
                  color: AppColor.black,
                )),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
