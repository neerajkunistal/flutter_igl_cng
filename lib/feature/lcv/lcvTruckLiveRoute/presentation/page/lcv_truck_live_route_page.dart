import 'package:flutter/material.dart';
import 'package:flutter_igl_cng/ExportFile/app_export_file.dart';
import 'package:flutter_igl_cng/feature/lcv/lcvTruckLiveRoute/domain/bloc/lcv_truck_live_route_bloc.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class LcvTruckLiveRoutePage extends StatefulWidget {
  final String driverUserId;
  final String routeId;

  const LcvTruckLiveRoutePage(
      {super.key, required this.driverUserId, required this.routeId});

  @override
  State<LcvTruckLiveRoutePage> createState() => _LcvTruckLiveRoutePageState();
}

class _LcvTruckLiveRoutePageState extends State<LcvTruckLiveRoutePage> {
  @override
  void initState() {
    BlocProvider.of<LcvTruckLiveRouteBloc>(context).add(
        LcvTruckLiveRoutePageLoadEvent(
            context: context,
            driverUserId: widget.driverUserId,
            routeId: widget.routeId.toString()));
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0.0,
        title: TextWidget(
          AppString.liveTracking,
          color: AppColor.white,
          fontSize: AppFont.font_16,
        ),
      ),
      body: BlocBuilder<LcvTruckLiveRouteBloc, LcvTruckLiveRouteState>(
        builder: (context, state) {
          if (state is FetchLcvTruckLiveRouteDataState) {
            return _googleMap(dataState: state);
          } else {
            return const CenterLoaderWidget();
          }
        },
      ),
    );
  }

  Widget _googleMap({required FetchLcvTruckLiveRouteDataState dataState}) {
    return dataState.isLoader == false
        ? GoogleMap(
            myLocationEnabled: false,
            initialCameraPosition: CameraPosition(
              target: dataState.latLng,
              zoom: 14.4746,
            ),
            compassEnabled: false,
            zoomGesturesEnabled: true,
            myLocationButtonEnabled: false,
            mapType: MapType.normal,
            zoomControlsEnabled: true,
            markers: dataState.markerTrackingPoints,
            polylines: dataState.polyline,
            onMapCreated: (GoogleMapController controller) async {},
          )
        : const CenterLoaderWidget();
  }
}
