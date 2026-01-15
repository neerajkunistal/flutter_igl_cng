import 'package:flutter/material.dart';
import 'package:flutter_igl_cng/ExportFile/app_export_file.dart';
import 'package:flutter_igl_cng/feature/amo/viewAmoCimplaint/presentation/widget/complaint_images_widget.dart';
import 'package:flutter_igl_cng/feature/cng/viewCng/domain/domain/bloc/view_cng_bloc.dart';
import 'package:flutter_igl_cng/feature/cng/viewCng/domain/domain/model/cng_model.dart';
import 'package:flutter_igl_cng/utils/commonWidgets/dotted_line_widget.dart';

class ViewCngDetailPage extends StatefulWidget {
  const ViewCngDetailPage({super.key});

  @override
  State<ViewCngDetailPage> createState() => _ViewCngDetailPageState();
}

class _ViewCngDetailPageState extends State<ViewCngDetailPage> {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: appBackGround(
          context: context,
        child: Column(
          children: [
            _appBar(),
            const DottedDividerLine(color: Colors.white),
            SizedBox(
              height: MediaQuery.of(context).size.height * 0.02,
            ),
            Expanded(
              child: BlocBuilder<ViewCngBloc, ViewCngState>(
                builder: (context, state) {
                  if (state is FetchViewCngDataState) {
                    return Container(
                        decoration: const BoxDecoration(
                          borderRadius: BorderRadius.only(
                              topLeft: Radius.circular(20),
                              topRight: Radius.circular(20)),
                          color: Colors.white,
                        ),
                        child: SingleChildScrollView(
                            child: _itemBuilder(dataState: state)));
                  } else {
                    return const Center(
                      child: CenterLoaderWidget(),
                    );
                  }
                },
              ),
            ),
          ],
        ),
       )
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
              : AppConfig.instanceInit()!.client == Client.pbgplCNG
              ? AppIcon.appLogoPurvaBharti
              : AppConfig.instanceInit()!.client == Client.mahanagar
              ? AppIcon.appLogoMGL
              : AppIcon.appLogoIgl,
          height: MediaQuery.of(context).size.width * 0.13,
          width: MediaQuery.of(context).size.width * 0.13,
        ),
      ],
    );
  }

  Widget _itemBuilder({required FetchViewCngDataState dataState}) {
    final CngModel cngData =  dataState.cngList[dataState.listIndex];
    String incidentDateTime = "";
    if (cngData.incidentDateTime != null &&
        cngData.incidentDateTime.toString().isNotEmpty) {
      incidentDateTime = DateFormat('dd-MMM-yyyy')
          .format(DateTime.parse(cngData.incidentDateTime.toString()));
    }
    return Stack(
      children: [
        Padding(
          padding: const EdgeInsets.all(10.0),
          child: Column(
            children: [
              Row(
                children: [
                  TextWidget(
                    "Complaint ID : ",
                    fontWeight: FontWeight.w700,
                    fontSize: AppFont.font_13,
                    color: AppColor.themeColor,
                  ),
                  Expanded(
                      child: TextWidget(
                        cngData.complaintNumber,
                        textAlign: TextAlign.right,
                        fontWeight: FontWeight.w700,
                        fontSize: AppFont.font_13,
                      )),
                ],
              ),
              Divider(
                color: AppColor.lightGrey,
              ),
              Row(
                children: [
                  TextWidget(
                    "Station Name : ",
                    fontWeight: FontWeight.w500,
                    fontSize: AppFont.font_13,
                  ),
                  Expanded(
                      child: TextWidget(
                        cngData.cngStation.toString(),
                        fontWeight: FontWeight.w500,
                        textAlign: TextAlign.right,
                        fontSize: AppFont.font_13,
                      )),
                ],
              ),
              SizedBox(
                height: MediaQuery.of(context).size.width * 0.02,
              ),
              Row(
                children: [
                  TextWidget(
                    "Category : ",
                    fontWeight: FontWeight.w500,
                    fontSize: AppFont.font_13,
                  ),
                  Expanded(
                      child: TextWidget(
                        cngData.categoryName.toString(),
                        fontWeight: FontWeight.w500,
                        textAlign: TextAlign.right,
                        fontSize: AppFont.font_13,
                      )),
                ],
              ),
              SizedBox(
                height: MediaQuery.of(context).size.width * 0.02,
              ),
              Row(
                children: [
                  TextWidget(
                    "Date : ",
                    fontWeight: FontWeight.w500,
                    fontSize: AppFont.font_13,
                  ),
                  Expanded(
                      child: TextWidget(
                        incidentDateTime,
                        fontWeight: FontWeight.w500,
                        textAlign: TextAlign.right,
                        fontSize: AppFont.font_13,
                      )),
                ],
              ),
              SizedBox(
                height: MediaQuery.of(context).size.width * 0.02,
              ),
              Row(
                children: [
                  TextWidget(
                    "Complaint Status : ",
                    fontWeight: FontWeight.w500,
                    fontSize: AppFont.font_13,
                  ),
                  Expanded(
                      child: TextWidget(
                        cngData.complaintStatus.toString() == "0"
                            ? "Open"
                            : cngData.complaintStatus.toString() == "1"
                            ? "Closed"
                            : "Reject",
                        fontWeight: FontWeight.w500,
                        fontSize: AppFont.font_13,
                        color: cngData.complaintStatus.toString() == "0"
                            ? AppColor.orange
                            : cngData.complaintStatus.toString() == "1"
                            ? AppColor.green
                            : AppColor.red,
                        textAlign: TextAlign.right,
                      )),
                ],
              ),
              SizedBox(
                height: MediaQuery.of(context).size.width * 0.02,
              ),
              Row(
                children: [
                  TextWidget(
                    "Reported Name: ",
                    fontWeight: FontWeight.w500,
                    fontSize: AppFont.font_13,
                  ),
                  Expanded(
                      child: TextWidget(
                        cngData.reportByName.toString(),
                        fontWeight: FontWeight.w500,
                        textAlign: TextAlign.right,
                        fontSize: AppFont.font_13,
                      )),
                ],
              ),
              SizedBox(
                height: MediaQuery.of(context).size.width * 0.02,
              ),
              Row(
                children: [
                  TextWidget(
                    "Reported Phone: ",
                    fontWeight: FontWeight.w500,
                    fontSize: AppFont.font_13,
                  ),
                  Expanded(
                      child: TextWidget(
                        cngData.reportByPhone.toString(),
                        fontWeight: FontWeight.w500,
                        textAlign: TextAlign.right,
                        fontSize: AppFont.font_13,
                      )),
                ],
              ),
              Divider(
                color: AppColor.lightGrey,
              ),
              Row(
                children: [
                  TextWidget(
                    "Description : ",
                    fontWeight: FontWeight.w500,
                    fontSize: AppFont.font_13,
                  ),
                  Expanded(
                      child: TextWidget(
                        cngData.complaintDescription.toString(),
                        fontWeight: FontWeight.w500,
                        textAlign: TextAlign.right,
                        fontSize: AppFont.font_13,
                      )),
                ],
              ),
              SizedBox(
                height: MediaQuery.of(context).size.width * 0.04,
              ),
              TextWidget("Complaint Images : ",
                fontWeight: FontWeight.bold,
                color: AppColor.black, textAlign: TextAlign.start,),
              ComplaintImagesWidget(imageList: cngData.createdComplaintImagesList ?? []),
            ],
          ),
        ),
      ],
    );
  }
}
