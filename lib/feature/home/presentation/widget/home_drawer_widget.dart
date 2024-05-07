import 'package:flutter/material.dart';
import 'package:flutter_igl_cng/ExportFile/app_export_file.dart';
import 'package:flutter_igl_cng/feature/acknowledge/presentation/page/acknowledge_page.dart';
import 'package:flutter_igl_cng/feature/home/domain/bloc/home_bloc.dart';
import 'package:flutter_igl_cng/feature/home/domain/model/drawer_model.dart';
import 'package:flutter_igl_cng/feature/home/presentation/widget/logout_widget.dart';
import 'package:flutter_igl_cng/feature/login/domain/models/login_model.dart';
import 'package:flutter_igl_cng/feature/miComplaint/presentation/page/mi_complaint_page.dart';
import 'package:flutter_igl_cng/feature/reportEquipmenyComplaint/viewEquipmentComplaint/presentaion/page/view_equipment_complaint_page.dart';
import 'package:flutter_igl_cng/feature/reviewComplaint/presentation/page/review_complaint_page.dart';
import 'package:flutter_igl_cng/utils/commonClass/app_config.dart';
import 'package:flutter_igl_cng/utils/commonClass/user_info.dart';

class HomeDrawerWidget extends StatelessWidget {
  HomeDrawerWidget({super.key});

  final LoginDataModel _userData =  UserInfo.instance!.userData!;
  LoginDataModel get userData => _userData;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<HomeBloc, HomeState>(
  builder: (context, state) {
    if(state is FetchHomeDataState) {
      return  Container(
        color: AppColor.white,
        width: MediaQuery.of(context).size.width/1.5,
        padding: EdgeInsets.all(MediaQuery.of(context).size.width * 0.03),
        child: ListView(
          children: [
            _header(context: context),
            const Divider(),
            _listBuilder(dataState: state),
/*            _changePassword(context: context),*/
/*            userData.roleType == RoleType.shiftEngineer
                ? _acknowledge(context: context) : const SizedBox.shrink(),
            _viewEquipmentComplaint(context: context),
            userData.roleType == RoleType.mi
            ? _miComplaint(context: context): const SizedBox.shrink(),*/
            _logout(context: context),
          ],
          ),
        );
      }  else {
        return const Center(child: CenterLoaderWidget(),);
      }
  },
);
  }

  Widget _header({required BuildContext context}) {
    return Row(
      children: [
        ClipRRect(
          borderRadius: BorderRadius.circular(8.0),
          child: Image.asset(AppConfig.instanceInit()!.client == Client.iglcng ?
                  AppIcon.appLogoIgl
                : AppIcon.appLogoIgl,
            height: MediaQuery.of(context).size.width * 0.12,
            width: MediaQuery.of(context).size.width * 0.12,
          ),
        ),
        SizedBox(
          width: MediaQuery.of(context).size.width * 0.03,
        ),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              TextWidget(userData.name.toString(),
                fontSize: AppFont.font_14,
              ),
              TextWidget(userData.email.toString(),
                color: AppColor.grey,
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
        return _itemBuilder(context: context, drawerData: dataState.drawerList[index], index: index);
      });
  }

  Widget _itemBuilder({required BuildContext context, required DrawerModel drawerData, required int index}) {
    return GestureDetector(
      onTap: () {
        if(drawerData.sublist.isEmpty){
          Navigator.pop(context);
        }
        if(drawerData.isSelected == false){
          BlocProvider.of<HomeBloc>(context).add(HomeDrawerItemSelectedEvent(
              isSelected: true , index:  index, context: context));
        }
      },
      child: Padding(
        padding:  EdgeInsets.only(top: MediaQuery.of(context).size.width * 0.02,
            bottom:  MediaQuery.of(context).size.width * 0.02),
        child: Column(
          children: [
            Row(
              children: [
                Icon(drawerData.icon, color: drawerData.isSelected == true ? AppColor.themeColor :AppColor.black,),
                SizedBox(
                  width: MediaQuery.of(context).size.width * 0.03,
                ),
                Expanded(
                  child: TextWidget(drawerData.label,
                    fontSize: AppFont.font_13,
                    color: drawerData.isSelected == true ? AppColor.themeColor :AppColor.black,
                    fontWeight: drawerData.isSelected == true ? FontWeight.w700 : FontWeight.w400,
                  ),
                ),

                Icon(drawerData.isSelected == true && drawerData.sublist.isNotEmpty  ?
                Icons.keyboard_arrow_down_sharp  : Icons.keyboard_arrow_right_sharp, color: AppColor.black,),
              ],
            ),
            drawerData.isSublistLoader == false
                || drawerData.isSublistLoader == null ?
            drawerData.sublist.isNotEmpty && drawerData.isSelected == true
                ? _subListBuilder(context: context, drawerData: drawerData, listIndex: index)
                : const SizedBox.shrink(): const DottedLoaderWidget(),
          ],
        ),
      ),
    );
  }

  Widget _subListBuilder({required BuildContext context, required DrawerModel drawerData, required int listIndex}) {
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
                  BlocProvider.of<HomeBloc>(context).add(HomeDrawerItemSubListSelectedEvent(
                     isSelected: true, index: index, listIndex: listIndex
                  ));
                },
                child: Row(
                  children: [
                    Icon(Icons.circle,
                      size: MediaQuery.of(context).size.width * 0.03,
                      color: drawerData.sublist[index].isSelected == true ? AppColor.themeColor :AppColor.black,),
                    SizedBox(
                      width: MediaQuery.of(context).size.width * 0.03,
                    ),
                    Expanded(
                      child: TextWidget(drawerData.sublist[index].label.toString(),
                        fontSize: AppFont.font_12,
                        color: drawerData.sublist[index].isSelected  == true ? AppColor.themeColor : AppColor.black,
                      ),
                    ),

                    Icon( Icons.keyboard_arrow_right_sharp, color: AppColor.black,),
                  ],
                ),
              ),
            );
          }),
    );
  }

  Widget _logout({required BuildContext context}) {
    return Padding(
      padding:  EdgeInsets.only(top: MediaQuery.of(context).size.width * 0.02,
          bottom:  MediaQuery.of(context).size.width * 0.02),
      child: GestureDetector(
        onTap: () {
          showModalBottomSheet(
              context: context,
              builder: (context) => const LogoutWidget()
          );
        },
        child: Row(
          children: [
            Icon(Icons.logout, color: AppColor.black,),
            SizedBox(
              width: MediaQuery.of(context).size.width * 0.03,
            ),
            TextWidget(AppString.logout,
              fontSize: AppFont.font_12,
            ),
          ],
        ),
      ),
    );
  }
}
