import 'package:flutter/material.dart';
import 'package:flutter_igl_cng/ExportFile/app_export_file.dart';
import 'package:flutter_igl_cng/feature/home/presentation/widget/home_drawer_widget.dart';
import 'package:flutter_igl_cng/utils/commonWidgets/background_widget.dart';

class PhoneHomeWidget extends StatefulWidget {
  const PhoneHomeWidget({super.key});

  @override
  State<PhoneHomeWidget> createState() => _PhoneHomeWidgetState();
}

class _PhoneHomeWidgetState extends State<PhoneHomeWidget> {
  final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    LoginDataModel userData  =  UserInfo.instanceInit()!.userData!;
    return Scaffold(
        extendBodyBehindAppBar: true,
        key: scaffoldKey,
        drawer: HomeDrawerWidget(),
        bottomNavigationBar: BlocBuilder<HomeBloc, HomeState>(builder: (context, state) {
          if (state is FetchHomeDataState) {
            return state.bottomNavigationBarItemList.isNotEmpty
                ? BottomNavigationBar(
                    currentIndex: state.bottomTabIndex,
                    onTap: (index) {
                      if(index == 1){
                        BlocProvider.of<AddAssignmentBloc>(context)
                            .add(AddAssignmentSetAssignmentDataEvent(assignmentData: AssignmentModel()));
                      }
                      BlocProvider.of<HomeBloc>(context).add(
                          HomeChangeBottomNavigationItemEvent(
                              index: index, context: context));
                    },
                    items: state.bottomNavigationBarItemList,
                  )
                : const SizedBox.shrink();
          } else {
            return const SizedBox.shrink();
          }
        }),
        body: AppBackgroundWidget(
          child: Column(
            children: [
              _appBar(userData),
              const DottedDividerLine(color: Colors.white),
              SizedBox(
                height: MediaQuery.of(context).size.height * 0.02,
              ),
              Expanded(
                child:
                    BlocBuilder<HomeBloc, HomeState>(builder: (context, state) {
                  if (state is FetchHomeDataState) {
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
      title: BlocBuilder<HomeBloc, HomeState>(builder: (context, state) {
        if (state is FetchHomeDataState) {
          return Align(
            alignment: Alignment.centerLeft,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                TextWidget(
                  textAlign: TextAlign.start,
                  state.title,
                  color: AppColor.white,
                  fontSize: AppFont.font_13,
                  fontWeight: FontWeight.w700,
                ),
                TextWidget(
                  textAlign: TextAlign.start,
                  "${userData.email}",
                  color: AppColor.white,
                  fontSize: AppFont.font_12,
                  fontWeight: FontWeight.w700,
                ),
              ],
            ),
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
        ),
      ],
      leading: IconButton(
        icon: Image.asset(AppIcon.menuIcon,
          color: Colors.white,
          height: MediaQuery.of(context).size.width * 0.07,
          width: MediaQuery.of(context).size.width * 0.07,),
        onPressed: () => scaffoldKey.currentState!.openDrawer(),
      ),
    );
  }
}
