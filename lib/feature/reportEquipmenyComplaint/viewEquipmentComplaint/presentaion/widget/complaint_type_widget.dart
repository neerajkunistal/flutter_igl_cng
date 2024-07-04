import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_igl_cng/ExportFile/app_export_file.dart';
import 'package:flutter_igl_cng/feature/cng/viewCng/presentation/page/view_cng_page.dart';
import 'package:flutter_igl_cng/feature/reportEquipmenyComplaint/viewEquipmentComplaint/presentaion/page/view_equipment_complaint_page.dart';
import 'package:flutter_igl_cng/utils/commonClass/fade_route.dart';

class ComplaintTypeWidget extends StatefulWidget {
  const ComplaintTypeWidget({super.key});

  @override
  State<ComplaintTypeWidget> createState() => _ComplaintTypeWidgetState();
}

class _ComplaintTypeWidgetState extends State<ComplaintTypeWidget> {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Padding(
              padding: const EdgeInsets.all(8.0),
              child: Card(
                shadowColor: AppColor.themeColor,
                elevation: 2,
                child: InkWell(
                  onTap: () {
                    Navigator.push(
                      context,
                      FadeRoute(
                          page: const ViewCngPage()),
                    );
                  },
                  child: Padding(
                    padding: const EdgeInsets.all(20.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Image.asset(AppIcon.maintenanceIcon,
                            height:
                            MediaQuery.of(context).size.width *
                                0.20),
                        SizedBox(
                          height: MediaQuery.of(context).size.width *
                              0.02,
                        ),
                        TextWidget(
                          "Civil Complaint",
                          color: AppColor.themeColor,
                          fontWeight: FontWeight.w700,
                        )
                      ],
                    ),
                  ),
                ),
              )),

          Padding(
              padding: const EdgeInsets.all(8.0),
              child: Card(
                shadowColor: AppColor.themeColor,
                elevation: 2,
                child: InkWell(
                  onTap: () {
                    Navigator.push(
                      context,
                      FadeRoute(
                          page: const ViewEquipmentComplaintPage(title: "Other Complaint",)),
                    );
                  },
                  child: Padding(
                    padding: const EdgeInsets.all(20.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Image.asset(AppIcon.equipmentIcon,
                            height:
                            MediaQuery.of(context).size.width *
                                0.20),
                        SizedBox(
                          height: MediaQuery.of(context).size.width *
                              0.02,
                        ),
                        TextWidget(
                          "Other Complaint",
                          color: AppColor.themeColor,
                          fontWeight: FontWeight.w700,
                        )
                      ],
                    ),
                  ),
                ),
              ))
        ],
      ),
    );
  }
}
