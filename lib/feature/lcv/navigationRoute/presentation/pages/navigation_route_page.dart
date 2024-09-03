import 'package:flutter/material.dart';
import 'package:flutter_igl_cng/ExportFile/app_export_file.dart';
import 'package:flutter_igl_cng/feature/lcv/navigationRoute/domain/bloc/navigation_route_bloc.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class NavigationRoutePage extends StatefulWidget {
  const NavigationRoutePage({super.key});

  @override
  State<NavigationRoutePage> createState() => _NavigationRoutePageState();
}

class _NavigationRoutePageState extends State<NavigationRoutePage> {
  var count = 0.0;
  bool flag = true;

  @override
  void initState() {
    routeRefresh();
    super.initState();
  }

  routeRefresh() async {
    while (flag) {
      count++;
      /*  _goToTheLake();*/
      await Future.delayed(const Duration(seconds: 2));
      BlocProvider.of<NavigationRouteBloc>(context)
          .add(NavigationRouteRefreshPageEvent(context: context));
/*     _goToTheLake();*/
    }
  }

  @override
  void dispose() {
    flag = false;
    super.dispose();
  }

  Completer<GoogleMapController> _controller = Completer();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0.0,
        title: TextWidget(
          AppString.navigationRoute,
          color: AppColor.white,
          fontSize: AppFont.font_16,
        ),
      ),
      body: BlocBuilder<NavigationRouteBloc, NavigationRouteState>(
        builder: (context, state) {
          if (state is FetchNavigationRouteDataState) {
            return _googleMap(dataState: state);
          } else {
            return const CenterLoaderWidget();
          }
        },
      ),
    );
  }

  Widget _itemBuilder({required FetchNavigationRouteDataState dataState}) {
    return SizedBox(
      width: MediaQuery.of(context).size.width,
      height: MediaQuery.of(context).size.height * 0.10,
      child: Card(
        elevation: 2,
        child: Padding(
          padding: EdgeInsets.all(MediaQuery.of(context).size.width * 0.02),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              TextWidget(
                "Remaining Distance : ${dataState.totalDistance.toStringAsFixed(1)} Km",
              ),
              TextWidget(
                "Remaining Time : ${dataState.totalTime}",
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _googleMap({required FetchNavigationRouteDataState dataState}) {
    return dataState.isLoader == false
        ? Stack(
            children: [
              GoogleMap(
                myLocationEnabled: false,
                initialCameraPosition: dataState.cameraPosition,
                compassEnabled: true,
                zoomGesturesEnabled: true,
                myLocationButtonEnabled: false,
                zoomControlsEnabled: true,
                markers: dataState.currentLocationMarker,
                polylines: dataState.polyline,
                onMapCreated: (GoogleMapController controller) async {
                  _controller.complete(controller);
                },
              ),
              Align(
                alignment: Alignment.bottomCenter,
                child: _itemBuilder(dataState: dataState),
              )
            ],
          )
        : const CenterLoaderWidget();
  }

  Future<void> _goToTheLake() async {
    final GoogleMapController controller = await _controller.future;
    await controller.animateCamera(CameraUpdate.newCameraPosition(
        BlocProvider.of<NavigationRouteBloc>(context).cameraPosition));
  }
}
