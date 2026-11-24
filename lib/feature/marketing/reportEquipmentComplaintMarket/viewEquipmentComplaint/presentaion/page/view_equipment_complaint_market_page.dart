import 'package:flutter/material.dart';
import 'package:flutter_igl_cng/ExportFile/app_export_file.dart';
import 'package:flutter_igl_cng/feature/marketing/reportEquipmentComplaintMarket/addEquipmentComplaint/presentation/page/add_equipment_complaint_market_page.dart';
import 'package:flutter_igl_cng/feature/marketing/reportEquipmentComplaintMarket/viewEquipmentComplaint/domain/bloc/view_equipment_complaint_market_bloc.dart';
import 'package:flutter_igl_cng/feature/marketing/reportEquipmentComplaintMarket/viewEquipmentComplaint/presentaion/widget/view_equipment_widget_market.dart';
import 'package:flutter_igl_cng/utils/commonClass/user_info.dart';
import 'package:flutter_igl_cng/utils/commonWidgets/dotted_line_widget.dart';

class ViewEquipmentComplaintMarketPage extends StatefulWidget {
  final String? title;
  final EquipmentComplaintType equipmentComplaintType;

  const ViewEquipmentComplaintMarketPage({super.key, this.title, required this.equipmentComplaintType});

  @override
  State<ViewEquipmentComplaintMarketPage> createState() =>
      _ViewEquipmentComplaintMarketPageState();
}

class _ViewEquipmentComplaintMarketPageState extends State<ViewEquipmentComplaintMarketPage>
    with SingleTickerProviderStateMixin {
  @override
  void initState() {
    BlocProvider.of<ViewEquipmentComplaintMarketBloc>(context)
        .add(ViewEquipmentComplaintMarketPageLoadEvent(context: context, equipmentComplaintType: widget.equipmentComplaintType));
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    LoginDataModel userData = UserInfo.instanceInit()!.userData!;
    return userData.roleType == RoleType.shiftEngineer || userData.roleType == RoleType.amo
        ?  ViewEquipmentMarketWidget(equipmentComplaintType: widget.equipmentComplaintType)
        : Scaffold(
      backgroundColor: Colors.transparent,
      floatingActionButtonLocation: FloatingActionButtonLocation.startFloat,
      floatingActionButton: userData.roleType == RoleType.stationUser
          ? _floatingActionButton()
          : const SizedBox.shrink(),
      extendBodyBehindAppBar: true,
      body: appBackGround(
        context: context,
        child: Column(
          children: [
            _appBar(),
            const DottedDividerLine(color: Colors.white),
            SizedBox(
              height: MediaQuery.of(context).size.height * 0.02,
            ),
            Expanded(child: ViewEquipmentMarketWidget(equipmentComplaintType: widget.equipmentComplaintType)),
          ]
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
          widget.title ?? "",
          color: AppColor.white,
          fontSize: AppFont.font_15,
          fontWeight: FontWeight.w600,
        ),
      ),
      actions: [
        Image.asset(
          AppIcon.appLogoIgl,
          height: MediaQuery.of(context).size.width * 0.13,
          width: MediaQuery.of(context).size.width * 0.13,
        )
      ],
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
              builder: (context) =>  AddEquipmentComplaintMarketPage(equipmentComplaintType: widget.equipmentComplaintType)),
        );
        if (res != null && res.toString() == "complete") {
          if (!context.mounted) return;
          BlocProvider.of<ViewEquipmentComplaintMarketBloc>(
                  !context.mounted ? context : context)
              .add(ViewEquipmentComplaintMarketPageLoadEvent(
                  context: !context.mounted ? context : context, equipmentComplaintType: widget.equipmentComplaintType));
        }
      },
      child: Icon(
        Icons.add,
        color: AppColor.white,
      ),
    );
  }

}
