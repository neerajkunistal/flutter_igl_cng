import 'package:flutter/material.dart';
import 'package:flutter_igl_cng/ExportFile/app_export_file.dart';
import 'package:flutter_igl_cng/feature/lcv/driver/registration/domain/bloc/registration_bloc.dart';
import 'package:flutter_igl_cng/feature/lcv/driver/registration/presentation/pages/registration_page.dart';
import 'package:flutter_igl_cng/feature/lcv/driver/viewDriver/domain/bloc/driver_bloc.dart';
import 'package:flutter_igl_cng/feature/lcv/driver/viewDriver/domain/model/driver_model.dart';
import 'package:flutter_igl_cng/feature/lcv/driver/viewDriver/presentation/widget/driver_item_box_widget.dart';

import 'package:flutter_igl_cng/utils/commonClass/user_info.dart';

class DriverPage extends StatefulWidget {
  const DriverPage({super.key});

  @override
  State<DriverPage> createState() => _DriverPageState();
}

class _DriverPageState extends State<DriverPage> {
  final LoginDataModel _userData = UserInfo.instance!.userData!;

  LoginDataModel get userData => _userData;

  @override
  void initState() {
    BlocProvider.of<DriverBloc>(context)
        .add(DriverPageLoadEvent(context: context));
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0.0,
        title: TextWidget(
          AppString.lcvDriver,
          color: AppColor.white,
          fontSize: AppFont.font_16,
        ),
        actions: [
          userData.roleType == RoleType.admin ||
                  userData.roleType == RoleType.manager
              ? IconButton(
                  onPressed: () {
                    BlocProvider.of<RegistrationBloc>(context).add(
                        RegistrationEditEvent(
                            driverData: DriverModel(), isEdit: false));
                    Navigator.of(context).push(MaterialPageRoute(
                        builder: (context) => const RegistrationPage()));
                  },
                  icon: Icon(
                    Icons.add,
                    color: AppColor.white,
                  ))
              : const SizedBox.shrink(),
        ],
      ),
      body: BlocBuilder<DriverBloc, DriverState>(
        builder: (context, state) {
          if (state is DriverPageLoadState) {
            return const Center(
              child: CenterLoaderWidget(),
            );
          } else if (state is FetchDriverDateState) {
            return _listBuilder(dataState: state);
          } else {
            return const Center(
              child: CenterLoaderWidget(),
            );
          }
        },
      ),
    );
  }

  Widget _listBuilder({required FetchDriverDateState dataState}) {
    return Container(
      margin: EdgeInsets.all(MediaQuery.of(context).size.width * 0.02),
      child: dataState.driverList.isNotEmpty
          ? ListView.builder(
              itemCount: dataState.driverList.length,
              shrinkWrap: true,
              itemBuilder: (context, index) {
                return DriverItemBoxWidget(
                    driverData: dataState.driverList[index], index: index);
              })
          : const Center(
              child: TextWidget("No Driver Found"),
            ),
    );
  }
}
