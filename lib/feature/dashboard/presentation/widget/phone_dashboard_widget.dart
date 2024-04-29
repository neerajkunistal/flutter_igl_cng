import 'package:flutter/material.dart';
import 'package:flutter_igl_cng/ExportFile/app_export_file.dart';
import 'package:flutter_igl_cng/feature/acknowledge/presentation/page/acknowledge_page.dart';
import 'package:flutter_igl_cng/feature/dashboard/domain/bloc/dashboard_bloc.dart';
import 'package:flutter_igl_cng/feature/dashboard/presentation/widget/profile_widget.dart';
import 'package:flutter_igl_cng/feature/dashboard/presentation/widget/report_widget.dart';
import 'package:flutter_igl_cng/feature/dashboard/presentation/widget/service_center_network_widget.dart';
import 'package:flutter_igl_cng/feature/home/domain/bloc/home_bloc.dart';
import 'package:flutter_igl_cng/feature/login/domain/models/login_model.dart';
import 'package:flutter_igl_cng/feature/miComplaint/presentation/page/mi_complaint_page.dart';
import 'package:flutter_igl_cng/feature/reportEquipmenyComplaint/addEquipmentComplaint/presentation/page/add_equipment_complaint_page.dart';
import 'package:flutter_igl_cng/feature/reportEquipmenyComplaint/viewEquipmentComplaint/presentaion/page/view_equipment_complaint_page.dart';
import 'package:flutter_igl_cng/feature/stationEngineer/page/station_engineer_page.dart';
import 'package:flutter_igl_cng/utils/commonClass/user_info.dart';

class PhoneDashboardWidget extends StatefulWidget {
  const PhoneDashboardWidget({super.key,});

  @override
  State<PhoneDashboardWidget> createState() => _PhoneDashboardWidgetState();
}

class _PhoneDashboardWidgetState extends State<PhoneDashboardWidget> {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<HomeBloc, HomeState>(
        builder: (context, state) {
          if(state is FetchHomeDataState){
            return _listBuilder(dataState: state);
          } else {
            return const SizedBox.shrink();
          }
        }
    );
  }

  Widget _listBuilder({required FetchHomeDataState dataState}) {
    LoginDataModel userData =  UserInfo.instanceInit()!.userData!;

    return Container(
       margin: const EdgeInsets.all(10.0),
       child:  Center(
         child: Column(
           crossAxisAlignment: CrossAxisAlignment.center,
           mainAxisAlignment: MainAxisAlignment.center,
           children: [
             userData.roleType == RoleType.stationUser
                 ? SizedBox(
               height: MediaQuery.of(context).size.height * 0.08,
               child: Padding(
                 padding: const EdgeInsets.all(8.0),
                 child: ElevatedButton.icon(
                   style: ButtonStyle(
                     backgroundColor: MaterialStateProperty.all(Colors.white),
                   ),
                   onPressed: () {
                     LoginDataModel userData =  UserInfo.instanceInit()!.userData!;
                     if(userData.roleType == RoleType.stationUser){
                       Navigator.push(
                         context,
                         MaterialPageRoute(builder: (context) => const AddEquipmentComplaintPage()),
                       );
                     } else {
                       SnackBarErrorWidget(context).show(message: "Your are not access");
                     }
                   },
                   icon: Icon(Icons.comment_bank_outlined, color: AppColor.themeColor,),
                   label: const TextWidget("Add Equipment Complaint"),
                 ),
               ),
             ) : const SizedBox.shrink(),

             userData.roleType == RoleType.shiftEngineer
              ? SizedBox(
               height: MediaQuery.of(context).size.height * 0.08,
               child: Padding(
                 padding: const EdgeInsets.all(8.0),
                 child: ElevatedButton.icon(
                   style: ButtonStyle(
                     backgroundColor: MaterialStateProperty.all(Colors.white),
                   ),
                   onPressed: () {
                     Navigator.push(
                       context,
                       MaterialPageRoute(builder: (context) => const AcknowledgePage()),
                     );
                   },
                   icon: Icon(Icons.report_gmailerrorred, color: AppColor.themeColor,),
                   label: const TextWidget("Ack Complaint"),
                 ),
               ),
             ) : const SizedBox.shrink(),
             userData.roleType == RoleType.shiftEngineer
                 ?  SizedBox(
               height: MediaQuery.of(context).size.height * 0.08,
               child: Padding(
                 padding: const EdgeInsets.all(8.0),
                 child: ElevatedButton.icon(
                   style: ButtonStyle(
                     backgroundColor: MaterialStateProperty.all(Colors.white),
                   ),
                   onPressed: () {
                     Navigator.push(
                       context,
                       MaterialPageRoute(builder: (context) => const ViewEquipmentComplaintPage()),
                     );
                   },
                   icon: Icon(Icons.report_gmailerrorred, color: AppColor.themeColor,),
                   label: const TextWidget("Review Complaint"),
                 ),
               ),
             ): const SizedBox.shrink(),

             userData.roleType == RoleType.mi
             ? SizedBox(
               height: MediaQuery.of(context).size.height * 0.08,
               child: Padding(
                 padding: const EdgeInsets.all(8.0),
                 child: ElevatedButton.icon(
                   style: ButtonStyle(
                     backgroundColor: MaterialStateProperty.all(Colors.white),
                   ),
                   onPressed: () {
                     if(userData.roleType == RoleType.mi){
                       Navigator.push(
                         context,
                         MaterialPageRoute(builder: (context) => const MiComplaintPage()),
                       );
                     } else {
                       SnackBarErrorWidget(context).show(message: "Your are not access");
                     }
                   },
                   icon: Icon(Icons.transfer_within_a_station_outlined, color: AppColor.themeColor,),
                   label: const TextWidget("MI Complaint"),
                 ),
               ),
             ): const SizedBox.shrink(),
           ],
         ),
       ),
    );
  }
}
