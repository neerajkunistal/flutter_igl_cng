import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_igl_cng/ExportFile/app_export_file.dart';
import 'package:flutter_igl_cng/feature/amo/viewAmoCimplaint/domain/bloc/view_amo_complaint_bloc.dart';
import 'package:flutter_igl_cng/feature/ci/domain/bloc/view_ci_complaint_bloc.dart';
import 'package:flutter_igl_cng/feature/cng/addCng/domain/bloc/add_cng_bloc.dart';
import 'package:flutter_igl_cng/feature/cng/viewCng/domain/domain/bloc/view_cng_bloc.dart';
import 'package:flutter_igl_cng/feature/cv/domain/bloc/view_cv_complaint_bloc.dart';
import 'package:flutter_igl_cng/feature/lcv/assignment/addAssignment/domain/bloc/add_assignment_bloc.dart';
import 'package:flutter_igl_cng/feature/lcv/assignment/viewAssignment/domain/bloc/view_assignment_bloc.dart';
import 'package:flutter_igl_cng/feature/lcv/cngFillingForm/domain/bloc/cng_filling_form_bloc.dart';
import 'package:flutter_igl_cng/feature/lcv/cngScmInfo/addCngScm/domain/bloc/add_cng_scm_bloc.dart';
import 'package:flutter_igl_cng/feature/lcv/cngScmInfo/viewCngScm/domain/bloc/view_cng_scm_bloc.dart';
import 'package:flutter_igl_cng/feature/lcv/cngStation/addCNGStation/domain/bloc/add_cng_station_bloc.dart';
import 'package:flutter_igl_cng/feature/lcv/cngStation/viewCNGStation/domain/bloc/cng_station_bloc.dart';
import 'package:flutter_igl_cng/feature/lcv/driver/registration/domain/bloc/registration_bloc.dart';
import 'package:flutter_igl_cng/feature/lcv/driver/viewDriver/domain/bloc/driver_bloc.dart';
import 'package:flutter_igl_cng/feature/lcv/geoLocation/domain/bloc/geo_location_bloc.dart';
import 'package:flutter_igl_cng/feature/lcv/lcvDashboard/domain/bloc/lcv_dashboard_bloc.dart';
import 'package:flutter_igl_cng/feature/lcv/lcvTrack/addLcvTrack/domain/bloc/add_lcv_track_bloc.dart';
import 'package:flutter_igl_cng/feature/lcv/lcvTrack/viewLcvTrack/domain/bloc/view_lcv_track_bloc.dart';
import 'package:flutter_igl_cng/feature/lcv/lcvTruckLiveRoute/domain/bloc/lcv_truck_live_route_bloc.dart';
import 'package:flutter_igl_cng/feature/lcv/liveTracking/domain/bloc/tracking_bloc.dart';
import 'package:flutter_igl_cng/feature/lcv/navigationRoute/domain/bloc/navigation_route_bloc.dart';
import 'package:flutter_igl_cng/feature/lcv/overSpeedAlert/domain/bloc/over_speed_alert_bloc.dart';
import 'package:flutter_igl_cng/feature/lcv/request/domain/bloc/request_bloc.dart';
import 'package:flutter_igl_cng/feature/lcv/runningTruck/domain/bloc/running_truck_bloc.dart';
import 'package:flutter_igl_cng/feature/lcv/user/addUser/domain/bloc/add_user_bloc.dart';
import 'package:flutter_igl_cng/feature/lcv/user/viewUser/domain/bloc/view_user_bloc.dart';
import 'package:flutter_igl_cng/feature/materialDetail/domain/bloc/material_detail_bloc.dart';
import 'package:flutter_igl_cng/feature/podDetail/domain/bloc/pod_detail_bloc.dart';
import 'package:flutter_igl_cng/feature/scrap/addScrap/domain/bloc/add_scrap_bloc.dart';
import 'package:flutter_igl_cng/feature/sparePart/addSparePart/domain/bloc/add_spare_part_bloc.dart';

MultiProvider blocMultiProvider({required Widget child}) {
  return MultiProvider(
    providers: [
      BlocProvider(create: (BuildContext context) => LoginBloc()),
      BlocProvider(create: (BuildContext context) => DashboardBloc()),
      BlocProvider(create: (BuildContext context) => HomeBloc()),
      BlocProvider(
          create: (BuildContext context) => AddEquipmentComplaintBloc()),
      BlocProvider(create: (BuildContext context) => AcknowledgeBloc()),
      BlocProvider(create: (BuildContext context) => ReviewComplaintBloc()),
      BlocProvider(create: (BuildContext context) => MiComplaintBloc()),
      BlocProvider(
          create: (BuildContext context) => ViewEquipmentComplaintBloc()),
      BlocProvider(
          create: (BuildContext context) => AddAcknowledgeComplaintBloc()),
      BlocProvider(create: (BuildContext context) => AddCngBloc()),
      BlocProvider(create: (BuildContext context) => ViewCngBloc()),
      BlocProvider(create: (BuildContext context) => ViewAmoComplaintBloc()),
      BlocProvider(create: (BuildContext context) => ViewCiComplaintBloc()),
      BlocProvider(create: (BuildContext context) => ViewCvComplaintBloc()),
      BlocProvider(create: (BuildContext context) => AddScrapBloc()),
      BlocProvider(create: (BuildContext context) => RequestBloc()),
      BlocProvider(create: (BuildContext context) => CngFillingFormBloc()),
      BlocProvider(create: (BuildContext context) => TrackingBloc()),
      BlocProvider(create: (BuildContext context) => AddAssignmentBloc()),
      BlocProvider(create: (BuildContext context) => RegistrationBloc()),
      BlocProvider(create: (BuildContext context) => ViewAssignmentBloc()),
      BlocProvider(create: (BuildContext context) => GeoLocationBloc()),
      BlocProvider(create: (BuildContext context) => AddCngStationBloc()),
      BlocProvider(create: (BuildContext context) => CngStationBloc()),
      BlocProvider(create: (BuildContext context) => DriverBloc()),
      BlocProvider(create: (BuildContext context) => ViewLcvTrackBloc()),
      BlocProvider(create: (BuildContext context) => AddLcvTrackBloc()),
      BlocProvider(create: (BuildContext context) => AddUserBloc()),
      BlocProvider(create: (BuildContext context) => ViewUserBloc()),
      BlocProvider(create: (BuildContext context) => RunningTruckBloc()),
      BlocProvider(create: (BuildContext context) => NavigationRouteBloc()),
      BlocProvider(create: (BuildContext context) => ViewCngScmBloc()),
      BlocProvider(create: (BuildContext context) => AddCngScmBloc()),
      BlocProvider(create: (BuildContext context) => LcvTruckLiveRouteBloc()),
      BlocProvider(create: (BuildContext context) => MaterialDetailBloc()),
      BlocProvider(create: (BuildContext context) => PodDetailBloc()),
      BlocProvider(create: (BuildContext context) => LcvDashboardBloc()),
      BlocProvider(create: (BuildContext context) => OverSpeedAlertBloc()),
      BlocProvider(create: (BuildContext context) => AddSparePartBloc()),

    ],
    child: child,
  );
}
