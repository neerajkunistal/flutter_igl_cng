import 'package:flutter/material.dart';
import 'package:flutter_igl_cng/ExportFile/app_export_file.dart';
import 'package:flutter_igl_cng/feature/lcv/cngScmInfo/addCngScm/presentation/page/add_cng_scm_page.dart';
import 'package:flutter_igl_cng/feature/lcv/cngScmInfo/viewCngScm/domain/bloc/view_cng_scm_bloc.dart';
import 'package:flutter_igl_cng/feature/lcv/cngScmInfo/viewCngScm/presentation/widget/view_cng_scm_item_box_widget.dart';
import 'package:flutter_igl_cng/utils/commonClass/user_info.dart';

class ViewCngScmPage extends StatefulWidget {
  const ViewCngScmPage({super.key});

  @override
  State<ViewCngScmPage> createState() => _ViewCngScmPageState();
}

class _ViewCngScmPageState extends State<ViewCngScmPage> {
  @override
  void initState() {
    BlocProvider.of<ViewCngScmBloc>(context)
        .add(ViewCngScmPageLoadEvent(context: context));
    super.initState();
  }

  final LoginDataModel _userData = UserInfo.instance!.userData!;

  LoginDataModel get userData => _userData;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0.0,
        title: TextWidget(
          AppString.cngScmInfo,
          color: AppColor.white,
          fontSize: AppFont.font_16,
        ),
        actions: [
          userData.roleType == RoleType.cngStation
              ? IconButton(
                  onPressed: () {
                    Navigator.of(context).push(MaterialPageRoute(
                        builder: (context) => const AddCngScmPage()));
                  },
                  icon: Icon(
                    Icons.add,
                    color: AppColor.white,
                  ))
              : const SizedBox.shrink(),
        ],
      ),
      body: BlocBuilder<ViewCngScmBloc, ViewCngScmState>(
        builder: (context, state) {
          if (state is FetchViewCngScmDataState) {
            return _itemBuilder(dataState: state);
          } else {
            return const Center(
              child: CenterLoaderWidget(),
            );
          }
        },
      ),
    );
  }

  Widget _itemBuilder({required FetchViewCngScmDataState dataState}) {
    return dataState.cngScmList.isNotEmpty
        ? ListView.builder(
            itemCount: dataState.cngScmList.length,
            shrinkWrap: true,
            itemBuilder: (context, index) {
              return ViewCngScmItemBoxWidget(
                  index: index, cngScmData: dataState.cngScmList[index]);
            })
        : const Center(
            child: TextWidget("No Cng Scm Info Data"),
          );
  }
}
