import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_igl_cng/ExportFile/app_export_file.dart';
import 'package:flutter_igl_cng/feature/reviewComplaint/presentation/widget/review_complaint_item_box.dart';
import 'package:flutter_igl_cng/utils/commonClass/user_info.dart';
import 'package:flutter_igl_cng/utils/commonWidgets/dotted_line_widget.dart';
import 'package:flutter_igl_cng/utils/commonWidgets/message_box_two_button_pop.dart';

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
                      child: Column(
                        children: [
                          ReviewComplaintItemBox(
                            index: state.index,
                            reviewComplaintData: state.reviewComplaintList[state.index],
                          ),
                          _verticalSpace(),
                          _closureButton(
                              context: context,
                              reviewComplaintData: state.reviewComplaintList[state.index],
                              index: state.index),
                        ],
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

  Widget _closureButton({required BuildContext context,
    required ReviewComplaintModel reviewComplaintData,
    required int index,
  })  {
    LoginDataModel userData =  UserInfo.instance!.userData!;
    return reviewComplaintData.miAssignToUser.toString().isEmpty &&
        reviewComplaintData.complaintStatus.toString() == "0" &&
        userData.roleType == RoleType.stationUser  ?
    Align(
      alignment: Alignment.center,
      child: SizedBox(
        width: MediaQuery.of(context).size.width/3,
        child: reviewComplaintData.isSelected == false ?
        ButtonWidget(
          backgroundColor: AppColor.red,
          text: "Closure",
          fontSize: AppFont.font_12,
          onPressed: () async {

            if(await _onClosureComplaintPop(context: context) == true){
              BlocProvider.of<ViewEquipmentComplaintBloc>(!context.mounted ? context: context).add(
                  ViewEquipmentComplaintClosureEvent(context: context.mounted ? context: context,
                      reviewComplaintData: reviewComplaintData, index: index));
            }
          },
        ) : const DottedLoaderWidget(),
      ),
    ) : const SizedBox.shrink();
  }

  Future<bool> _onClosureComplaintPop({required BuildContext context}) async {
    return (await showDialog(
        context: context,
        builder: (BuildContext mContext) => MessageBoxTwoButtonPopWidget(
            message: "Do you want to closure complaint?",
            okButtonText: "Closure",
            okButtonColour: AppColor.red,
            onPressed: () => Navigator.of(context).pop(true)))) ??
        false;
  }

  Widget _verticalSpace() {
    return SizedBox(
      height: MediaQuery.of(context).size.height * 0.02,
    );
  }
}
