import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_igl_cng/ExportFile/app_export_file.dart';

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
    ],
    child: child,
  );
}
