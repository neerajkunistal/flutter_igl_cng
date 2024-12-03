import 'package:flutter/material.dart';
import 'package:flutter_igl_cng/ExportFile/app_export_file.dart';
import 'package:flutter_igl_cng/feature/reportEquipmenyComplaint/viewEquipmentComplaint/presentaion/widget/closer_widget.dart';
import 'package:flutter_igl_cng/feature/reviewComplaint/presentation/widget/review_complaint_item_box.dart';
import 'package:flutter_igl_cng/utils/commonWidgets/dotted_line_widget.dart';

class ViewEquipmentComplaintDetailPage extends StatefulWidget {
  const ViewEquipmentComplaintDetailPage({super.key});

  @override
  State<ViewEquipmentComplaintDetailPage> createState() =>
      _ViewEquipmentComplaintDetailPageState();
}

class _ViewEquipmentComplaintDetailPageState
    extends State<ViewEquipmentComplaintDetailPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      body: appBackGround(
        context: context,
        child: BlocBuilder<ViewEquipmentComplaintBloc, ViewEquipmentComplaintState>(
          builder: (context, state) {
            if(state is FetchViewEquipmentComplaintDataState){
              return Column(
                children: [
                  _appBar(),
                  const DottedDividerLine(color: Colors.white),
                  SizedBox(
                    height: MediaQuery.of(context).size.height * 0.02,
                  ),
                  Expanded(
                    child: Container(
                      color: AppColor.white,
                      child: SingleChildScrollView(
                        child: Column(
                          children: [
                            ReviewComplaintItemBox(
                              index: state.index,
                              isDetailPage: true,
                              reviewComplaintData: state.reviewComplaintList[state.index],
                            ),
                            CloserWidget(dataState: state),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              );
            } else {
              return const Center(child: CenterLoaderWidget());
            }
          },
        ),
      ),
    );
  }

  Widget _appBar() {
    return AppBar(
      backgroundColor: Colors.transparent,
      title: Align(
        alignment: Alignment.centerLeft,
        child: TextWidget(
          "Complaint Details",
          color: AppColor.white,
          fontSize: AppFont.font_15,
          fontWeight: FontWeight.w600,
        ),
      ),
      actions: [
        Image.asset(
          AppConfig.instanceInit()!.client == Client.iglcng
              ? AppIcon.appLogoIgl
              : AppIcon.appLogoIgl,
          height: MediaQuery.of(context).size.width * 0.13,
          width: MediaQuery.of(context).size.width * 0.13,
        )
      ],
    );
  }



  Widget _verticalSpace() {
    return SizedBox(
      height: MediaQuery.of(context).size.height * 0.02,
    );
  }
}
