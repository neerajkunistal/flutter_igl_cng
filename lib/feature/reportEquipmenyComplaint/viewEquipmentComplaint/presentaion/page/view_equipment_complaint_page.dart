import 'package:flutter/material.dart';
import 'package:flutter_igl_cng/ExportFile/app_export_file.dart';
import 'package:flutter_igl_cng/utils/commonWidgets/background_widget.dart';

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
            floatingActionButton: userData.roleType == RoleType.stationUser ||
                    userData.roleType == RoleType.stationUserManager
                ? _floatingActionButton()
                : const SizedBox.shrink(),
            extendBodyBehindAppBar: true,
            body: AppBackgroundWidget(
              child: Column(children: [
                _appBar(),
                const DottedDividerLine(color: Colors.white),
                SizedBox(
                  height: MediaQuery.of(context).size.height * 0.02,
                ),
                const Expanded(child: ViewEquipmentWidget()),
              ]),
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
          AppConfig.instanceInit()!.client == Client.igl
              ? AppIcon.appLogoIgl
              : AppConfig.instanceInit()!.client == Client.pbgpl
                  ? AppIcon.appLogoPurvaBharti
                  : AppConfig.instanceInit()!.client == Client.mahanagar
                      ? AppIcon.appLogoMGL
                      : AppConfig.instanceInit()!.client == Client.hpcl
                          ? AppIcon.appLogoHPCL
                          : AppIcon.appLogoIgl,
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
      backgroundColor: EnvironmentConfig.of(context)!.primaryTheme,
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
