import 'package:flutter/material.dart';
import 'package:flutter_igl_cng/ExportFile/app_export_file.dart';
import 'package:flutter_igl_cng/feature/login/domain/models/login_model.dart';
import 'package:flutter_igl_cng/feature/reportEquipmenyComplaint/addEquipmentComplaint/presentation/page/add_equipment_complaint_page.dart';
import 'package:flutter_igl_cng/feature/reportEquipmenyComplaint/viewEquipmentComplaint/presentaion/widget/view_equipment_widget.dart';
import 'package:flutter_igl_cng/utils/commonClass/user_info.dart';
import 'package:flutter_igl_cng/utils/commonWidgets/dotted_line_widget.dart';

class ViewEquipmentComplaintPage extends StatefulWidget {
  final String? title;

  const ViewEquipmentComplaintPage({super.key, this.title});

  @override
  State<ViewEquipmentComplaintPage> createState() =>
      _ViewEquipmentComplaintPageState();
}

class _ViewEquipmentComplaintPageState extends State<ViewEquipmentComplaintPage>
    with SingleTickerProviderStateMixin {
  @override
  void initState() {
    BlocProvider.of<ViewEquipmentComplaintBloc>(context)
        .add(ViewEquipmentComplaintPageLoadEvent(context: context));
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    LoginDataModel userData = UserInfo.instanceInit()!.userData!;
    return userData.roleType == RoleType.shiftEngineer ||
        userData.roleType == RoleType.mi
        ? const ViewEquipmentWidget()
        : Scaffold(
      backgroundColor: Colors.transparent,
      floatingActionButtonLocation: FloatingActionButtonLocation.startFloat,
      floatingActionButton: userData.roleType == RoleType.stationUser
          ? _floatingActionButton()
          : const SizedBox.shrink(),
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        title: Align(
          alignment: Alignment.centerLeft,
          child: TextWidget(
            widget.title ?? "",
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
      ),

      body: appBackGround(
        context: context,
        child: Column(
          children: [
            const SizedBox(
              height: 40,
            ),
            const DottedDividerLine(color: Colors.white),
            SizedBox(
              height: MediaQuery.of(context).size.height * 0.02,
            ),
            const Expanded(child: ViewEquipmentWidget()),
          ]
        ),
      ),
    );
  }


  Widget _floatingActionButton() {
    return FloatingActionButton(
      shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(15.0))),
      backgroundColor: AppColor.themeColor,
      onPressed: () async {
        var res = await Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) => const AddEquipmentComplaintPage()),
        );
        if (res != null && res.toString() == "complete") {
          if (!context.mounted) return;
          BlocProvider.of<ViewEquipmentComplaintBloc>(
                  !context.mounted ? context : context)
              .add(ViewEquipmentComplaintPageLoadEvent(
                  context: !context.mounted ? context : context));
        }
      },
      child: Icon(
        Icons.add,
        color: AppColor.white,
      ),
    );
  }

}
