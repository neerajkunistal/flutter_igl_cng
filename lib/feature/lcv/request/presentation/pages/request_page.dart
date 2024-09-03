import 'package:flutter/material.dart';
import 'package:flutter_igl_cng/ExportFile/app_export_file.dart';
import 'package:flutter_igl_cng/feature/lcv/request/domain/bloc/request_bloc.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class RequestPage extends StatefulWidget {
  const RequestPage({super.key});

  @override
  State<RequestPage> createState() => _RequestPageState();
}

class _RequestPageState extends State<RequestPage> {
  @override
  void initState() {
    BlocProvider.of<RequestBloc>(context)
        .add(RequestPageEvent(context: context));
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColor.white,
      appBar: AppBar(
        title: TextWidget(
          AppString.request,
          fontSize: AppFont.font_16,
          color: AppColor.white,
        ),
      ),
      body: BlocBuilder<RequestBloc, RequestState>(
        builder: (context, state) {
          if (state is FetchRequestDataState) {
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

  Widget _itemBuilder({required FetchRequestDataState dataState}) {
    return Stack(
      children: [
        _googleMap(dataState: dataState),
      ],
    );
  }

  Widget _googleMap({required FetchRequestDataState dataState}) {
    return GoogleMap(
      myLocationEnabled: false,
      initialCameraPosition: CameraPosition(
        target: LatLng(dataState.currentLat, dataState.currentLong),
        zoom: 14.4746,
      ),
      compassEnabled: true,
      zoomGesturesEnabled: true,
      myLocationButtonEnabled: false,
      mapType: MapType.normal,
      zoomControlsEnabled: false,
/*      markers: dataState.routeMapMarker,
      polylines: dataState.polylineList,*/
      onMapCreated: (GoogleMapController controller) async {
        // mapController = controller;
        // await callAPI();
      },
    );
  }
}
