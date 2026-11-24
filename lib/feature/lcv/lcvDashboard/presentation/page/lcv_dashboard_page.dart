import 'package:flutter/material.dart';
import 'package:flutter_igl_cng/ExportFile/app_export_file.dart';
import 'package:flutter_igl_cng/feature/lcv/assignment/addAssignment/domain/bloc/add_assignment_bloc.dart';
import 'package:flutter_igl_cng/feature/lcv/assignment/viewAssignment/domain/model/assginment_model.dart';
import 'package:flutter_igl_cng/feature/lcv/lcvDashboard/domain/bloc/lcv_dashboard_bloc.dart';
import 'package:flutter_igl_cng/feature/lcv/overSpeedAlert/domain/bloc/over_speed_alert_bloc.dart';
import 'package:flutter_igl_cng/feature/lcv/overSpeedAlert/presentation/page/over_speed_alert_page.dart';
import 'package:flutter_igl_cng/utils/commonClass/fade_route.dart';
import 'package:flutter_igl_cng/utils/commonClass/user_info.dart';
import 'package:flutter_igl_cng/utils/commonWidgets/dotted_line_widget.dart';
import 'package:vibration/vibration.dart';

class LcvDashboardPage extends StatefulWidget {
  const LcvDashboardPage({super.key});

  @override
  State<LcvDashboardPage> createState() => _LcvDashboardPageState();
}

class _LcvDashboardPageState extends State<LcvDashboardPage> {
  @override
  void initState() {
    BlocProvider.of<LcvDashboardBloc>(context)
        .add(LcvDashboardPageLoadEvent(context: context));
    BlocProvider.of<OverSpeedAlertBloc>(context).add(
        OverSpeedAlertPageLoadEvent(context: context));
    super.initState();
  }

  final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    LoginDataModel userData = UserInfo.instanceInit()!.userData!;
    return Scaffold(
        extendBodyBehindAppBar: true,
        key: scaffoldKey,
        bottomNavigationBar: BlocBuilder<LcvDashboardBloc, LcvDashboardState>(
            builder: (context, state) {
          if (state is FetchLcvDashboardDataState) {
            return state.bottomNavigationBarItemList.isNotEmpty
                ? BottomNavigationBar(
                    currentIndex: state.bottomTabIndex,
                    onTap: (index) {
                      if (index == 1) {
                        BlocProvider.of<AddAssignmentBloc>(context).add(
                            AddAssignmentSetAssignmentDataEvent(
                                assignmentData: AssignmentModel()));
                      }
                      BlocProvider.of<LcvDashboardBloc>(context).add(
                          LcvDashboardChangeBottomNavigationItemEvent(
                              index: index, context: context));
                    },
                    items: state.bottomNavigationBarItemList,
                  )
                : const SizedBox.shrink();
          } else {
            return const SizedBox.shrink();
          }
        }),
        body: appBackGround(
          context: context,
          child: Column(
            children: [
              _appBar(userData),
              const DottedDividerLine(color: Colors.white),
              SizedBox(
                height: MediaQuery.of(context).size.height * 0.02,
              ),
              Expanded(
                child: BlocBuilder<LcvDashboardBloc, LcvDashboardState>(
                    builder: (context, state) {
                  if (state is FetchLcvDashboardDataState) {
                    return state.childWidget;
                  } else {
                    return const Center(
                      child: CenterLoaderWidget(),
                    );
                  }
                }),
              ),
            ],
          ),
        ));
  }

  Widget _appBar(LoginDataModel userData) {
    return AppBar(
      elevation: 0,
      title: BlocBuilder<LcvDashboardBloc, LcvDashboardState>(
          builder: (context, state) {
        if (state is FetchLcvDashboardDataState) {
          return TextWidget(
            textAlign: TextAlign.start,
            state.title,
            color: AppColor.white,
            fontSize: AppFont.font_13,
            fontWeight: FontWeight.w700,
          );
        } else {
          return TextWidget(
            AppString.appName,
            color: AppColor.white,
            fontSize: AppFont.font_14,
            fontWeight: FontWeight.w700,
          );
        }
      }),
      backgroundColor: Colors.transparent,
      actions: [
        BlocBuilder<OverSpeedAlertBloc, OverSpeedAlertState>(
            builder: (context, state) {
              if (state is FetchOverSpeedAlertDataState) {
                return _notificationWidget(dataState: state);
              } else {
                return const SizedBox.shrink();
              }
            }),
        Image.asset(
          AppConfig.instanceInit()!.client == Client.iglcng
              ? AppIcon.appLogoIgl
              : AppIcon.appLogoIgl,
          height: MediaQuery.of(context).size.width * 0.13,
          width: MediaQuery.of(context).size.width * 0.13,
        ),
      ],
    );
  }

  Widget _notificationWidget({required FetchOverSpeedAlertDataState dataState}) {
    return Stack(
      children: [
        IconButton(
            onPressed: () async {
              if (await Vibration.hasAmplitudeControl() != null) {
              Vibration.vibrate(duration: 100);
              }
              Navigator.push(
              !context.mounted ? context : context,
              FadeRoute(page: const OverSpeedAlertPage() ),
              );
            },
            icon: Icon(
              Icons.notifications_none,
              color: AppColor.white,
            )),

        dataState.overSpeedAlertList.isNotEmpty ?
        Positioned(
          top: 10,
          right: 10,
          child: CircleAvatar(
            backgroundColor: AppColor.red,
            radius: 8,
            child: Center(
              child: TextWidget(
                "${dataState.overSpeedAlertList.length}",
                color: AppColor.white,
                fontSize: AppFont.font_10,),
            ),
          ),
        ): const SizedBox.shrink(),
      ],
    );
  }
}
