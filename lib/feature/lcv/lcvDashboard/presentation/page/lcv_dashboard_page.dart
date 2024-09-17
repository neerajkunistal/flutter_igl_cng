import 'package:flutter/material.dart';
import 'package:flutter_igl_cng/ExportFile/app_export_file.dart';
import 'package:flutter_igl_cng/feature/home/presentation/widget/home_drawer_widget.dart';
import 'package:flutter_igl_cng/feature/lcv/assignment/addAssignment/domain/bloc/add_assignment_bloc.dart';
import 'package:flutter_igl_cng/feature/lcv/assignment/viewAssignment/domain/model/assginment_model.dart';
import 'package:flutter_igl_cng/feature/lcv/lcvDashboard/domain/bloc/lcv_dashboard_bloc.dart';
import 'package:flutter_igl_cng/feature/lcv/lcvTruckLiveRoute/domain/bloc/lcv_truck_live_route_bloc.dart';
import 'package:flutter_igl_cng/utils/commonClass/user_info.dart';
import 'package:flutter_igl_cng/utils/commonWidgets/dotted_line_widget.dart';

class LcvDashboardPage extends StatefulWidget {
  const LcvDashboardPage({super.key});

  @override
  State<LcvDashboardPage> createState() => _LcvDashboardPageState();
}

class _LcvDashboardPageState extends State<LcvDashboardPage> {

  @override
  void initState() {
    BlocProvider.of<LcvDashboardBloc>(context).add(LcvDashboardPageLoadEvent(context: context));
    super.initState();
  }

  final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    LoginDataModel userData  =  UserInfo.instanceInit()!.userData!;
    return Scaffold(
        extendBodyBehindAppBar: true,
        key: scaffoldKey,
        bottomNavigationBar:
        BlocBuilder<LcvDashboardBloc, LcvDashboardState>(builder: (context, state) {
          if (state is FetchLcvDashboardDataState) {
            return state.bottomNavigationBarItemList.isNotEmpty
                ? BottomNavigationBar(
              currentIndex: state.bottomTabIndex,
              onTap: (index) {
                if(index == 1){
                  BlocProvider.of<AddAssignmentBloc>(context)
                      .add(AddAssignmentSetAssignmentDataEvent(assignmentData: AssignmentModel()));
                }
                BlocProvider.of<LcvDashboardBloc>(context).add(
                    LcvDashboardChangeBottomNavigationItemEvent(
                        index: index, context: context));
              },
              items: state.bottomNavigationBarItemList,
            ) : const SizedBox.shrink();
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
                child:
                BlocBuilder<LcvDashboardBloc, LcvDashboardState>(builder: (context, state) {
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
      title: BlocBuilder<LcvDashboardBloc, LcvDashboardState>(builder: (context, state) {
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
}
