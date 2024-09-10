import 'package:flutter/material.dart';
import 'package:flutter_igl_cng/ExportFile/app_export_file.dart';
import 'package:flutter_igl_cng/feature/home/presentation/widget/app_bar_widget.dart';
import 'package:flutter_igl_cng/feature/home/presentation/widget/home_drawer_widget.dart';
import 'package:flutter_igl_cng/feature/lcv/runningTruck/domain/bloc/running_truck_bloc.dart';
import 'package:flutter_igl_cng/feature/lcv/runningTruck/presentation/widget/running_truck_item_box_widget.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class RunningTruckPage extends StatefulWidget {
  const RunningTruckPage({super.key});

  @override
  State<RunningTruckPage> createState() => _RunningTruckPageState();
}

class _RunningTruckPageState extends State<RunningTruckPage> {
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();

  @override
  void initState() {
    BlocProvider.of<RunningTruckBloc>(context)
        .add(RunningTruckPageLoadEvent(context: context));
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: HomeDrawerWidget(),
      key: _scaffoldKey,
      backgroundColor: AppColor.white,
      body: BlocBuilder<RunningTruckBloc, RunningTruckState>(
        builder: (context, state) {
          if (state is FetchRunningTruckDataState) {
            return _itemBuilder(dataState: state);
          } else {
            return _centerLoader();
          }
        },
      ),
    );
  }

  Widget _centerLoader() {
    return const Center(child: CenterLoaderWidget());
  }

  Widget _itemBuilder({required FetchRunningTruckDataState dataState}) {
    return Stack(
      children: [
        _googleMap(dataState: dataState),
        Align(
          alignment: Alignment.bottomCenter,
          child: _listBuilder(dataState: dataState),
        )
      ],
    );
  }

  Widget _googleMap({required FetchRunningTruckDataState dataState}) {
    return dataState.isLoader == false
        ? GoogleMap(
            myLocationEnabled: false,
            initialCameraPosition: CameraPosition(
              target:
                  LatLng(dataState.latLng.latitude, dataState.latLng.longitude),
              zoom: 14.4746,
            ),
            compassEnabled: false,
            zoomGesturesEnabled: true,
            myLocationButtonEnabled: false,
            zoomControlsEnabled: true,
            markers: dataState.markerRunningTruckPoints,
            onMapCreated: (GoogleMapController controller) async {},
          )
        : const CenterLoaderWidget();
  }

  Widget _listBuilder({required FetchRunningTruckDataState dataState}) {
    return Container(
      height: MediaQuery.of(context).size.height * 0.25,
      margin: EdgeInsets.all(MediaQuery.of(context).size.width * 0.03),
      child: ListView.builder(
          itemCount: dataState.assignmentList.length,
          scrollDirection: Axis.horizontal,
          shrinkWrap: true,
          itemBuilder: (context, index) {
            return RunningTruckItemBoxWidget(
                index: index, assignmentData: dataState.assignmentList[index]);
          }),
    );
  }
}
