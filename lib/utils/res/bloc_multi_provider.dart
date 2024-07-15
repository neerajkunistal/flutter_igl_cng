import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_igl_cng/ExportFile/app_export_file.dart';
import 'package:flutter_igl_cng/feature/amo/viewAmoCimplaint/domain/bloc/view_amo_complaint_bloc.dart';
import 'package:flutter_igl_cng/feature/ci/domain/bloc/view_ci_complaint_bloc.dart';
import 'package:flutter_igl_cng/feature/cng/addCng/domain/bloc/add_cng_bloc.dart';
import 'package:flutter_igl_cng/feature/cng/viewCng/domain/domain/bloc/view_cng_bloc.dart';
import 'package:flutter_igl_cng/feature/cv/domain/bloc/view_cv_complaint_bloc.dart';

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
    ],
    child: child,
  );
}
