import 'package:flutter/material.dart';
import 'package:flutter_igl_cng/ExportFile/app_export_file.dart';
import 'package:flutter_igl_cng/feature/changePassword/presentation/pages/change_password_page.dart';
import 'package:flutter_igl_cng/feature/home/domain/model/drawer_model.dart';
import 'package:flutter_igl_cng/feature/home/presentation/widget/logout_widget.dart';
import 'package:flutter_igl_cng/feature/materialDetail/presentation/page/material_detail_page.dart';
import 'package:flutter_igl_cng/feature/podDetail/presentation/page/pod_detail_page.dart';
import 'package:flutter_igl_cng/utils/commonClass/fade_route.dart';
import 'package:flutter_igl_cng/utils/commonClass/user_info.dart';
import 'package:flutter_igl_cng/utils/commonWidgets/custome_switch.dart';

class HomeDrawerWidget extends StatelessWidget {
  HomeDrawerWidget({super.key});

  final LoginDataModel _userData = UserInfo.instance!.userData!;

  LoginDataModel get userData => _userData;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<HomeBloc, HomeState>(
      builder: (context, state) {
        if (state is FetchHomeDataState) {
          return Container(
            color: AppColor.white,
            child: Container(
              // color: AppColor.white,
              width: MediaQuery.of(context).size.width / 1.5,
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    Color.fromARGB(255, 85, 124, 18),
                    Color.fromRGBO(200, 169, 20, 18),
                    Color.fromARGB(255, 85, 124, 18),
                  ],
                ),
              ),
              padding: EdgeInsets.all(MediaQuery.of(context).size.width * 0.03),
              child: ListView(
                children: [
                  _header(context: context),
                  SizedBox(
                    height: MediaQuery.of(context).size.width * 0.10,
                  ),
                  _listBuilder(dataState: state),

                  state.roleType != RoleType.stationUser ?
                  _materialDetail(context: context): const SizedBox.shrink(),

                  state.roleType != RoleType.stationUser ?
                  _podDetail(context: context) : const SizedBox.shrink(),

                  _notificationSetting(context: context, dataState: state),

                  _changePassword(context: context),

                  _logout(context: context),
                ],
              ),
            ),
          );
        } else {
          return const Center(
            child: CenterLoaderWidget(),
          );
        }
      },
    );
  }

  Widget _header({required BuildContext context}) {
    return Row(
      children: [
        ClipRRect(
          borderRadius: BorderRadius.circular(8.0),
          child: Image.asset(
            AppConfig.instanceInit()!.client == Client.iglcng
                ? AppIcon.appLogoIgl
                : AppIcon.appLogoIgl,
            height: MediaQuery.of(context).size.width * 0.15,
            width: MediaQuery.of(context).size.width * 0.15,
          ),
        ),
        SizedBox(
          width: MediaQuery.of(context).size.width * 0.03,
        ),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              TextWidget(
                " ${userData.roleName} ${userData.stationName.toString().isNotEmpty ? " - ${userData.stationName.toString()}": ""}",
                fontSize: AppFont.font_14,
                color: AppColor.white,
              ),
              TextWidget(
                userData.email.toString(),
                color: AppColor.white,
                fontSize: AppFont.font_12,
              ),
            ],
          ),
        )
      ],
    );
  }

  Widget _listBuilder({required FetchHomeDataState dataState}) {
    return ListView.builder(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        itemCount: dataState.drawerList.length,
        itemBuilder: (context, index) {
          return _itemBuilder(
              context: context,
              drawerData: dataState.drawerList[index],
              index: index);
        });
  }

  Widget _itemBuilder(
      {required BuildContext context,
      required DrawerModel drawerData,
      required int index}) {
    return GestureDetector(
      onTap: () {
        if (drawerData.sublist.isEmpty) {
          Navigator.pop(context);
        }
        if (drawerData.isSelected == false) {
          BlocProvider.of<HomeBloc>(context).add(HomeDrawerItemSelectedEvent(
              isSelected: true, index: index, context: context));
        }
      },
      child: Padding(
        padding: EdgeInsets.only(
            top: MediaQuery.of(context).size.width * 0.02,
            bottom: MediaQuery.of(context).size.width * 0.02),
        child: Column(
          children: [
            Row(
              children: [
                Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(5),
                    color: Colors.white.withOpacity(.2),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(5.0),
                    child: Icon(
                      drawerData.icon,
                      color: drawerData.isSelected == true
                          ? AppColor.white
                          : AppColor.white,
                    ),
                  ),
                ),
                SizedBox(
                  width: MediaQuery.of(context).size.width * 0.03,
                ),
                Expanded(
                  child: TextWidget(
                    drawerData.label,
                    fontSize: AppFont.font_13,
                    color: drawerData.isSelected == true
                        ? AppColor.white
                        : AppColor.white,
                    fontWeight: drawerData.isSelected == true
                        ? FontWeight.w700
                        : FontWeight.w400,
                  ),
                ),
                Icon(
                  drawerData.isSelected == true && drawerData.sublist.isNotEmpty
                      ? Icons.keyboard_arrow_down_sharp
                      : Icons.keyboard_arrow_right_sharp,
                  color: AppColor.white,
                ),
              ],
            ),
            drawerData.isSublistLoader == false ||
                    drawerData.isSublistLoader == null
                ? drawerData.sublist.isNotEmpty && drawerData.isSelected == true
                    ? _subListBuilder(
                        context: context,
                        drawerData: drawerData,
                        listIndex: index)
                    : const SizedBox.shrink()
                : const DottedLoaderWidget(),
          ],
        ),
      ),
    );
  }

  Widget _subListBuilder(
      {required BuildContext context,
      required DrawerModel drawerData,
      required int listIndex}) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: ListView.builder(
          shrinkWrap: true,
          itemCount: drawerData.sublist.length,
          physics: const NeverScrollableScrollPhysics(),
          itemBuilder: (context, index) {
            return Padding(
              padding: const EdgeInsets.all(5.0),
              child: GestureDetector(
                onTap: () {
                  Navigator.of(context).pop();
                  BlocProvider.of<HomeBloc>(context).add(
                      HomeDrawerItemSubListSelectedEvent(
                          isSelected: true,
                          index: index,
                          listIndex: listIndex));
                },
                child: Row(
                  children: [
                    Icon(
                      Icons.circle,
                      size: MediaQuery.of(context).size.width * 0.03,
                      color: drawerData.sublist[index].isSelected == true
                          ? AppColor.themeColor
                          : AppColor.white,
                    ),
                    SizedBox(
                      width: MediaQuery.of(context).size.width * 0.03,
                    ),
                    Expanded(
                      child: TextWidget(
                        drawerData.sublist[index].label.toString(),
                        fontSize: AppFont.font_12,
                        color: drawerData.sublist[index].isSelected == true
                            ? AppColor.themeColor
                            : AppColor.white,
                      ),
                    ),
                    Icon(
                      Icons.keyboard_arrow_right_sharp,
                      color: AppColor.white,
                    ),
                  ],
                ),
              ),
            );
          }),
    );
  }


  Widget _materialDetail({required BuildContext context}) {
    return Padding(
      padding: EdgeInsets.only(
          top: MediaQuery.of(context).size.width * 0.02,
          bottom: MediaQuery.of(context).size.width * 0.02),
      child: GestureDetector(
        onTap: () {
          Navigator.pop(context);
          Navigator.push(context,
              FadeRoute(page: const MaterialDetailPage()));
        },
        child: Row(
          children: [
            Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(5),
                // color: Colors.white.withOpacity(.2),
              ),
              child: Padding(
                padding: const EdgeInsets.all(7.0),
                child: Icon(
                  Icons.account_tree_outlined,
                  color: AppColor.white,
                ),
              ),
            ),
            SizedBox(
              width: MediaQuery.of(context).size.width * 0.02,
            ),
            TextWidget(
              AppString.materialDetail,
              fontSize: AppFont.font_14,
              color: AppColor.white,
            ),
          ],
        ),
      ),
    );
  }

  Widget _podDetail({required BuildContext context}) {
    return Padding(
      padding: EdgeInsets.only(
          top: MediaQuery.of(context).size.width * 0.02,
          bottom: MediaQuery.of(context).size.width * 0.02),
      child: GestureDetector(
        onTap: () {
          Navigator.pop(context);
          Navigator.push(context,
              FadeRoute(page: const PodDetailPage()));
        },
        child: Row(
          children: [
            Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(5),
                // color: Colors.white.withOpacity(.2),
              ),
              child: Padding(
                padding: const EdgeInsets.all(7.0),
                child: Icon(
                  Icons.price_change_outlined,
                  color: AppColor.white,
                ),
              ),
            ),
            SizedBox(
              width: MediaQuery.of(context).size.width * 0.02,
            ),
            TextWidget(
              AppString.podDetail,
              fontSize: AppFont.font_14,
              color: AppColor.white,
            ),
          ],
        ),
      ),
    );
  }

  Widget _notificationSetting({required BuildContext context, required FetchHomeDataState dataState}) {
    return Padding(
      padding: EdgeInsets.only(
          top: MediaQuery.of(context).size.width * 0.02,
          bottom: MediaQuery.of(context).size.width * 0.02),
      child: Row(
        children: [
          Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(5),
              // color: Colors.white.withOpacity(.2),
            ),
            child: Padding(
              padding: const EdgeInsets.all(7.0),
              child: Icon(
                Icons.circle_notifications_outlined,
                color: AppColor.white,
              ),
            ),
          ),
          SizedBox(
            width: MediaQuery.of(context).size.width * 0.02,
          ),
          Expanded(
            child: TextWidget(
              AppString.silentNotification,
              fontSize: AppFont.font_14,
              color: AppColor.white,
            ),
          ),
          CustomSwitch(
              // activeColor: AppColor.themeColor,
              value: dataState.isNotificationSilent,
              onChanged: (value) {
                BlocProvider.of<HomeBloc>(context).add(
                    HomePageNotificationSilentEvent(context: context));
          })
/*          IconButton(
              onPressed: () {
                BlocProvider.of<HomeBloc>(context).add(
                    HomePageNotificationSilentEvent(context: context));
              }, icon:  Icon(dataState.isNotificationSilent == false ?
          Icons.toggle_off : Icons.toggle_on,
            color: dataState.isNotificationSilent == false ? Colors.grey[800] : AppColor.white,
            size: MediaQuery.of(context).size.width * 0.10,
          )
          )*/
        ],
      ),
    );
  }

  Widget _changePassword({required BuildContext context}) {
    return Padding(
      padding: EdgeInsets.only(
          top: MediaQuery.of(context).size.width * 0.02,
          bottom: MediaQuery.of(context).size.width * 0.02),
      child: GestureDetector(
        onTap: () {
          Navigator.pop(context);
          Navigator.push(context,
              FadeRoute(page: const ChangePasswordPage()));
        },
        child: Row(
          children: [
            Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(5),
                // color: Colors.white.withOpacity(.2),
              ),
              child: Padding(
                padding: const EdgeInsets.all(7.0),
                child: Icon(
                  Icons.password,
                  color: AppColor.white,
                ),
              ),
            ),
            SizedBox(
              width: MediaQuery.of(context).size.width * 0.02,
            ),
            TextWidget(
              AppString.changePassword,
              fontSize: AppFont.font_14,
              color: AppColor.white,
            ),
          ],
        ),
      ),
    );
  }

  Widget _logout({required BuildContext context}) {
    return Padding(
      padding: EdgeInsets.only(
          top: MediaQuery.of(context).size.width * 0.02,
          bottom: MediaQuery.of(context).size.width * 0.02),
      child: GestureDetector(
        onTap: () {
          showModalBottomSheet(
              context: context, builder: (context) => const LogoutWidget());
        },
        child: Row(
          children: [
            Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(5),
                // color: Colors.white.withOpacity(.2),
              ),
              child: Padding(
                padding: const EdgeInsets.all(7.0),
                child: Icon(
                  Icons.logout,
                  color: AppColor.white,
                ),
              ),
            ),
            SizedBox(
              width: MediaQuery.of(context).size.width * 0.02,
            ),
            TextWidget(
              AppString.logout,
              fontSize: AppFont.font_14,
              color: AppColor.white,
            ),
          ],
        ),
      ),
    );
  }
}
