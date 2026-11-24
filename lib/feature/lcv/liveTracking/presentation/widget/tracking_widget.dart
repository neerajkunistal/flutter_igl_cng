import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_igl_cng/ExportFile/app_export_file.dart';
import 'package:flutter_igl_cng/feature/lcv/liveTracking/domain/bloc/tracking_bloc.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class TrackingWidget extends StatefulWidget {
  const TrackingWidget({super.key});

  @override
  State<TrackingWidget> createState() => _TrackingWidgetState();
}

class _TrackingWidgetState extends State<TrackingWidget> {
  @override
  void initState() {
    BlocProvider.of<TrackingBloc>(context)
        .add(TrackingPageLoadEvent(context: context));
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<TrackingBloc, TrackingState>(
      builder: (context, state) {
        if (state is FetchTrackingDataState) {
          return _itemBuilder(dataState: state);
        } else {
          return _pageLoader();
        }
      },
    );
  }

  Widget _pageLoader() {
    return const Center(child: CenterLoaderWidget());
  }

  Widget _itemBuilder({required FetchTrackingDataState dataState}) {
    return Container(
      child: _googleMap(dataState: dataState),
    );
  }

  Widget _googleMap({required FetchTrackingDataState dataState}) {
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
            onMapCreated: (GoogleMapController controller) async {},
          )
        : _pageLoader();
  }
}
