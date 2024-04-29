import 'package:flutter/material.dart';
import 'package:flutter_igl_cng/ExportFile/app_export_file.dart';
import 'package:flutter_igl_cng/feature/login/domain/models/login_model.dart';
import 'package:flutter_igl_cng/feature/reportEquipmenyComplaint/viewEquipmentComplaint/domain/bloc/view_equipment_complaint_bloc.dart';
import 'package:flutter_igl_cng/feature/reviewComplaint/domain/bloc/review_complaint_bloc.dart';
import 'package:flutter_igl_cng/feature/reviewComplaint/presentation/page/review_complaint_page.dart';
import 'package:flutter_igl_cng/feature/reviewComplaint/presentation/widget/review_complaint_item_box.dart';
import 'package:flutter_igl_cng/utils/commonClass/user_info.dart';

class ViewEquipmentComplaintPage extends StatefulWidget {
  const ViewEquipmentComplaintPage({super.key});

  @override
  State<ViewEquipmentComplaintPage> createState() =>
      _ViewEquipmentComplaintPageState();
}

class _ViewEquipmentComplaintPageState
    extends State<ViewEquipmentComplaintPage> {


  @override
  void initState() {
    BlocProvider.of<ViewEquipmentComplaintBloc>(context).add(
        ViewEquipmentComplaintPageLoadEvent(context: context));
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: TextWidget("View Equipment Complaint", color: AppColor.white,),
      ),
      body: BlocBuilder<ViewEquipmentComplaintBloc, ViewEquipmentComplaintState>(
        builder: (context, state) {
          if(state is FetchViewEquipmentComplaintDataState) {
            return _listBuilder(dataState: state);
          } else {
            return const Center(child: CenterLoaderWidget(),);
          }

        },
      ),
    );
  }

  Widget _listBuilder({required FetchViewEquipmentComplaintDataState dataState}) {
    return Container(
      margin: const EdgeInsets.all(10.0),
      child: dataState.reviewComplaintList.isNotEmpty ?
      ListView.builder(
          itemCount: dataState.reviewComplaintList.length,
          shrinkWrap: true,
          itemBuilder: (context, index) {
          return GestureDetector(
              onTap: () {
                  LoginDataModel userLogin =  UserInfo.instanceInit()!.userData!;
                  if(userLogin.roleType == RoleType.shiftEngineer) {
                    BlocProvider.of<ReviewComplaintBloc>(context).add(
                        ReviewComplaintPageLoadEvent(context: context, reviewComplaintData: dataState.reviewComplaintList[index]));
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => const ReviewComaplintPage()),
                        );
                  }
              },
              child: ReviewComplaintItemBox(reviewComplaintData: dataState.reviewComplaintList[index],));
      }): const Center(child: TextWidget("No Data"),),
    );
  }

}
