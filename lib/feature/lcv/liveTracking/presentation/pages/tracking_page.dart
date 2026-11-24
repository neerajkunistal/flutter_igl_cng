import 'package:flutter/material.dart';
import 'package:flutter_igl_cng/ExportFile/app_export_file.dart';
import 'package:flutter_igl_cng/feature/home/presentation/widget/app_bar_widget.dart';
import 'package:flutter_igl_cng/feature/home/presentation/widget/home_drawer_widget.dart';
import 'package:flutter_igl_cng/feature/lcv/liveTracking/presentation/widget/tracking_widget.dart';

class TrackingPage extends StatefulWidget {
  const TrackingPage({super.key});

  @override
  State<TrackingPage> createState() => _TrackingPageState();
}

class _TrackingPageState extends State<TrackingPage> {
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      drawer: HomeDrawerWidget(),
      body: Stack(
        children: [
          const TrackingWidget(),
          Positioned(
            top: MediaQuery.of(context).size.height * 0.03,
            child: AppBarWidget(
              titleName: AppString.appName,
              scaffoldKey: _scaffoldKey,
            ),
          ),
        ],
      ),
    );
  }
}
